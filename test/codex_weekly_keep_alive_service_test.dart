import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/process/process_runner.dart';
import 'package:multi_cli_ai/features/accounts/domain/account_models.dart';
import 'package:multi_cli_ai/features/usage/data/codex_weekly_keep_alive_service.dart';

void main() {
  test('Diego floating reset anchor triggers one verified heartbeat', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final profile = _profile('diego');
    await database.into(database.cliProfiles).insert(profile);
    var now = DateTime.utc(2026, 8, 21, 23, 26, 33);
    var starts = 0;
    final timers = _RecordingTimerFactory();
    final stableReset = DateTime.utc(2026, 8, 29, 1, 8, 57);
    final probes = _ProbeSequence([
      _resultWithWindow(
        now.add(const Duration(seconds: 10)),
        used: 0,
        duration: 10080,
        resetAt: stableReset,
      ),
      _resultWithWindow(
        now.add(const Duration(seconds: 20)),
        used: 0,
        duration: 10080,
        resetAt: stableReset,
      ),
    ]);
    final service = CodexWeeklyKeepAliveService(
      database: database,
      runner: runner,
      now: () => now,
      timerFactory: timers.call,
      verificationDelay: Duration.zero,
      probe: probes.call,
      command: (profile, prompt) async {
        starts++;
        return _success();
      },
    );

    service.scheduleIfEligible(
      profile,
      _resultWithWindow(
        now,
        used: 0,
        duration: 10080,
        resetAt: DateTime.utc(2026, 8, 28, 23, 26, 35),
      ),
    );
    await service.waitUntilIdle();
    expect(starts, 0);
    expect(
      service.nextProbeAt(profile.id),
      now.add(const Duration(seconds: 45)),
    );

    now = DateTime.utc(2026, 8, 22, 1, 8, 55);
    service.scheduleIfEligible(
      profile,
      _resultWithWindow(
        now,
        used: 0,
        duration: 10080,
        resetAt: DateTime.utc(2026, 8, 29, 1, 8, 57),
      ),
    );
    await service.waitUntilIdle();

    expect(starts, 1);
    expect(probes.calls, 2);
    final state = await _state(database, profile.id);
    expect(state['status'], 'verified');
    expect(state['verifiedResetAt'], stableReset.toIso8601String());
    expect(
      service.nextProbeAt(profile.id),
      stableReset.add(const Duration(seconds: 30)),
    );
  });

  test(
    'Abejita reset transition triggers heartbeat without a second poll',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final runner = ProcessRunner(database);
      final profile = _profile('abejita');
      await database.into(database.cliProfiles).insert(profile);
      var now = DateTime.utc(2026, 8, 21, 21, 10, 23);
      var starts = 0;
      final stableReset = DateTime.utc(2026, 8, 29, 1, 26, 33);
      final service = CodexWeeklyKeepAliveService(
        database: database,
        runner: runner,
        now: () => now,
        verificationDelay: Duration.zero,
        probe: _ProbeSequence([
          _resultWithWindow(
            now.add(const Duration(seconds: 10)),
            used: 0,
            duration: 10080,
            resetAt: stableReset,
          ),
          _resultWithWindow(
            now.add(const Duration(seconds: 20)),
            used: 0,
            duration: 10080,
            resetAt: stableReset,
          ),
        ]).call,
        command: (profile, prompt) async {
          starts++;
          return _success();
        },
      );

      service.scheduleIfEligible(
        profile,
        _resultWithWindow(
          now,
          used: 100,
          duration: 10080,
          resetAt: DateTime.utc(2026, 8, 21, 23, 23, 23),
        ),
      );
      await service.waitUntilIdle();
      expect(starts, 0);

      now = DateTime.utc(2026, 8, 21, 23, 26, 31);
      service.scheduleIfEligible(
        profile,
        _resultWithWindow(
          now,
          used: 0,
          duration: 10080,
          resetAt: DateTime.utc(2026, 8, 28, 23, 26, 33),
        ),
      );
      await service.waitUntilIdle();

      expect(starts, 1);
      expect((await _state(database, profile.id))['status'], 'verified');
    },
  );

  test(
    'an ambiguous anchor schedules one targeted confirmation probe',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final runner = ProcessRunner(database);
      final profile = _profile('targeted');
      await database.into(database.cliProfiles).insert(profile);
      final initialNow = DateTime.utc(2026, 8, 21, 12);
      var now = initialNow;
      var starts = 0;
      final timers = _RecordingTimerFactory();
      final stableReset = initialNow.add(const Duration(days: 7, minutes: 10));
      final probes = _ProbeSequence([
        _resultWithWindow(
          initialNow.add(const Duration(seconds: 45)),
          used: 0,
          duration: 10080,
          resetAt: initialNow.add(const Duration(days: 7, seconds: 45)),
        ),
        _resultWithWindow(
          initialNow.add(const Duration(seconds: 55)),
          used: 0,
          duration: 10080,
          resetAt: stableReset,
        ),
        _resultWithWindow(
          initialNow.add(const Duration(seconds: 65)),
          used: 0,
          duration: 10080,
          resetAt: stableReset,
        ),
      ]);
      final service = CodexWeeklyKeepAliveService(
        database: database,
        runner: runner,
        now: () => now,
        timerFactory: timers.call,
        verificationDelay: Duration.zero,
        probe: probes.call,
        command: (profile, prompt) async {
          starts++;
          return _success();
        },
      );

      service.scheduleIfEligible(
        profile,
        _resultWithWindow(
          initialNow,
          used: 0,
          duration: 10080,
          resetAt: initialNow.add(const Duration(days: 7)),
        ),
      );
      await service.waitUntilIdle();
      expect(timers.activeTimers.single.duration, const Duration(seconds: 45));

      now = initialNow.add(const Duration(seconds: 45));
      timers.fireActive();
      await _waitFor(() => starts == 1);
      await service.waitUntilIdle();

      expect(probes.calls, 3);
      expect(probes.profileIds, everyElement(profile.id));
      expect(
        service.nextProbeAt(profile.id),
        stableReset.add(const Duration(seconds: 30)),
      );
    },
  );

  test('a stable future reset anchor does not trigger a heartbeat', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final profile = _profile('stable');
    await database.into(database.cliProfiles).insert(profile);
    var now = DateTime.utc(2026, 8, 21, 12);
    var starts = 0;
    final timers = _RecordingTimerFactory();
    final resetAt = DateTime.utc(2026, 8, 28, 12);
    final service = CodexWeeklyKeepAliveService(
      database: database,
      runner: runner,
      now: () => now,
      timerFactory: timers.call,
      probe: (_) async => throw StateError('probe should not run'),
      command: (profile, prompt) async {
        starts++;
        return _success();
      },
    );

    service.scheduleIfEligible(
      profile,
      _resultWithWindow(now, used: 0, duration: 10080, resetAt: resetAt),
    );
    await service.waitUntilIdle();
    expect(
      service.nextProbeAt(profile.id),
      now.add(const Duration(seconds: 45)),
    );
    now = now.add(const Duration(hours: 2));
    service.scheduleIfEligible(
      profile,
      _resultWithWindow(now, used: 0, duration: 10080, resetAt: resetAt),
    );
    await service.waitUntilIdle();

    expect(starts, 0);
    expect((await _state(database, profile.id))['status'], 'observing');
    expect(
      service.nextProbeAt(profile.id),
      resetAt.add(const Duration(seconds: 30)),
    );
    expect(timers.activeTimers, hasLength(1));
  });

  test(
    'Ari plan change to a 30-day window never uses weekly history',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final runner = ProcessRunner(database);
      final profile = _profile('ari');
      await database.into(database.cliProfiles).insert(profile);
      var starts = 0;
      final service = CodexWeeklyKeepAliveService(
        database: database,
        runner: runner,
        probe: (_) async => throw StateError('probe should not run'),
        command: (profile, prompt) async {
          starts++;
          return _success();
        },
      );
      final plusTime = DateTime.utc(2026, 8, 20, 12, 10, 11);

      service.scheduleIfEligible(
        profile,
        _resultWithWindow(
          plusTime,
          used: 6,
          duration: 10080,
          resetAt: DateTime.utc(2026, 8, 27, 13, 49, 49),
          planType: 'plus',
        ),
      );
      await service.waitUntilIdle();
      service.scheduleIfEligible(
        profile,
        _resultWithWindow(
          DateTime.utc(2026, 8, 21, 21, 8, 53),
          used: 0,
          duration: 43200,
          resetAt: DateTime.utc(2026, 9, 20, 21, 8, 55),
          planType: 'free',
        ),
      );
      await service.waitUntilIdle();

      expect(starts, 0);
      expect((await _state(database, profile.id))['status'], 'unsupported');
    },
  );

  test('missing weekly metadata never triggers from old history', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final profile = _profile('partial');
    await database.into(database.cliProfiles).insert(profile);
    var starts = 0;
    final service = CodexWeeklyKeepAliveService(
      database: database,
      runner: runner,
      probe: (_) async => throw StateError('probe should not run'),
      command: (profile, prompt) async {
        starts++;
        return _success();
      },
    );
    final now = DateTime.utc(2026, 8, 20, 12);

    service.scheduleIfEligible(
      profile,
      _resultWithWindow(now, used: 30, duration: 10080),
    );
    await service.waitUntilIdle();
    service.scheduleIfEligible(
      profile,
      CodexRefreshResult(
        state: UsageCheckState.partial,
        startedAt: now.add(const Duration(hours: 1)),
        completedAt: now.add(const Duration(hours: 1)),
        rateLimitsReadSucceeded: true,
      ),
    );
    await service.waitUntilIdle();

    expect(starts, 0);
    expect((await _state(database, profile.id))['status'], 'unsupported');
  });

  test(
    'manual heartbeat is minimal, ephemeral, and verifies the target window',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final runner = _RecordingProcessRunner(database);
      final profile = _profile('manual');
      await database.into(database.cliProfiles).insert(profile);
      final now = DateTime.utc(2026, 8, 21, 12);
      final resetAt = now.add(const Duration(days: 7));
      final service = CodexWeeklyKeepAliveService(
        database: database,
        runner: runner,
        now: () => now,
        verificationDelay: Duration.zero,
        probe: _ProbeSequence([
          _resultWithWindow(
            now.add(const Duration(seconds: 10)),
            used: 0,
            duration: 10080,
            resetAt: resetAt,
          ),
          _resultWithWindow(
            now.add(const Duration(seconds: 20)),
            used: 0,
            duration: 10080,
            resetAt: resetAt,
          ),
        ]).call,
      );

      final result = await service.runNow(
        profile,
        expectedWindowMinutes: 10080,
      );

      expect(result.outcome, KeepAliveOutcome.verified);
      expect(runner.executable, 'codex');
      expect(
        runner.arguments,
        containsAll(<String>[
          'exec',
          '--ephemeral',
          '--ignore-user-config',
          '--ignore-rules',
          '--skip-git-repo-check',
          'read-only',
          'model_reasoning_effort="low"',
        ]),
      );
      expect(runner.arguments?.last, contains('Responde exactamente OK'));
      expect(runner.arguments?.last, isNot(contains('clima')));
      expect(runner.environment?['CODEX_HOME'], profile.profileHome);
      expect(runner.environment?['NO_COLOR'], '1');
      expect(runner.workingDirectory, Directory.systemTemp.path);
      expect(runner.timeout, const Duration(seconds: 90));
    },
  );

  test('failed manual heartbeat is persisted with a short retry', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final profile = _profile('offline');
    await database.into(database.cliProfiles).insert(profile);
    final now = DateTime.utc(2026, 8, 21, 12);
    final timers = _RecordingTimerFactory();
    final service = CodexWeeklyKeepAliveService(
      database: database,
      runner: runner,
      now: () => now,
      timerFactory: timers.call,
      probe: (_) async => throw StateError('probe should not run'),
      command: (profile, prompt) => throw StateError('offline'),
    );

    final result = await service.runNow(profile);

    expect(result.outcome, KeepAliveOutcome.failed);
    final state = await _state(database, profile.id);
    expect(state['status'], 'failed');
    expect(state['retryCount'], 1);
    expect(
      state['retryAfter'],
      now.add(const Duration(minutes: 15)).toIso8601String(),
    );
    expect(
      service.nextProbeAt(profile.id),
      now.add(const Duration(minutes: 15)),
    );
  });

  test(
    'scheduled probe failures back off from 15 minutes to 1 and 6 hours',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final runner = ProcessRunner(database);
      final profile = _profile('backoff');
      await database.into(database.cliProfiles).insert(profile);
      var now = DateTime.utc(2026, 8, 21, 12);
      var probes = 0;
      final timers = _RecordingTimerFactory();
      final service = CodexWeeklyKeepAliveService(
        database: database,
        runner: runner,
        now: () => now,
        timerFactory: timers.call,
        probe: (_) async {
          probes++;
          throw StateError('offline');
        },
      );

      await service.recordProbeFailure(profile, StateError('offline'));
      expect(timers.activeTimers.single.duration, const Duration(minutes: 15));

      now = now.add(const Duration(minutes: 15));
      timers.fireActive();
      await _waitFor(() => probes == 1);
      await _waitForAsync(
        () async => (await _state(database, profile.id))['retryCount'] == 2,
      );
      expect(timers.activeTimers.single.duration, const Duration(hours: 1));

      now = now.add(const Duration(hours: 1));
      timers.fireActive();
      await _waitFor(() => probes == 2);
      await _waitForAsync(
        () async => (await _state(database, profile.id))['retryCount'] == 3,
      );
      expect(timers.activeTimers.single.duration, const Duration(hours: 6));
    },
  );

  test('scheduled account probes run one at a time', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final first = _profile('serial-first');
    final second = _profile('serial-second');
    await database.into(database.cliProfiles).insert(first);
    await database.into(database.cliProfiles).insert(second);
    var now = DateTime.utc(2026, 8, 21, 12);
    var calls = 0;
    var active = 0;
    var maxActive = 0;
    final gates = [
      Completer<CodexRefreshResult>(),
      Completer<CodexRefreshResult>(),
    ];
    final timers = _RecordingTimerFactory();
    final service = CodexWeeklyKeepAliveService(
      database: database,
      runner: runner,
      now: () => now,
      timerFactory: timers.call,
      probe: (_) async {
        final gate = gates[calls++];
        active++;
        if (active > maxActive) maxActive = active;
        final result = await gate.future;
        active--;
        return result;
      },
    );

    await service.recordProbeFailure(first, StateError('offline'));
    await service.recordProbeFailure(second, StateError('offline'));
    now = now.add(const Duration(minutes: 15));
    timers.fireAllActive();
    await _waitFor(() => calls == 1);
    expect(maxActive, 1);

    gates.first.complete(_resultWithoutWindows(now));
    await _waitFor(() => calls == 2);
    expect(maxActive, 1);
    gates.last.complete(_resultWithoutWindows(now));
    await service.waitUntilIdle();

    expect(maxActive, 1);
    expect(timers.activeTimers, isEmpty);
  });

  test('monitoring probes each active profile once per app session', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final first = _profile('startup-first');
    final second = _profile('startup-second');
    await database.into(database.cliProfiles).insert(first);
    await database.into(database.cliProfiles).insert(second);
    final probes = <String>[];
    final service = CodexWeeklyKeepAliveService(
      database: database,
      runner: runner,
      probe: (profile) async {
        probes.add(profile.id);
        return _resultWithoutWindows(DateTime.now().toUtc());
      },
    );

    service.monitorProfiles([first, second]);
    await service.waitUntilIdle();
    expect(probes, [first.id, second.id]);

    service.monitorProfiles([first, second]);
    await service.waitUntilIdle();
    expect(probes, hasLength(2));

    service.monitorProfiles([first]);
    service.monitorProfiles([first, second]);
    await service.waitUntilIdle();
    expect(probes, [first.id, second.id, second.id]);
  });

  test('disabling clears queued manual heartbeats', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final first = _profile('first');
    final queued = _profile('queued');
    await database.into(database.cliProfiles).insert(first);
    await database.into(database.cliProfiles).insert(queued);
    final firstCommand = Completer<SafeProcessResult>();
    var starts = 0;
    final now = DateTime.utc(2026, 8, 21, 12);
    final resetAt = now.add(const Duration(days: 7));
    final service = CodexWeeklyKeepAliveService(
      database: database,
      runner: runner,
      now: () => now,
      verificationDelay: Duration.zero,
      probe: _ProbeSequence([
        _resultWithWindow(now, used: 0, duration: 10080, resetAt: resetAt),
        _resultWithWindow(now, used: 0, duration: 10080, resetAt: resetAt),
      ]).call,
      command: (profile, prompt) {
        starts++;
        return firstCommand.future;
      },
    );

    final firstResult = service.runNow(first);
    await _waitFor(() => starts == 1);
    final queuedResult = service.runNow(queued);
    service.enabled = false;
    expect((await queuedResult).outcome, KeepAliveOutcome.skipped);
    firstCommand.complete(_success());
    expect((await firstResult).commandSucceeded, isTrue);
    await service.waitUntilIdle();
    expect(starts, 1);
  });
}

