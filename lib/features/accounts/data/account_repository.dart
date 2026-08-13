import 'package:drift/drift.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/features/accounts/domain/account_models.dart';
import 'package:multi_cli_ai/features/profiles/domain/profile_provider.dart';

class AccountRepository {
  AccountRepository(this.database);

  final AppDatabase database;

  Future<List<AccountCardData>> loadAccounts() async {
    final profiles =
        (await (database.select(database.cliProfiles)..orderBy([
                  (row) => OrderingTerm.desc(row.isFavorite),
                  (row) => OrderingTerm.asc(row.toolKey),
                  (row) => OrderingTerm.asc(row.displayName),
                ]))
                .get())
            .where((profile) {
              final provider = profileProviderOrNull(profile.toolKey);
              return provider?.showsProfileSource(profile.profileSource) ??
                  false;
            })
            .toList();
    final output = <AccountCardData>[];
    for (final profile in profiles) {
      final metadata = await (database.select(
        database.profileMetadatas,
      )..where((row) => row.profileId.equals(profile.id))).getSingleOrNull();
      final shares =
          await (database.select(database.costShares)
                ..where((row) => row.profileId.equals(profile.id))
                ..orderBy([(row) => OrderingTerm.asc(row.personName)]))
              .get();
      final checks =
          await (database.select(database.usageChecks)
                ..where((row) => row.profileId.equals(profile.id))
                ..orderBy([(row) => OrderingTerm.desc(row.startedAt)]))
              .get();
      final current = checks.firstOrNull;
      UsageCheck? successful;
      for (final check in checks) {
        if (check.status == 'success' || check.status == 'partial') {
          successful = check;
          break;
        }
      }
      Future<List<QuotaWindow>> windowsFor(UsageCheck? check) async {
        if (check == null) return const [];
        final rows =
            await (database.select(database.quotaWindows)
                  ..where((row) => row.checkId.equals(check.id))
                  ..orderBy([
                    (row) => OrderingTerm.asc(row.windowDurationMinutes),
                    (row) => OrderingTerm.asc(row.limitId),
                  ]))
                .get();
        final unique = <String, QuotaWindow>{};
        for (final row in rows) {
          unique.putIfAbsent(
            '${row.limitId.toLowerCase()}\u0000${row.windowType}',
            () => row,
          );
        }
        return unique.values.toList();
      }

      final currentWindows = await windowsFor(current);
      final successfulWindows = current?.id == successful?.id
          ? currentWindows
          : await windowsFor(successful);
      final credits = successful == null
          ? null
          : await (database.select(database.resetCreditSnapshots)
                  ..where((row) => row.checkId.equals(successful!.id)))
                .getSingleOrNull();
      output.add(
        AccountCardData(
          profile: profile,
          metadata: metadata,
          costShares: shares,
          currentCheck: current,
          currentWindows: currentWindows,
          lastSuccessfulCheck: successful,
          lastSuccessfulWindows: successfulWindows,
          resetCredits: credits,
        ),
      );
    }
    return output;
  }

  Future<List<CommandLog>> loadLogs({int limit = 250}) =>
      (database.select(database.commandLogs)
            ..orderBy([(row) => OrderingTerm.desc(row.startedAt)])
            ..limit(limit))
          .get();

