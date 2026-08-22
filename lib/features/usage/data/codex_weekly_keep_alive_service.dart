import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/process/process_runner.dart';
import 'package:multi_cli_ai/features/accounts/domain/account_models.dart';
import 'package:multi_cli_ai/providers/codex/codex_app_server_client.dart';

typedef KeepAliveCommand =
    Future<SafeProcessResult> Function(CliProfile profile, String prompt);
typedef KeepAliveProbe =
    Future<CodexRefreshResult> Function(CliProfile profile);
typedef KeepAliveTimerFactory =
    Timer Function(Duration duration, void Function() callback);

enum KeepAliveOutcome { verified, unverified, skipped, failed }

class KeepAliveRunResult {
  const KeepAliveRunResult({
    required this.outcome,
    required this.message,
    this.verifiedResetAt,
  });

  final KeepAliveOutcome outcome;
  final String message;
  final DateTime? verifiedResetAt;

  bool get commandSucceeded =>
      outcome == KeepAliveOutcome.verified ||
      outcome == KeepAliveOutcome.unverified;
}

class CodexWeeklyKeepAliveService {
  CodexWeeklyKeepAliveService({
    required this.database,
    required this.runner,
    this.command,
    KeepAliveProbe? probe,
    DateTime Function()? now,
    Future<void> Function(Duration)? delay,
    KeepAliveTimerFactory? timerFactory,
    this.verificationDelay = const Duration(seconds: 5),
  }) : _probe = probe ?? _probeCodex,
       _now = now ?? DateTime.now,
       _delay = delay ?? Future<void>.delayed,
       _timerFactory = timerFactory ?? _createTimer;

  static const weeklyMinutes = 7 * 24 * 60;
  static const _virginUsageThreshold = 1.0;
  static const _ambiguousProbeDelay = Duration(seconds: 45);
  static const _resetProbeMargin = Duration(seconds: 30);
  static const _projectionTolerance = Duration(minutes: 3);
  static const _stableAnchorTolerance = Duration(seconds: 2);
  static const _minimumDriftSample = Duration(seconds: 20);

  final AppDatabase database;
  final ProcessRunner runner;
  final KeepAliveCommand? command;
  final KeepAliveProbe _probe;
  final DateTime Function() _now;
  final Future<void> Function(Duration) _delay;
  final KeepAliveTimerFactory _timerFactory;
  final Duration verificationDelay;
  final Queue<_KeepAliveRequest> _queue = Queue<_KeepAliveRequest>();
  final Queue<CliProfile> _probeQueue = Queue<CliProfile>();
  final Set<String> _scheduledProfiles = <String>{};
  final Set<String> _queuedProbeProfiles = <String>{};
  final Set<String> _retainedProfiles = <String>{};
  final Set<String> _initialProbeQueued = <String>{};
  final Map<String, Timer> _probeTimers = <String, Timer>{};
  final Map<String, DateTime> _probeDeadlines = <String, DateTime>{};

  Future<void>? _drainFuture;
  Future<void>? _probeDrainFuture;
  bool _enabled = true;
  bool _profilesConstrained = false;

  bool get enabled => _enabled;

  set enabled(bool value) {
    _enabled = value;
    if (value) return;
    for (final timer in _probeTimers.values) {
      timer.cancel();
    }
    _probeTimers.clear();
    _probeDeadlines.clear();
    _probeQueue.clear();
    _queuedProbeProfiles.clear();
    _initialProbeQueued.clear();
    while (_queue.isNotEmpty) {
      final request = _queue.removeFirst();
      _scheduledProfiles.remove(request.profile.id);
      request.completer?.complete(
        const KeepAliveRunResult(
          outcome: KeepAliveOutcome.skipped,
          message: 'El inicio automático de ventanas está desactivado.',
        ),
      );
    }
  }

  void dispose() => enabled = false;

  DateTime? nextProbeAt(String profileId) => _probeDeadlines[profileId];

  void monitorProfiles(Iterable<CliProfile> profiles) {
    final byId = {for (final profile in profiles) profile.id: profile};
    retainProfiles(byId.keys);
    _initialProbeQueued.retainAll(byId.keys);
    if (!enabled) return;
    for (final profile in byId.values) {
      if (_initialProbeQueued.add(profile.id)) {
        _enqueueScheduledProbe(profile);
      }
    }
  }