class _ProbeSequence {
  _ProbeSequence(this.results);

  final List<CodexRefreshResult> results;
  final List<String> profileIds = <String>[];
  int calls = 0;

  Future<CodexRefreshResult> call(CliProfile profile) async {
    profileIds.add(profile.id);
    final index = calls++;
    return results[index.clamp(0, results.length - 1)];
  }
}

class _RecordingProcessRunner extends ProcessRunner {
  _RecordingProcessRunner(super.database);

  String? executable;
  List<String>? arguments;
  String? workingDirectory;
  Map<String, String>? environment;
  Duration? timeout;

  @override
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
    this.executable = executable;
    this.arguments = arguments;
    this.workingDirectory = workingDirectory;
    this.environment = environment;
    this.timeout = timeout;
    return _success();
  }
}

CliProfile _profile(String id) {
  final now = DateTime.utc(2026, 8, 20);
  return CliProfile(
    id: id,
    toolKey: 'codex',
    profileName: id,
    commandName: 'codex-$id',
    displayName: id,
    profileHome: '/tmp/$id',
    profileSource: 'multicli',
    profileType: 'full',
    hasAuthFile: true,
    isAvailable: true,
    isFavorite: false,
    createdAt: now,
    lastDiscoveredAt: now,
  );
}

CodexRefreshResult _resultWithWindow(
  DateTime now, {
  required double used,
  required int duration,
  DateTime? resetAt,
  String planType = 'plus',
}) => CodexRefreshResult(
  state: UsageCheckState.success,
  startedAt: now.toUtc(),
  completedAt: now.toUtc(),
  accountEmail: 'account@example.com',
  planType: planType,
  rateLimitsReadSucceeded: true,
  windows: [
    QuotaSnapshot(
      limitId: 'codex',
      windowType: 'primary',
      usedPercent: used,
      windowDurationMinutes: duration,
      resetsAt: resetAt,
    ),
  ],
);

