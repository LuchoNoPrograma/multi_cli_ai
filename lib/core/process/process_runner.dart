import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:uuid/uuid.dart';

class SafeProcessResult {
  const SafeProcessResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
    required this.startedAt,
    required this.completedAt,
    this.timedOut = false,
  });

  final int exitCode;
  final String stdout;
  final String stderr;
  final DateTime startedAt;
  final DateTime completedAt;
  final bool timedOut;

  bool get succeeded => exitCode == 0 && !timedOut;
  String get combinedOutput => [
    stdout,
    stderr,
  ].where((value) => value.trim().isNotEmpty).join('\n').trim();
}

class ProcessRunner {
  ProcessRunner(this.database);

  final AppDatabase database;
  final Uuid _uuid = const Uuid();

  static String? findExecutable(String name) {
    final executableName = Platform.isWindows && !name.endsWith('.exe')
        ? '$name.exe'
        : name;
    final direct = File(executableName);
    if (direct.isAbsolute && direct.existsSync()) return direct.path;
    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    final candidates = <String>[
      if (home != null) '$home/.local/bin/$executableName',
      ...?Platform.environment['PATH']
          ?.split(Platform.isWindows ? ';' : ':')
          .where((item) => item.trim().isNotEmpty)
          .map((item) => '$item${Platform.pathSeparator}$executableName'),
    ];
    for (final candidate in candidates) {
      if (File(candidate).existsSync()) return candidate;
    }
    return null;
  }

  static String resolveExecutable(String name) => findExecutable(name) ?? name;