  void retainProfiles(Iterable<String> profileIds) {
    final retained = profileIds.toSet();
    _profilesConstrained = true;
    _retainedProfiles
      ..clear()
      ..addAll(retained);
    for (final profileId in _probeTimers.keys.toList()) {
      if (!retained.contains(profileId)) _cancelProbe(profileId);
    }
  }

  Future<void> recordProbeFailure(CliProfile profile, Object error) async {
    if (!enabled || profile.toolKey != 'codex') return;
    final stored = await _loadState(profile.id);
    await _recordProbeFailure(profile, stored, error.toString());
  }

  bool scheduleIfEligible(CliProfile profile, CodexRefreshResult result) {
    return _enqueueObservation(profile, result);
  }

  bool _enqueueObservation(
    CliProfile profile,
    CodexRefreshResult result, {
    Completer<KeepAliveRunResult>? completer,
  }) {
    if (!enabled || profile.toolKey != 'codex') return false;
    _cancelProbe(profile.id);
    if (!_scheduledProfiles.add(profile.id)) return false;
    _queue.add(
      _KeepAliveRequest(
        profile: profile,
        refreshResult: result,
        force: false,
        completer: completer,
      ),
    );
    _drainFuture ??= _drainLoop();
    return true;
  }

  Future<KeepAliveRunResult> runNow(
    CliProfile profile, {
    int? expectedWindowMinutes,
  }) {
    if (!enabled) {
      return Future.value(
        const KeepAliveRunResult(
          outcome: KeepAliveOutcome.skipped,
          message: 'El inicio de ventanas está desactivado.',
        ),
      );
    }
    if (profile.toolKey != 'codex') {
      return Future.value(
        const KeepAliveRunResult(
          outcome: KeepAliveOutcome.skipped,
          message: 'El heartbeat sólo está disponible para Codex.',
        ),
      );
    }
    if (!_scheduledProfiles.add(profile.id)) {
      return Future.value(
        const KeepAliveRunResult(
          outcome: KeepAliveOutcome.skipped,
          message: 'Ya hay un heartbeat en curso para esta cuenta.',
        ),
      );
    }
    final completer = Completer<KeepAliveRunResult>();
    _queue.add(
      _KeepAliveRequest(
        profile: profile,
        force: true,
        expectedWindowMinutes: expectedWindowMinutes,
        completer: completer,
      ),
    );
    _drainFuture ??= _drainLoop();
    return completer.future;
  }

  Future<void> waitUntilIdle() async {
    while (_drainFuture != null || _probeDrainFuture != null) {
      final pending = _probeDrainFuture ?? _drainFuture;
      if (pending != null) await pending;
    }
  }

  Future<void> _drainLoop() async {
    try {
      while (_queue.isNotEmpty) {
        final request = _queue.removeFirst();
        KeepAliveRunResult result;
        try {
          result = await _handle(request);
        } catch (error) {
          final message = ProcessRunner.sanitizeOutput(error.toString());
          result = KeepAliveRunResult(
            outcome: KeepAliveOutcome.failed,
            message: message,
          );
          try {
            await runner.addInternalLog(
              summary: 'Iniciar ventana de ${request.profile.displayName}',
              status: 'error',
              output: message,
              profileId: request.profile.id,
              command: 'codex exec --ephemeral',
            );
          } catch (_) {
            // Background errors must not interrupt quota refreshes.
          }
        } finally {
          _scheduledProfiles.remove(request.profile.id);
        }
        request.completer?.complete(result);
      }
    } finally {
      _drainFuture = null;
      if (enabled && _queue.isNotEmpty) _drainFuture = _drainLoop();
    }
  }