CodexRefreshResult _resultWithoutWindows(DateTime now) => CodexRefreshResult(
  state: UsageCheckState.success,
  startedAt: now.toUtc(),
  completedAt: now.toUtc(),
  accountEmail: 'account@example.com',
  planType: 'plus',
  rateLimitsReadSucceeded: true,
);

SafeProcessResult _success() {
  final now = DateTime.now().toUtc();
  return SafeProcessResult(
    exitCode: 0,
    stdout: 'OK',
    stderr: '',
    startedAt: now,
    completedAt: now,
  );
}

Future<Map<String, dynamic>> _state(
  AppDatabase database,
  String profileId,
) async {
  final raw = await database.setting(
    'codex_weekly_keep_alive_state_$profileId',
  );
  return jsonDecode(raw!) as Map<String, dynamic>;
}

Future<void> _waitFor(bool Function() condition) async {
  for (var attempt = 0; attempt < 100 && !condition(); attempt++) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  expect(condition(), isTrue);
}

Future<void> _waitForAsync(Future<bool> Function() condition) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    if (await condition()) return;
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  expect(await condition(), isTrue);
}

class _RecordingTimerFactory {
  final List<_RecordingTimer> timers = <_RecordingTimer>[];

  List<_RecordingTimer> get activeTimers =>
      timers.where((timer) => timer.isActive).toList();

  Timer call(Duration duration, void Function() callback) {
    final timer = _RecordingTimer(duration, callback);
    timers.add(timer);
    return timer;
  }

  void fireActive() => activeTimers.single.fire();

  void fireAllActive() {
    for (final timer in activeTimers) {
      timer.fire();
    }
  }
}

class _RecordingTimer implements Timer {
  _RecordingTimer(this.duration, this.callback);

  final Duration duration;
  final void Function() callback;
  bool _active = true;
  int _tick = 0;

  void fire() {
    if (!_active) return;
    _active = false;
    _tick = 1;
    callback();
  }

  @override
  void cancel() => _active = false;

  @override
  bool get isActive => _active;

  @override
  int get tick => _tick;
}
