import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class CliProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get toolKey => text().withDefault(const Constant('codex'))();
  TextColumn get profileName => text()();
  TextColumn get commandName => text().nullable()();
  TextColumn get displayName => text()();
  TextColumn get profileHome => text().unique()();
  TextColumn get profileSource => text()();
  TextColumn get profileType => text()();
  BoolColumn get hasAuthFile => boolean().withDefault(const Constant(false))();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastDiscoveredAt => dateTime()();
  DateTimeColumn get lastLaunchedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProfileMetadatas extends Table {
  TextColumn get profileId =>
      text().references(CliProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get accountEmail => text().withDefault(const Constant(''))();
  TextColumn get accountDisplayName => text().withDefault(const Constant(''))();
  TextColumn get planName => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get purchasedOn => dateTime().nullable()();
  DateTimeColumn get nextRenewalOn => dateTime().nullable()();
  TextColumn get billingInterval =>
      text().withDefault(const Constant('monthly'))();
  IntColumn get expectedAmountMinor =>
      integer().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();
  BoolColumn get autoRenew => boolean().withDefault(const Constant(true))();
  TextColumn get subscriptionStatus =>
      text().withDefault(const Constant('active'))();
  TextColumn get purchasedFrom => text().withDefault(const Constant(''))();
  TextColumn get paymentMethodLabel => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {profileId};
}

class CostShares extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(CliProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get personName => text()();
  IntColumn get expectedAmountMinor =>
      integer().withDefault(const Constant(0))();
  IntColumn get paidAmountMinor => integer().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();
  TextColumn get paymentStatus =>
      text().withDefault(const Constant('pending'))();
  DateTimeColumn get paidOn => dateTime().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class UsageChecks extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(CliProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get queryMethod =>
      text().withDefault(const Constant('codex-app-server'))();
  TextColumn get status => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get planType => text().nullable()();
  TextColumn get accountEmail => text().nullable()();
  TextColumn get accountDisplayName => text().nullable()();
  TextColumn get errorCode => text().nullable()();
  TextColumn get errorMessage => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class QuotaWindows extends Table {
  TextColumn get id => text()();
  TextColumn get checkId =>
      text().references(UsageChecks, #id, onDelete: KeyAction.cascade)();
  TextColumn get limitId => text()();
  TextColumn get limitName => text().nullable()();
  TextColumn get windowType => text()();
  RealColumn get usedPercent => real().nullable()();
  IntColumn get windowDurationMinutes => integer().nullable()();
  DateTimeColumn get resetsAt => dateTime().nullable()();
  TextColumn get reachedType => text().nullable()();
  TextColumn get planType => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ResetCreditSnapshots extends Table {
  TextColumn get checkId =>
      text().references(UsageChecks, #id, onDelete: KeyAction.cascade)();
  IntColumn get availableCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextExpiresAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {checkId};
}

class DailyUsageBuckets extends Table {
  TextColumn get id => text()();
  TextColumn get checkId =>
      text().references(UsageChecks, #id, onDelete: KeyAction.cascade)();
  TextColumn get profileId =>
      text().references(CliProfiles, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get day => dateTime()();
  IntColumn get tokens => integer().withDefault(const Constant(0))();
  IntColumn get activeMinutes => integer().nullable()();
  IntColumn get messageCount => integer().nullable()();
  TextColumn get source => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CommandLogs extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().nullable()();
  TextColumn get command => text()();
  TextColumn get summary => text()();
  TextColumn get output => text().withDefault(const Constant(''))();
  TextColumn get status => text()();
  IntColumn get exitCode => integer().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get settingKey => text()();
  TextColumn get settingValue => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {settingKey};
}

@DriftDatabase(
  tables: [
    CliProfiles,
    ProfileMetadatas,
    CostShares,
    UsageChecks,
    QuotaWindows,
    ResetCreditSnapshots,
    DailyUsageBuckets,
    CommandLogs,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  static QueryExecutor _openConnection() => driftDatabase(
    name: 'multicli_ai',
    native: const DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
      shareAcrossIsolates: true,
    ),
  );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async => migrator.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );

  Future<String?> setting(String key) async =>
      (await (select(
            appSettings,
          )..where((row) => row.settingKey.equals(key))).getSingleOrNull())
          ?.settingValue;

  Future<void> saveSetting(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion.insert(
          settingKey: key,
          settingValue: value,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
}