  Future<SafeProcessResult> run({
    required String executable,
    required List<String> arguments,
    required String summary,
    String? profileId,
    String? workingDirectory,
    Map<String, String>? environment,
    String? stdinText,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final started = DateTime.now().toUtc();
    final logId = _uuid.v4();
    final command = _displayCommand(executable, arguments);
    await database
        .into(database.commandLogs)
        .insert(
          CommandLogsCompanion.insert(
            id: logId,
            profileId: Value(profileId),
            command: command,
            summary: summary,
            status: 'running',
            startedAt: started,
          ),
        );

    Process? process;
    try {
      process = await Process.start(
        resolveExecutable(executable),
        arguments,
        workingDirectory: workingDirectory,
        environment: environment,
        includeParentEnvironment: true,
        runInShell: false,
      );
      if (stdinText != null) process.stdin.write(stdinText);
      await process.stdin.close();

      final stdoutFuture = utf8.decoder
          .bind(process.stdout)
          .join()
          .then(sanitizeOutput);
      final stderrFuture = utf8.decoder
          .bind(process.stderr)
          .join()
          .then(sanitizeOutput);
      var timedOut = false;
      final exitCode = await process.exitCode.timeout(
        timeout,
        onTimeout: () {
          timedOut = true;
          process?.kill(ProcessSignal.sigterm);
          Timer(const Duration(milliseconds: 500), () {
            process?.kill(ProcessSignal.sigkill);
          });
          return 124;
        },
      );
      final stdout = await stdoutFuture;
      final stderr = await stderrFuture;
      final completed = DateTime.now().toUtc();
      await _finishLog(
        logId,
        exitCode: exitCode,
        status: timedOut ? 'timeout' : (exitCode == 0 ? 'success' : 'error'),
        output: [
          stdout,
          stderr,
        ].where((value) => value.trim().isNotEmpty).join('\n'),
        completedAt: completed,
      );
      return SafeProcessResult(
        exitCode: exitCode,
        stdout: stdout,
        stderr: stderr,
        startedAt: started,
        completedAt: completed,
        timedOut: timedOut,
      );
    } on ProcessException catch (error) {
      final completed = DateTime.now().toUtc();
      final message = sanitizeOutput(error.message);
      await _finishLog(
        logId,
        exitCode: 127,
        status: 'error',
        output: message,
        completedAt: completed,
      );
      return SafeProcessResult(
        exitCode: 127,
        stdout: '',
        stderr: message,
        startedAt: started,
        completedAt: completed,
      );
    } finally {
      if (process != null && process.pid > 0) {
        // A completed process ignores this. A child left by a timeout does not.
        process.kill(ProcessSignal.sigkill);
      }
    }
  }

  Future<void> startDetached({
    required String executable,
    required List<String> arguments,
    required String summary,
    String? profileId,
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
  }) async {
    final started = DateTime.now().toUtc();
    final id = _uuid.v4();
    try {
      await Process.start(
        resolveExecutable(executable),
        arguments,
        workingDirectory: workingDirectory,
        environment: environment,
        includeParentEnvironment: includeParentEnvironment,
        runInShell: false,
        mode: ProcessStartMode.detached,
      );
      await database
          .into(database.commandLogs)
          .insert(
            CommandLogsCompanion.insert(
              id: id,
              profileId: Value(profileId),
              command: _displayCommand(executable, arguments),
              summary: summary,
              output: Value(
                workingDirectory == null
                    ? 'Proceso iniciado en una terminal separada.'
                    : 'Proceso iniciado en una terminal separada. '
                          'Directorio: ${sanitizeOutput(workingDirectory)}',
              ),
              status: 'success',
              exitCode: const Value(0),
              startedAt: started,
              completedAt: Value(DateTime.now().toUtc()),
            ),
          );
    } on ProcessException catch (error) {
      await database
          .into(database.commandLogs)
          .insert(
            CommandLogsCompanion.insert(
              id: id,
              profileId: Value(profileId),
              command: _displayCommand(executable, arguments),
              summary: summary,
              output: Value(sanitizeOutput(error.message)),
              status: 'error',
              exitCode: const Value(127),
              startedAt: started,
              completedAt: Value(DateTime.now().toUtc()),
            ),
          );
      rethrow;
    }
  }

  Future<void> startInTerminal({
    required String executable,
    required List<String> arguments,
    required String summary,
    String? profileId,
    String? workingDirectory,
    String? title,
  }) async {
    final target = resolveExecutable(executable);
    final launchDirectory = workingDirectory == null
        ? null
        : Directory(workingDirectory).absolute.path;
    final terminalEnvironment = buildTerminalEnvironment(Platform.environment);
    if (Platform.isLinux) {
      const candidates = [
        'gnome-terminal',
        'kgx',
        'konsole',
        'x-terminal-emulator',
      ];
      for (final candidate in candidates) {
        final terminal = findExecutable(candidate);
        if (terminal == null) continue;
        await startDetached(
          executable: terminal,
          arguments: buildTerminalArguments(
            terminal: candidate,
            target: target,
            arguments: arguments,
            workingDirectory: launchDirectory,
            title: title,
          ),
          summary: summary,
          profileId: profileId,
          workingDirectory: launchDirectory,
          environment: terminalEnvironment,
          includeParentEnvironment: false,
        );
        _scheduleLinuxTerminalActivation(title);
        return;
      }
    } else if (Platform.isWindows) {
      final terminal = findExecutable('wt');
      if (terminal != null) {
        await startDetached(
          executable: terminal,
          arguments: buildTerminalArguments(
            terminal: 'wt',
            target: target,
            arguments: arguments,
            workingDirectory: launchDirectory,
            title: title,
          ),
          summary: summary,
          profileId: profileId,
          workingDirectory: launchDirectory,
          environment: terminalEnvironment,
          includeParentEnvironment: false,
        );
        _scheduleWindowsTerminalActivation(title);
        return;
      }
    }
    throw StateError(
      'No se encontró una terminal compatible para abrir el comando.',
    );
  }

  static List<String> buildTerminalArguments({
    required String terminal,
    required String target,
    required List<String> arguments,
    String? workingDirectory,
    String? title,
  }) => switch (terminal) {
    'gnome-terminal' || 'kgx' => [
      if (title != null) '--title=$title',
      if (workingDirectory != null) '--working-directory=$workingDirectory',
      '--',
      target,
      ...arguments,
    ],
    'konsole' => [
      if (title != null) ...['-p', 'tabtitle=$title'],
      if (workingDirectory != null) ...['--workdir', workingDirectory],
      '-e',
      target,
      ...arguments,
    ],
    'wt' => [
      '--window',
      'new',
      'new-tab',
      if (title != null) ...['--title', title],
      if (workingDirectory != null) ...['-d', workingDirectory],
      target,
      ...arguments,
    ],
    _ => [
      if (title != null) ...['-T', title],
      '-e',
      target,
      ...arguments,
    ],
  };

  static Map<String, String> buildTerminalEnvironment(
    Map<String, String> parent,
  ) => Map<String, String>.of(parent)..remove('NO_COLOR');

  void _scheduleLinuxTerminalActivation(String? title) {
    if (!Platform.isLinux || title == null || title.isEmpty) return;
    final sessionType = Platform.environment['XDG_SESSION_TYPE'];
    if (sessionType?.toLowerCase() == 'wayland') return;
    final xdotool = findExecutable('xdotool');
    if (xdotool == null) return;
    unawaited(_activateLinuxTerminalWindow(xdotool, title));
  }

  void _scheduleWindowsTerminalActivation(String? title) {
    if (!Platform.isWindows || title == null || title.isEmpty) return;
    final powershell = findExecutable('powershell') ?? findExecutable('pwsh');
    if (powershell == null) return;
    unawaited(_activateWindowsTerminalWindow(powershell, title));
  }

  Future<void> _activateLinuxTerminalWindow(
    String xdotool,
    String title,
  ) async {
    final pattern = RegExp.escape(title);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      for (var attempt = 0; attempt < 4; attempt++) {
        final search = await Process.run(xdotool, [
          'search',
          '--name',
          '--limit',
          '1',
          pattern,
        ]);
        final windowId = search.stdout.toString().trim().split('\n').first;
        if (search.exitCode == 0 && windowId.isNotEmpty) {
          await Process.run(xdotool, ['windowactivate', windowId]);
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
    } on ProcessException {
      // Focusing is best-effort; launching the terminal already succeeded.
    }
  }

  Future<void> _activateWindowsTerminalWindow(
    String powershell,
    String title,
  ) async {
    const script = r'''
Add-Type -TypeDefinition '
using System;
using System.Runtime.InteropServices;
public static class MultiCliWindow {
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
}'
for ($attempt = 0; $attempt -lt 5; $attempt++) {
  $window = Get-Process -Name 'WindowsTerminal*' -ErrorAction SilentlyContinue |
    Where-Object { $_.MainWindowTitle -and $_.MainWindowTitle.Contains($env:MULTICLI_TERMINAL_TITLE) } |
    Select-Object -First 1
  if ($null -ne $window) {
    [MultiCliWindow]::ShowWindowAsync($window.MainWindowHandle, 9) | Out-Null
    [MultiCliWindow]::SetForegroundWindow($window.MainWindowHandle) | Out-Null
    exit 0
  }
  Start-Sleep -Milliseconds 250
}
''';
    try {
      await Process.start(
        powershell,
        [
          '-NoLogo',
          '-NoProfile',
          '-NonInteractive',
          '-WindowStyle',
          'Hidden',
          '-Command',
          script,
        ],
        environment: {'MULTICLI_TERMINAL_TITLE': title},
        includeParentEnvironment: true,
        mode: ProcessStartMode.detached,
      );
    } on ProcessException {
      // Focusing is best-effort; launching Windows Terminal already succeeded.
    }
  }

  Future<void> addInternalLog({
    required String summary,
    required String status,
    required String output,
    String? profileId,
    String command = 'internal',
  }) => database
      .into(database.commandLogs)
      .insert(
        CommandLogsCompanion.insert(
          id: _uuid.v4(),
          profileId: Value(profileId),
          command: command,
          summary: summary,
          output: Value(sanitizeOutput(output)),
          status: status,
          startedAt: DateTime.now().toUtc(),
          completedAt: Value(DateTime.now().toUtc()),
        ),
      );

  Future<void> _finishLog(
    String id, {
    required int exitCode,
    required String status,
    required String output,
    required DateTime completedAt,
  }) =>
      (database.update(
        database.commandLogs,
      )..where((row) => row.id.equals(id))).write(
        CommandLogsCompanion(
          exitCode: Value(exitCode),
          status: Value(status),
          output: Value(sanitizeOutput(output)),
          completedAt: Value(completedAt),
        ),
      );

  static String sanitizeOutput(String value) {
    var clean = value;
    final patterns = <RegExp>[
      RegExp(r'sk-[A-Za-z0-9_-]{8,}'),
      RegExp(
        r'((?:access|refresh|id)[_-]?token\s*[=:]\s*)[^\s,}\]]+',
        caseSensitive: false,
      ),
      RegExp(r'(authorization:\s*bearer\s+)[^\s]+', caseSensitive: false),
      RegExp(r'(api[_-]?key\s*[=:]\s*)[^\s,}\]]+', caseSensitive: false),
    ];
    for (final pattern in patterns) {
      clean = clean.replaceAllMapped(pattern, (match) {
        final prefix = match.groupCount > 0 ? (match.group(1) ?? '') : '';
        return prefix.isEmpty
            ? '[REDACTADO]'
            : '${prefix.trimRight()} [REDACTADO]';
      });
    }
    return clean.length > 12000
        ? '${clean.substring(0, 12000)}\n[truncado]'
        : clean;
  }

  static String _displayCommand(String executable, List<String> arguments) {
    String quote(String value) =>
        RegExp(r'^[A-Za-z0-9_./:@=-]+$').hasMatch(value)
        ? value
        : '"${value.replaceAll('"', '\\"')}"';
    return [executable, ...arguments].map(quote).join(' ');
  }
}