  Future<KeepAliveRunResult> _handle(_KeepAliveRequest request) async {
    if (!enabled) {
      return const KeepAliveRunResult(
        outcome: KeepAliveOutcome.skipped,
        message: 'El inicio automático de ventanas está desactivado.',
      );
    }

    final stored = await _loadState(request.profile.id);
    if (request.force) {
      final duration =
          request.expectedWindowMinutes ??
          stored.observation?.windowDurationMinutes ??
          weeklyMinutes;
      return _execute(
        request.profile,
        before: stored.observation,
        expectedWindowMinutes: duration,
        previousState: stored,
      );
    }

    final refresh = request.refreshResult!;
    if (refresh.state != UsageCheckState.success &&
        refresh.state != UsageCheckState.partial) {
      return _recordProbeFailure(
        request.profile,
        stored,
        refresh.errorMessage ?? 'No se pudo leer la cuota de Codex.',
      );
    }
    final window = _selectWindow(refresh.windows, weeklyMinutes);
    if (window == null) {
      _cancelProbe(request.profile.id);
      await _saveState(
        request.profile.id,
        stored.withStatus(
          'unsupported',
          'La lectura actual no contiene una ventana semanal de Codex.',
          clearRetry: true,
        ),
      );
      return const KeepAliveRunResult(
        outcome: KeepAliveOutcome.skipped,
        message: 'La cuenta no expone una ventana semanal en esta lectura.',
      );
    }

    final current = _WindowObservation.fromSnapshot(
      window,
      observedAt: refresh.completedAt,
      accountEmail: refresh.accountEmail,
      planType: refresh.planType,
    );
    var previous = stored.observation;
    if (previous == null ||
        !previous.observedAt.isBefore(current.observedAt) ||
        !_sameIdentity(previous, current)) {
      previous = await _historicalObservationBefore(
        request.profile.id,
        current.observedAt,
      );
      if (previous != null && !_sameIdentity(previous, current)) {
        previous = null;
      }
    }

    final now = _now().toUtc();
    final reset = current.resetsAt;
    final verifiedReset = stored.verifiedResetAt;
    if (verifiedReset != null && verifiedReset.isAfter(now)) {
      _scheduleResetProbe(request.profile, verifiedReset);
      await _saveState(
        request.profile.id,
        stored.withObservation(
          current,
          status: 'verified',
          message: 'La ventana ya fue verificada.',
          clearRetry: true,
        ),
      );
      return KeepAliveRunResult(
        outcome: KeepAliveOutcome.skipped,
        message: 'La ventana semanal ya está activa y verificada.',
        verifiedResetAt: verifiedReset,
      );
    }
    final used = current.usedPercent;
    if (used == null || used > _virginUsageThreshold) {
      if (used != null && reset != null && reset.isAfter(now)) {
        _scheduleResetProbe(request.profile, reset);
      } else {
        _cancelProbe(request.profile.id);
      }
      await _saveState(
        request.profile.id,
        stored.withObservation(
          current,
          status: 'active',
          message: used == null
              ? 'La cuota no informó porcentaje; no se enviará un heartbeat.'
              : 'La ventana semanal ya registra uso.',
          clearRetry: true,
        ),
      );
      return const KeepAliveRunResult(
        outcome: KeepAliveOutcome.skipped,
        message: 'La ventana semanal ya registra actividad.',
      );
    }

    final retryAfter = stored.retryAfter;
    if (retryAfter != null && retryAfter.isAfter(now)) {
      _scheduleProbeAt(request.profile, retryAfter);
      await _saveState(
        request.profile.id,
        stored.withObservation(
          current,
          status: stored.status,
          message: stored.message,
        ),
      );
      return KeepAliveRunResult(
        outcome: KeepAliveOutcome.skipped,
        message:
            'El próximo reintento será después de ${retryAfter.toLocal()}.',
      );
    }

    final clearlyInactive = reset == null || !reset.isAfter(now);
    final resetTransition = _isResetTransition(previous, current, now);
    final floatingProjection = _isFloatingProjection(previous, current);
    if (!clearlyInactive && !resetTransition && !floatingProjection) {
      final sampleAge = previous == null
          ? Duration.zero
          : current.observedAt.difference(previous.observedAt);
      if (previous == null || sampleAge < _minimumDriftSample) {
        _scheduleProbeAfter(request.profile, _ambiguousProbeDelay);
      } else {
        _scheduleResetProbe(request.profile, reset);
      }
      await _saveState(
        request.profile.id,
        stored.withObservation(
          current,
          status: 'observing',
          message: previous == null
              ? 'Se necesita otra lectura para distinguir una ventana activa de una proyección.'
              : 'El ancla semanal parece estable; no se enviará un heartbeat.',
          clearRetry: true,
        ),
      );
      return const KeepAliveRunResult(
        outcome: KeepAliveOutcome.skipped,
        message: 'La ventana no requiere un heartbeat en esta lectura.',
      );
    }

    return _execute(
      request.profile,
      before: current,
      expectedWindowMinutes: weeklyMinutes,
      previousState: stored.withObservation(
        current,
        status: 'candidate',
        message: floatingProjection
            ? 'El reinicio se desplaza con cada lectura.'
            : 'Se observó el fin de la ventana anterior.',
      ),
    );
  }