  Future<Map<DateTime, CalendarDayData>> loadCalendar() async {
    final profiles = await database.select(database.cliProfiles).get();
    final buckets = await database.select(database.dailyUsageBuckets).get();
    final checks = await database.select(database.usageChecks).get();
    final windows = await database.select(database.quotaWindows).get();
    final metadata = await database.select(database.profileMetadatas).get();
    final profilesById = {for (final profile in profiles) profile.id: profile};
    final metadataById = {for (final item in metadata) item.profileId: item};
    final checksById = {for (final check in checks) check.id: check};
    final emailsByProfile = <String, String>{};
    for (final check in checks) {
      final email = check.accountEmail?.trim() ?? '';
      if (email.isNotEmpty) {
        emailsByProfile.putIfAbsent(check.profileId, () => email);
      }
    }

    final bestTokens = <(String, DateTime), int>{};
    for (final bucket in buckets) {
      final day = _providerUsageDay(bucket.day);
      final key = (bucket.profileId, day);
      final current = bestTokens[key] ?? 0;
      if (bucket.tokens > current) bestTokens[key] = bucket.tokens;
    }

    final values = <DateTime, _MutableCalendarDay>{};
    _MutableCalendarDay day(DateTime value) =>
        values.putIfAbsent(_day(value), _MutableCalendarDay.new);
    for (final entry in bestTokens.entries) {
      day(entry.key.$2).tokens += entry.value;
      day(entry.key.$2).account(entry.key.$1).tokens += entry.value;
    }
    for (final check in checks) {
      final target = day(check.startedAt.toLocal());
      final account = target.account(check.profileId);
      if (check.status == 'success' || check.status == 'partial') {
        target.successfulChecks++;
        account.successfulChecks++;
      } else {
        target.failedChecks++;
        account.failedChecks++;
      }
    }
    final resetEvents = <(String, String, String, int)>{};
    for (final window in windows) {
      final check = checksById[window.checkId];
      if (window.usedPercent != null) {
        final remaining = (100 - window.usedPercent!).clamp(0, 100).toDouble();
        final checkedAt = check?.startedAt;
        if (checkedAt != null) {
          final target = day(checkedAt.toLocal());
          target.lowestRemaining = target.lowestRemaining == null
              ? remaining
              : (remaining < target.lowestRemaining!
                    ? remaining
                    : target.lowestRemaining);
          final account = target.account(check!.profileId);
          account.lowestRemaining = account.lowestRemaining == null
              ? remaining
              : (remaining < account.lowestRemaining!
                    ? remaining
                    : account.lowestRemaining);
        }
      }
      if (window.resetsAt != null && check != null) {
        resetEvents.add((
          check.profileId,
          window.limitId,
          window.windowType,
          window.resetsAt!.millisecondsSinceEpoch,
        ));
      }
    }
    for (final event in resetEvents) {
      final target = day(
        DateTime.fromMillisecondsSinceEpoch(event.$4).toLocal(),
      );
      target.resetCount++;
      target.account(event.$1).resetCount++;
    }
    for (final item in metadata) {
      if (item.nextRenewalOn != null) {
        final target = day(item.nextRenewalOn!.toLocal());
        target.renewalCount++;
        target.account(item.profileId).renewalCount++;
      }
    }
    return values.map(
      (date, value) => MapEntry(
        date,
        CalendarDayData(
          day: date,
          tokens: value.tokens,
          successfulChecks: value.successfulChecks,
          failedChecks: value.failedChecks,
          lowestRemaining: value.lowestRemaining,
          resetCount: value.resetCount,
          renewalCount: value.renewalCount,
          accounts:
              value.accounts.entries
                  .map((entry) {
                    final profile = profilesById[entry.key];
                    final profileMetadata = metadataById[entry.key];
                    final email =
                        profileMetadata?.accountEmail.trim().isNotEmpty == true
                        ? profileMetadata!.accountEmail.trim()
                        : (emailsByProfile[entry.key] ?? '');
                    return AccountDayUsage(
                      profileId: entry.key,
                      displayName: profile?.displayName ?? entry.key,
                      email: email,
                      tokens: entry.value.tokens,
                      successfulChecks: entry.value.successfulChecks,
                      failedChecks: entry.value.failedChecks,
                      lowestRemaining: entry.value.lowestRemaining,
                      resetCount: entry.value.resetCount,
                      renewalCount: entry.value.renewalCount,
                    );
                  })
                  .where((item) => item.hasActivity)
                  .toList()
                ..sort((a, b) {
                  final byTokens = b.tokens.compareTo(a.tokens);
                  return byTokens != 0
                      ? byTokens
                      : a.displayName.toLowerCase().compareTo(
                          b.displayName.toLowerCase(),
                        );
                }),
        ),
      ),
    );
  }

