import 'dart:collection';

import 'package:drift/drift.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/process/process_runner.dart';
import 'package:multi_cli_ai/features/accounts/domain/account_models.dart';
import 'package:multi_cli_ai/providers/codex/codex_app_server_client.dart';
import 'package:uuid/uuid.dart';

typedef RefreshProgress =
    void Function(String profileId, CodexRefreshResult result);

class UsageRefreshService {
  UsageRefreshService({
    required this.database,
    required this.client,
    required this.runner,
  });

  final AppDatabase database;
  CodexAppServerClient client;
  final ProcessRunner runner;
  final Uuid _uuid = const Uuid();

  Future<CodexRefreshResult> refreshProfile(CliProfile profile) async {
    final result = await client.refresh(profile.profileHome);
    await _persist(profile, result);
    final status =
        result.state == UsageCheckState.success ||
            result.state == UsageCheckState.partial
        ? 'success'
        : 'error';
    final detail =
        result.errorMessage ??
        '${result.windows.length} ventanas y ${result.dailyUsage.length} días de uso.';
    await runner.addInternalLog(
      summary: 'Actualizar ${profile.displayName}',
      status: status,
      output: detail,
      profileId: profile.id,
      command: 'codex app-server metadata',
    );
    return result;
  }

  Future<Map<String, CodexRefreshResult>> refreshAll(
    List<CliProfile> profiles, {
    int concurrency = 3,
    RefreshProgress? onProgress,
  }) async {
    if (profiles.isEmpty) return const {};
    final queue = Queue<CliProfile>.from(profiles);
    final results = <String, CodexRefreshResult>{};
    final workerCount = concurrency.clamp(1, 6).clamp(1, queue.length);

    Future<void> worker() async {
      while (queue.isNotEmpty) {
        final profile = queue.removeFirst();
        final result = await refreshProfile(profile);
        results[profile.id] = result;
        onProgress?.call(profile.id, result);
      }
    }

    await Future.wait(List.generate(workerCount, (_) => worker()));
    return results;
  }

  Future<void> _persist(CliProfile profile, CodexRefreshResult result) async {
    final checkId = _uuid.v4();
    await database.transaction(() async {
      await database
          .into(database.usageChecks)
          .insert(
            UsageChecksCompanion.insert(
              id: checkId,
              profileId: profile.id,
              status: result.state.storageValue,
              startedAt: result.startedAt,
              completedAt: Value(result.completedAt),
              durationMs: Value(result.durationMs),
              planType: Value(result.planType),
              accountEmail: Value(result.accountEmail),
              accountDisplayName: Value(result.accountDisplayName),
              errorCode: Value(result.errorCode),
              errorMessage: Value(result.errorMessage),
            ),
          );
      for (final window in result.windows) {
        await database
            .into(database.quotaWindows)
            .insert(
              QuotaWindowsCompanion.insert(
                id: _uuid.v4(),
                checkId: checkId,
                limitId: window.limitId,
                limitName: Value(window.limitName),
                windowType: window.windowType,
                usedPercent: Value(window.usedPercent),
                windowDurationMinutes: Value(window.windowDurationMinutes),
                resetsAt: Value(window.resetsAt),
                reachedType: Value(window.reachedType),
                planType: Value(window.planType),
              ),
            );
      }
      await database
          .into(database.resetCreditSnapshots)
          .insert(
            ResetCreditSnapshotsCompanion.insert(
              checkId: checkId,
              availableCount: Value(result.resetCredits),
              nextExpiresAt: Value(result.nextCreditExpiry),
            ),
          );
      for (final bucket in result.dailyUsage) {
        await database
            .into(database.dailyUsageBuckets)
            .insert(
              DailyUsageBucketsCompanion.insert(
                id: _uuid.v4(),
                checkId: checkId,
                profileId: profile.id,
                day: bucket.day,
                tokens: Value(bucket.tokens),
                activeMinutes: Value(bucket.activeMinutes),
                messageCount: Value(bucket.messageCount),
                source: bucket.source,
              ),
            );
      }

      final observedEmail = result.accountEmail?.trim() ?? '';
      final existing = await (database.select(
        database.profileMetadatas,
      )..where((row) => row.profileId.equals(profile.id))).getSingleOrNull();
      if (existing == null && observedEmail.isNotEmpty) {
        await database
            .into(database.profileMetadatas)
            .insert(
              ProfileMetadatasCompanion.insert(
                profileId: profile.id,
                accountEmail: Value(observedEmail),
                accountDisplayName: Value(result.accountDisplayName ?? ''),
                updatedAt: DateTime.now().toUtc(),
              ),
            );
      }
    });
  }
}