  Future<KeepAliveRunResult> _execute(
    CliProfile profile, {
    required _WindowObservation? before,
    required int expectedWindowMinutes,
    required _KeepAliveState previousState,
  }) async {
    final now = _now().toUtc();
    final retryCount = previousState.retryCount + 1;
    final retryAfter = now.add(_retryDelay(retryCount));
    await _saveState(
      profile.id,
      _KeepAliveState(
        observation: before,
        status: 'running',
        message: 'Codex está procesando el heartbeat.',
        lastAttemptAt: now,
        lastSuccessAt: previousState.lastSuccessAt,
        verifiedResetAt: previousState.verifiedResetAt,
        retryAfter: retryAfter,
        retryCount: retryCount,
      ),
    );

    SafeProcessResult commandResult;
    try {
      commandResult = await (command ?? _runCodex)(profile, _heartbeatPrompt);
    } catch (error) {
      final message = ProcessRunner.sanitizeOutput(error.toString());
      await _saveState(
        profile.id,
        _KeepAliveState(
          observation: before,
          status: 'failed',
          message: message,
          lastAttemptAt: now,
          lastSuccessAt: previousState.lastSuccessAt,
          verifiedResetAt: previousState.verifiedResetAt,
          retryAfter: retryAfter,
          retryCount: retryCount,
        ),
      );
      _scheduleProbeAt(profile, retryAfter);
      return KeepAliveRunResult(
        outcome: KeepAliveOutcome.failed,
        message: message,
      );
    }
    if (!commandResult.succeeded) {
      final message = commandResult.stderr.trim().isEmpty
          ? 'Codex terminó con código ${commandResult.exitCode}.'
          : ProcessRunner.sanitizeOutput(commandResult.stderr);
      await _saveState(
        profile.id,
        _KeepAliveState(
          observation: before,
          status: 'failed',
          message: message,
          lastAttemptAt: now,
          lastSuccessAt: previousState.lastSuccessAt,
          verifiedResetAt: previousState.verifiedResetAt,
          retryAfter: retryAfter,
          retryCount: retryCount,
        ),
      );
      _scheduleProbeAt(profile, retryAfter);
      return KeepAliveRunResult(
        outcome: KeepAliveOutcome.failed,
        message: message,
      );
    }

    final verification = await _verify(profile, expectedWindowMinutes);
    if (!verification.verified) {
      const message =
          'Codex respondió, pero la cuota todavía no confirmó un ancla estable.';
      await _saveState(
        profile.id,
        _KeepAliveState(
          observation: verification.observation ?? before,
          status: 'unverified',
          message: message,
          lastAttemptAt: now,
          lastSuccessAt: now,
          retryAfter: retryAfter,
          retryCount: retryCount,
        ),
      );
      _scheduleProbeAt(profile, retryAfter);
      await runner.addInternalLog(
        summary: 'Verificar ventana de ${profile.displayName}',
        status: 'error',
        output: message,
        profileId: profile.id,
        command: 'codex app-server account/rateLimits/read',
      );
      return const KeepAliveRunResult(
        outcome: KeepAliveOutcome.unverified,
        message: message,
      );
    }

    final verifiedReset =
        verification.observation?.resetsAt ??
        now.add(Duration(minutes: expectedWindowMinutes));
    const message = 'Heartbeat confirmado con un ancla de reinicio estable.';
    await _saveState(
      profile.id,
      _KeepAliveState(
        observation: verification.observation ?? before,
        status: 'verified',
        message: message,
        lastAttemptAt: now,
        lastSuccessAt: now,
        verifiedResetAt: verifiedReset,
        retryCount: 0,
      ),
    );
    _scheduleResetProbe(profile, verifiedReset);
    await runner.addInternalLog(
      summary: 'Verificar ventana de ${profile.displayName}',
      status: 'success',
      output: message,
      profileId: profile.id,
      command: 'codex app-server account/rateLimits/read',
    );
    return KeepAliveRunResult(
      outcome: KeepAliveOutcome.verified,
      message: message,
      verifiedResetAt: verifiedReset,
    );
  }