  Future<void> saveProfileMetadata({
    required CliProfile profile,
    required String email,
    required String accountDisplayName,
    required String planName,
    required String notes,
    required DateTime? purchasedOn,
    required DateTime? nextRenewalOn,
    required String billingInterval,
    required int expectedAmountMinor,
    required String currencyCode,
    required bool autoRenew,
    required String subscriptionStatus,
    required String purchasedFrom,
    required String paymentMethodLabel,
    required List<CostShareDraft> shares,
  }) async {
    await database.transaction(() async {
      await database
          .into(database.profileMetadatas)
          .insertOnConflictUpdate(
            ProfileMetadatasCompanion.insert(
              profileId: profile.id,
              accountEmail: Value(email.trim()),
              accountDisplayName: Value(accountDisplayName.trim()),
              planName: Value(planName.trim()),
              notes: Value(notes.trim()),
              purchasedOn: Value(purchasedOn),
              nextRenewalOn: Value(nextRenewalOn),
              billingInterval: Value(billingInterval),
              expectedAmountMinor: Value(expectedAmountMinor),
              currencyCode: Value(currencyCode.trim().toUpperCase()),
              autoRenew: Value(autoRenew),
              subscriptionStatus: Value(subscriptionStatus),
              purchasedFrom: Value(purchasedFrom.trim()),
              paymentMethodLabel: Value(paymentMethodLabel.trim()),
              updatedAt: DateTime.now().toUtc(),
            ),
          );
      await (database.delete(
        database.costShares,
      )..where((row) => row.profileId.equals(profile.id))).go();
      for (final share in shares.where(
        (item) => item.personName.trim().isNotEmpty,
      )) {
        await database
            .into(database.costShares)
            .insert(
              CostSharesCompanion.insert(
                id: share.id,
                profileId: profile.id,
                personName: share.personName.trim(),
                expectedAmountMinor: Value(share.expectedAmountMinor),
                paidAmountMinor: Value(share.paidAmountMinor),
                currencyCode: Value(share.currencyCode.trim().toUpperCase()),
                paymentStatus: Value(share.paymentStatus),
                paidOn: Value(share.paidOn),
                notes: Value(share.notes.trim()),
              ),
            );
      }
    });
  }

  static DateTime _day(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime _providerUsageDay(DateTime value) {
    // Provider usage days are date-only values persisted as UTC midnight.
    // Recover their UTC calendar fields so local offsets never shift the day.
    final utc = value.toUtc();
    return DateTime(utc.year, utc.month, utc.day);
  }
}

class CostShareDraft {
  const CostShareDraft({
    required this.id,
    required this.personName,
    required this.expectedAmountMinor,
    required this.paidAmountMinor,
    required this.currencyCode,
    required this.paymentStatus,
    required this.notes,
    this.paidOn,
  });

  final String id;
  final String personName;
  final int expectedAmountMinor;
  final int paidAmountMinor;
  final String currencyCode;
  final String paymentStatus;
  final DateTime? paidOn;
  final String notes;
}

class _MutableCalendarDay {
  int tokens = 0;
  int successfulChecks = 0;
  int failedChecks = 0;
  double? lowestRemaining;
  int resetCount = 0;
  int renewalCount = 0;
  final Map<String, _MutableAccountDay> accounts = {};

  _MutableAccountDay account(String profileId) =>
      accounts.putIfAbsent(profileId, _MutableAccountDay.new);
}

class _MutableAccountDay {
  int tokens = 0;
  int successfulChecks = 0;
  int failedChecks = 0;
  double? lowestRemaining;
  int resetCount = 0;
  int renewalCount = 0;
}