  Future<_Verification> _verify(
    CliProfile profile,
    int expectedWindowMinutes,
  ) async {
    try {
      if (verificationDelay > Duration.zero) {
        await _delay(const Duration(seconds: 2));
      }
      final firstResult = await _probe(profile);
      if (verificationDelay > Duration.zero) await _delay(verificationDelay);
      final secondResult = await _probe(profile);
      final firstWindow = _selectWindow(
        firstResult.windows,
        expectedWindowMinutes,
      );
      final secondWindow = _selectWindow(
        secondResult.windows,
        expectedWindowMinutes,
      );
      if (firstWindow == null || secondWindow == null) {
        return const _Verification(verified: false);
      }
      final first = _WindowObservation.fromSnapshot(
        firstWindow,
        observedAt: firstResult.completedAt,
        accountEmail: firstResult.accountEmail,
        planType: firstResult.planType,
      );
      final second = _WindowObservation.fromSnapshot(
        secondWindow,
        observedAt: secondResult.completedAt,
        accountEmail: secondResult.accountEmail,
        planType: secondResult.planType,
      );
      final used = second.usedPercent;
      if (used != null && used > _virginUsageThreshold) {
        return _Verification(verified: true, observation: second);
      }
      final firstReset = first.resetsAt;
      final secondReset = second.resetsAt;
      if (firstReset == null ||
          secondReset == null ||
          !secondReset.isAfter(_now().toUtc())) {
        return _Verification(verified: false, observation: second);
      }
      final anchorMovement = secondReset.difference(firstReset).abs();
      final verified =
          anchorMovement <= _stableAnchorTolerance &&
          !_isFloatingProjection(first, second);
      return _Verification(verified: verified, observation: second);
    } catch (_) {
      return const _Verification(verified: false);
    }
  }

  Future<KeepAliveRunResult> _recordProbeFailure(
    CliProfile profile,
    _KeepAliveState previousState,
    String rawMessage,
  ) async {
    final now = _now().toUtc();
    final retryCount = previousState.retryCount + 1;
    final retryAfter = now.add(_retryDelay(retryCount));
    final message = ProcessRunner.sanitizeOutput(rawMessage);
    await _saveState(
      profile.id,
      _KeepAliveState(
        observation: previousState.observation,
        status: 'probe_failed',
        message: message,
        lastAttemptAt: previousState.lastAttemptAt,
        lastSuccessAt: previousState.lastSuccessAt,
        verifiedResetAt: previousState.verifiedResetAt,
        retryAfter: retryAfter,
        retryCount: retryCount,
      ),
    );
    _scheduleProbeAt(profile, retryAfter);
    await runner.addInternalLog(
      summary: 'Revisar ventana de ${profile.displayName}',
      status: 'error',
      output: '$message Reintento con backoff.',
      profileId: profile.id,
      command: 'codex app-server account/rateLimits/read',
    );
    return KeepAliveRunResult(
      outcome: KeepAliveOutcome.failed,
      message: message,
    );
  }

  void _scheduleProbeAfter(CliProfile profile, Duration delay) {
    _scheduleProbeAt(profile, _now().toUtc().add(delay));
  }

  void _scheduleResetProbe(CliProfile profile, DateTime resetAt) {
    _scheduleProbeAt(profile, resetAt.toUtc().add(_resetProbeMargin));
  }

  void _scheduleProbeAt(CliProfile profile, DateTime deadline) {
    if (!enabled) return;
    _cancelProbe(profile.id);
    final normalized = deadline.toUtc();
    final delay = normalized.difference(_now().toUtc());
    late final Timer timer;
    timer = _timerFactory(delay.isNegative ? Duration.zero : delay, () {
      if (!identical(_probeTimers[profile.id], timer)) return;
      _probeTimers.remove(profile.id);
      _probeDeadlines.remove(profile.id);
      _enqueueScheduledProbe(profile);
    });
    _probeTimers[profile.id] = timer;
    _probeDeadlines[profile.id] = normalized;
  }

  void _cancelProbe(String profileId) {
    _probeTimers.remove(profileId)?.cancel();
    _probeDeadlines.remove(profileId);
  }

  void _enqueueScheduledProbe(CliProfile profile) {
    if (!enabled || !_queuedProbeProfiles.add(profile.id)) return;
    _probeQueue.add(profile);
    _probeDrainFuture ??= _drainScheduledProbes();
  }

  Future<void> _drainScheduledProbes() async {
    try {
      while (enabled && _probeQueue.isNotEmpty) {
        final profile = _probeQueue.removeFirst();
        try {
          if (!_profilesConstrained || _retainedProfiles.contains(profile.id)) {
            await _runScheduledProbe(profile);
          }
        } finally {
          _queuedProbeProfiles.remove(profile.id);
        }
      }
    } finally {
      _probeDrainFuture = null;
      if (enabled && _probeQueue.isNotEmpty) {
        _probeDrainFuture = _drainScheduledProbes();
      }
    }
  }

  Future<void> _runScheduledProbe(CliProfile profile) async {
    if (!enabled) return;
    try {
      final result = await _probe(profile);
      final completer = Completer<KeepAliveRunResult>();
      if (_enqueueObservation(profile, result, completer: completer)) {
        await completer.future;
      }
    } catch (error) {
      final stored = await _loadState(profile.id);
      await _recordProbeFailure(profile, stored, error.toString());
    }
  }

  static Duration _retryDelay(int retryCount) => switch (retryCount) {
    <= 1 => const Duration(minutes: 15),
    2 => const Duration(hours: 1),
    _ => const Duration(hours: 6),
  };

  Future<SafeProcessResult> _runCodex(CliProfile profile, String prompt) =>
      runner.run(
        executable: 'codex',
        arguments: [
          'exec',
          '--ephemeral',
          '--ignore-user-config',
          '--ignore-rules',
          '--skip-git-repo-check',
          '--sandbox',
          'read-only',
          '--color',
          'never',
          '-C',
          Directory.systemTemp.path,
          '-c',
          'model_reasoning_effort="low"',
          prompt,
        ],
        summary: 'Iniciar ventana de ${profile.displayName}',
        profileId: profile.id,
        workingDirectory: Directory.systemTemp.path,
        environment: {'CODEX_HOME': profile.profileHome, 'NO_COLOR': '1'},
        timeout: const Duration(seconds: 90),
      );

  Future<_WindowObservation?> _historicalObservationBefore(
    String profileId,
    DateTime before,
  ) async {
    final checks =
        await (database.select(database.usageChecks)
              ..where(
                (row) =>
                    row.profileId.equals(profileId) &
                    row.startedAt.isSmallerThanValue(before),
              )
              ..orderBy([(row) => OrderingTerm.desc(row.startedAt)])
              ..limit(20))
            .get();
    for (final check in checks) {
      final windows =
          await (database.select(database.quotaWindows)..where(
                (row) =>
                    row.checkId.equals(check.id) &
                    row.windowDurationMinutes.isBiggerOrEqualValue(
                      weeklyMinutes - 60,
                    ) &
                    row.windowDurationMinutes.isSmallerOrEqualValue(
                      weeklyMinutes + 60,
                    ),
              ))
              .get();
      if (windows.isEmpty) continue;
      windows.sort((left, right) {
        final leftCore = left.limitId.toLowerCase() == 'codex' ? 0 : 1;
        final rightCore = right.limitId.toLowerCase() == 'codex' ? 0 : 1;
        return leftCore.compareTo(rightCore);
      });
      final window = windows.first;
      return _WindowObservation(
        limitId: window.limitId,
        usedPercent: window.usedPercent,
        windowDurationMinutes: window.windowDurationMinutes ?? weeklyMinutes,
        resetsAt: window.resetsAt?.toUtc(),
        observedAt: (check.completedAt ?? check.startedAt).toUtc(),
        accountEmail: check.accountEmail,
        planType: check.planType,
      );
    }
    return null;
  }

  Future<_KeepAliveState> _loadState(String profileId) async {
    final raw = await database.setting(_stateKey(profileId));
    if (raw == null || raw.isEmpty) return const _KeepAliveState();
    try {
      final value = jsonDecode(raw);
      return value is Map<String, dynamic>
          ? _KeepAliveState.fromJson(value)
          : const _KeepAliveState();
    } catch (_) {
      return const _KeepAliveState();
    }
  }

  Future<void> _saveState(String profileId, _KeepAliveState state) =>
      database.saveSetting(_stateKey(profileId), jsonEncode(state.toJson()));

  static QuotaSnapshot? _selectWindow(
    List<QuotaSnapshot> windows,
    int expectedMinutes,
  ) {
    final matching = windows.where((window) {
      final duration = window.windowDurationMinutes;
      return duration != null && (duration - expectedMinutes).abs() <= 60;
    }).toList();
    if (matching.isEmpty) return null;
    matching.sort((left, right) {
      final leftCore = left.limitId.toLowerCase() == 'codex' ? 0 : 1;
      final rightCore = right.limitId.toLowerCase() == 'codex' ? 0 : 1;
      final byCore = leftCore.compareTo(rightCore);
      if (byCore != 0) return byCore;
      return left.windowType.compareTo(right.windowType);
    });
    return matching.first;
  }

  static bool _isResetTransition(
    _WindowObservation? previous,
    _WindowObservation current,
    DateTime now,
  ) {
    final previousReset = previous?.resetsAt;
    final currentReset = current.resetsAt;
    if (previousReset == null || currentReset == null) return false;
    if (previousReset.isAfter(now.add(const Duration(minutes: 1)))) {
      return false;
    }
    return currentReset.isAfter(now) &&
        currentReset.difference(previousReset).abs() > const Duration(hours: 1);
  }

  static bool _isFloatingProjection(
    _WindowObservation? previous,
    _WindowObservation current,
  ) {
    if (previous == null || !_sameIdentity(previous, current)) return false;
    final previousReset = previous.resetsAt;
    final currentReset = current.resetsAt;
    if (previousReset == null || currentReset == null) return false;
    if (!_looksProjected(previous) || !_looksProjected(current)) return false;
    final observedMovement = current.observedAt.difference(previous.observedAt);
    if (observedMovement < _minimumDriftSample) return false;
    final anchorMovement = currentReset.difference(previousReset);
    if (anchorMovement < _minimumDriftSample) return false;
    return (anchorMovement - observedMovement).abs() <= _projectionTolerance;
  }

  static bool _looksProjected(_WindowObservation observation) {
    final reset = observation.resetsAt;
    if (reset == null) return false;
    final expected = observation.observedAt.add(
      Duration(minutes: observation.windowDurationMinutes),
    );
    return reset.difference(expected).abs() <= _projectionTolerance;
  }

  static bool _sameIdentity(_WindowObservation left, _WindowObservation right) {
    final leftEmail = left.accountEmail?.trim().toLowerCase() ?? '';
    final rightEmail = right.accountEmail?.trim().toLowerCase() ?? '';
    if (leftEmail.isNotEmpty &&
        rightEmail.isNotEmpty &&
        leftEmail != rightEmail) {
      return false;
    }
    final leftPlan = left.planType?.trim().toLowerCase() ?? '';
    final rightPlan = right.planType?.trim().toLowerCase() ?? '';
    return leftPlan.isEmpty || rightPlan.isEmpty || leftPlan == rightPlan;
  }

  static String _stateKey(String profileId) =>
      'codex_weekly_keep_alive_state_$profileId';

  static Future<CodexRefreshResult> _probeCodex(CliProfile profile) =>
      const CodexAppServerClient(
        timeout: Duration(seconds: 30),
      ).refresh(profile.profileHome);

  static Timer _createTimer(Duration duration, void Function() callback) =>
      Timer(duration, callback);

  static const _heartbeatPrompt =
      'Responde exactamente OK. No ejecutes comandos, no uses herramientas, '
      'no leas archivos y no hagas preguntas.';
}

class _KeepAliveRequest {
  const _KeepAliveRequest({
    required this.profile,
    required this.force,
    this.refreshResult,
    this.expectedWindowMinutes,
    this.completer,
  });

  final CliProfile profile;
  final bool force;
  final CodexRefreshResult? refreshResult;
  final int? expectedWindowMinutes;
  final Completer<KeepAliveRunResult>? completer;
}

class _Verification {
  const _Verification({required this.verified, this.observation});

  final bool verified;
  final _WindowObservation? observation;
}

class _WindowObservation {
  const _WindowObservation({
    required this.limitId,
    required this.usedPercent,
    required this.windowDurationMinutes,
    required this.resetsAt,
    required this.observedAt,
    this.accountEmail,
    this.planType,
  });

  factory _WindowObservation.fromSnapshot(
    QuotaSnapshot window, {
    required DateTime observedAt,
    String? accountEmail,
    String? planType,
  }) => _WindowObservation(
    limitId: window.limitId,
    usedPercent: window.usedPercent,
    windowDurationMinutes:
        window.windowDurationMinutes ??
        CodexWeeklyKeepAliveService.weeklyMinutes,
    resetsAt: window.resetsAt?.toUtc(),
    observedAt: observedAt.toUtc(),
    accountEmail: accountEmail,
    planType: planType,
  );

  factory _WindowObservation.fromJson(Map<String, dynamic> json) =>
      _WindowObservation(
        limitId: json['limitId'] as String? ?? 'codex',
        usedPercent: (json['usedPercent'] as num?)?.toDouble(),
        windowDurationMinutes:
            (json['windowDurationMinutes'] as num?)?.toInt() ??
            CodexWeeklyKeepAliveService.weeklyMinutes,
        resetsAt: _date(json['resetsAt']),
        observedAt:
            _date(json['observedAt']) ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        accountEmail: json['accountEmail'] as String?,
        planType: json['planType'] as String?,
      );

  final String limitId;
  final double? usedPercent;
  final int windowDurationMinutes;
  final DateTime? resetsAt;
  final DateTime observedAt;
  final String? accountEmail;
  final String? planType;

  Map<String, dynamic> toJson() => {
    'limitId': limitId,
    'usedPercent': usedPercent,
    'windowDurationMinutes': windowDurationMinutes,
    'resetsAt': resetsAt?.toIso8601String(),
    'observedAt': observedAt.toIso8601String(),
    'accountEmail': accountEmail,
    'planType': planType,
  };
}

class _KeepAliveState {
  const _KeepAliveState({
    this.observation,
    this.status = 'unknown',
    this.message = '',
    this.lastAttemptAt,
    this.lastSuccessAt,
    this.verifiedResetAt,
    this.retryAfter,
    this.retryCount = 0,
  });

  factory _KeepAliveState.fromJson(Map<String, dynamic> json) {
    final observation = json['observation'];
    return _KeepAliveState(
      observation: observation is Map<String, dynamic>
          ? _WindowObservation.fromJson(observation)
          : null,
      status: json['status'] as String? ?? 'unknown',
      message: json['message'] as String? ?? '',
      lastAttemptAt: _date(json['lastAttemptAt']),
      lastSuccessAt: _date(json['lastSuccessAt']),
      verifiedResetAt: _date(json['verifiedResetAt']),
      retryAfter: _date(json['retryAfter']),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
    );
  }

  final _WindowObservation? observation;
  final String status;
  final String message;
  final DateTime? lastAttemptAt;
  final DateTime? lastSuccessAt;
  final DateTime? verifiedResetAt;
  final DateTime? retryAfter;
  final int retryCount;

  _KeepAliveState withStatus(
    String status,
    String message, {
    bool clearRetry = false,
  }) => _KeepAliveState(
    observation: observation,
    status: status,
    message: message,
    lastAttemptAt: lastAttemptAt,
    lastSuccessAt: lastSuccessAt,
    verifiedResetAt: verifiedResetAt,
    retryAfter: clearRetry ? null : retryAfter,
    retryCount: clearRetry ? 0 : retryCount,
  );

  _KeepAliveState withObservation(
    _WindowObservation value, {
    required String status,
    required String message,
    bool clearRetry = false,
  }) => _KeepAliveState(
    observation: value,
    status: status,
    message: message,
    lastAttemptAt: lastAttemptAt,
    lastSuccessAt: lastSuccessAt,
    verifiedResetAt: verifiedResetAt,
    retryAfter: clearRetry ? null : retryAfter,
    retryCount: clearRetry ? 0 : retryCount,
  );

  Map<String, dynamic> toJson() => {
    'version': 2,
    'observation': observation?.toJson(),
    'status': status,
    'message': message,
    'lastAttemptAt': lastAttemptAt?.toIso8601String(),
    'lastSuccessAt': lastSuccessAt?.toIso8601String(),
    'verifiedResetAt': verifiedResetAt?.toIso8601String(),
    'retryAfter': retryAfter?.toIso8601String(),
    'retryCount': retryCount,
  };
}

DateTime? _date(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toUtc() : null;
