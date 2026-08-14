import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/process/process_runner.dart';
import 'package:multi_cli_ai/features/accounts/data/account_repository.dart';
import 'package:multi_cli_ai/features/accounts/domain/account_models.dart';
import 'package:multi_cli_ai/features/profiles/data/multi_cli_gateway.dart';
import 'package:multi_cli_ai/features/profiles/data/profile_discovery_service.dart';
import 'package:multi_cli_ai/features/profiles/domain/profile_provider.dart';
import 'package:multi_cli_ai/features/usage/data/usage_refresh_service.dart';
import 'package:multi_cli_ai/features/workspaces/data/workspace_repository.dart';
import 'package:multi_cli_ai/providers/codex/codex_app_server_client.dart';

enum AppSection { accounts, calendar, activity }

enum StartupFailureKind { updateRequired, unexpected }

class StartupFailure {
  const StartupFailure({
    required this.kind,
    required this.title,
    required this.message,
  });

  factory StartupFailure.from(Object error) {
    final details = ProcessRunner.sanitizeOutput(error.toString());
    final normalized = details.toLowerCase();
    final needsDatabaseMigration =
        normalized.contains('bumped the schema version') &&
        (normalized.contains('migration') ||
            normalized.contains('schema updates'));

    if (needsDatabaseMigration) {
      return const StartupFailure(
        kind: StartupFailureKind.updateRequired,
        title: 'Ejecutable desactualizado',
        message:
            'Este ejecutable no incluye la actualización necesaria para abrir '
            'tu base de datos local. Instala la versión más reciente de '
            'MultiCLI AI y vuelve a abrir la aplicación. Tus datos se '
            'conservarán.',
      );
    }

    return StartupFailure(
      kind: StartupFailureKind.unexpected,
      title: 'No se pudo iniciar',
      message: details,
    );
  }

  final StartupFailureKind kind;
  final String title;
  final String message;
}

class DashboardController extends ChangeNotifier {
  DashboardController({
    required this.database,
    required this.discovery,
    required this.multiCli,
    required this.accountsRepository,
    required this.workspaceRepository,
    required this.usage,
    required this.runner,
  });

  final AppDatabase database;
  final ProfileDiscoveryService discovery;
  final MultiCliGateway multiCli;
  final AccountRepository accountsRepository;
  final WorkspaceRepository workspaceRepository;
  final UsageRefreshService usage;
  final ProcessRunner runner;

  bool initialized = false;
  bool loading = false;
  StartupFailure? fatalError;
  List<AccountCardData> accounts = const [];
  List<CommandLog> logs = const [];
  List<Workspace> workspaces = const [];
  Map<DateTime, CalendarDayData> calendar = const {};
  Set<String> refreshing = <String>{};
  AppSection section = AppSection.accounts;
  String query = '';
  String statusFilter = 'all';
  String? selectedProfileId;
  String? currentWorkspaceId;
  DateTime selectedDay = DateTime.now();
  int concurrency = 3;
  int timeoutSeconds = 15;
  String themePreference = 'dark';
  String accentPreference = 'cyan';
  double fontScale = .9;
  String fontFamilyPreference = 'system';
  bool compactCards = false;

  List<AccountCardData> get visibleAccounts {
    final search = query.trim().toLowerCase();
    return accounts.where((account) {
      final matchesSearch =
          search.isEmpty ||
          account.profile.displayName.toLowerCase().contains(search) ||
          account.profile.profileName.toLowerCase().contains(search) ||
          account.displayEmail.toLowerCase().contains(search);
      final state = account.currentState;
      final provider = profileProvider(account.profile.toolKey);
      final ready = provider.supportsUsage
          ? state == UsageCheckState.success || state == UsageCheckState.partial
          : account.profile.isAvailable && account.profile.hasAuthFile;
      final matchesState = switch (statusFilter) {
        'ready' => ready,
        'attention' =>
          provider.supportsUsage
              ? state != null && !ready
              : !account.profile.isAvailable,
        'unlinked' => !account.profile.hasAuthFile,
        _ => true,
      };
      return matchesSearch && matchesState;
    }).toList();
  }

  AccountCardData? get selectedAccount {
    for (final account in accounts) {
      if (account.profile.id == selectedProfileId) return account;
    }
    return accounts.firstOrNull;
  }

  Workspace? get currentWorkspace {
    for (final workspace in workspaces) {
      if (workspace.id == currentWorkspaceId) return workspace;
    }
    return workspaces.firstOrNull;
  }

  Future<void> initialize() async {
    if (loading) return;
    loading = true;
    notifyListeners();
    try {
      await _loadSettings();
      usage.client = CodexAppServerClient(
        timeout: Duration(seconds: timeoutSeconds),
      );
      await discovery.discoverProfiles();
      await reload();
      initialized = true;
      fatalError = null;
    } catch (error) {
      fatalError = StartupFailure.from(error);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> reload() async {
    accounts = await accountsRepository.loadAccounts();
    logs = await accountsRepository.loadLogs();
    workspaces = await workspaceRepository.loadWorkspaces();
    calendar = await accountsRepository.loadCalendar();
    selectedProfileId ??= accounts.firstOrNull?.profile.id;
    if (currentWorkspaceId == null ||
        !workspaces.any((workspace) => workspace.id == currentWorkspaceId)) {
      currentWorkspaceId = workspaces.firstOrNull?.id;
    }
    notifyListeners();
  }

  Future<void> rescanProfiles() async {
    await discovery.discoverProfiles();
    await reload();
  }

  Future<void> refreshOne(AccountCardData account) async {
    if (!profileProvider(account.profile.toolKey).supportsUsage) {
      throw StateError(
        '${profileProvider(account.profile.toolKey).productName} todavía no expone cuotas en esta aplicación.',
      );
    }
    if (refreshing.contains(account.profile.id)) return;
    refreshing = {...refreshing, account.profile.id};
    notifyListeners();
    try {
      await usage.refreshProfile(account.profile);
      await reload();
    } finally {
      refreshing = {...refreshing}..remove(account.profile.id);
      notifyListeners();
    }
  }

  Future<void> refreshAll() async {
    final targets = accounts
        .where(
          (item) =>
              item.profile.isAvailable &&
              profileProvider(item.profile.toolKey).supportsUsage,
        )
        .toList();
    if (targets.isEmpty || refreshing.isNotEmpty) return;
    refreshing = targets.map((item) => item.profile.id).toSet();
    notifyListeners();
    try {
      await usage.refreshAll(
        targets.map((item) => item.profile).toList(),
        concurrency: concurrency,
        onProgress: (profileId, _) {
          refreshing = {...refreshing}..remove(profileId);
          notifyListeners();
        },
      );
      await reload();
    } finally {
      refreshing = <String>{};
      notifyListeners();
    }
  }

  Future<void> createProfile(ProfileCreateRequest request) async {
    await multiCli.create(request);
    await rescanProfiles();
  }

  Future<void> renameProfile(AccountCardData account, String name) async {
    await multiCli.rename(account.profile, name);
    await rescanProfiles();
  }

  Future<void> deleteProfile(AccountCardData account) async {
    await multiCli.delete(account.profile);
    if (selectedProfileId == account.profile.id) selectedProfileId = null;
    await rescanProfiles();
  }

  String get userHomeDirectory => multiCli.userHomeDirectory;

  Future<void> launchProfile(
    AccountCardData account, {
    required String workingDirectory,
    bool rememberWorkspace = true,
  }) async {
    await multiCli.launch(account.profile, workingDirectory: workingDirectory);
    if (rememberWorkspace) {
      final workspace = await workspaceRepository.recordOpened(
        workingDirectory,
      );
      currentWorkspaceId = workspace.id;
      await database.saveSetting('current_workspace_id', workspace.id);
    }
    await reload();
  }

  Future<Workspace> addWorkspace(String path) async {
    final workspace = await workspaceRepository.add(path);
    currentWorkspaceId = workspace.id;
    await database.saveSetting('current_workspace_id', workspace.id);
    workspaces = await workspaceRepository.loadWorkspaces();
    notifyListeners();
    return workspace;
  }

  Future<void> selectWorkspace(Workspace workspace) async {
    await workspaceRepository.select(workspace.id);
    currentWorkspaceId = workspace.id;
    await database.saveSetting('current_workspace_id', workspace.id);
    workspaces = await workspaceRepository.loadWorkspaces();
    notifyListeners();
  }

  Future<void> renameWorkspace(Workspace workspace, String name) async {
    await workspaceRepository.rename(workspace.id, name);
    workspaces = await workspaceRepository.loadWorkspaces();
    notifyListeners();
  }

  Future<void> forgetWorkspace(Workspace workspace) async {
    await workspaceRepository.remove(workspace.id);
    workspaces = await workspaceRepository.loadWorkspaces();
    if (currentWorkspaceId == workspace.id) {
      currentWorkspaceId = workspaces.firstOrNull?.id;
      await database.saveSetting(
        'current_workspace_id',
        currentWorkspaceId ?? '',
      );
    }
    notifyListeners();
  }

  Future<void> saveProfile({
    required AccountCardData account,
    required String displayName,
    required bool favorite,
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
    await multiCli.saveDisplayData(
      profile: account.profile,
      displayName: displayName,
      favorite: favorite,
    );
    await accountsRepository.saveProfileMetadata(
      profile: account.profile,
      email: email,
      accountDisplayName: accountDisplayName,
      planName: planName,
      notes: notes,
      purchasedOn: purchasedOn,
      nextRenewalOn: nextRenewalOn,
      billingInterval: billingInterval,
      expectedAmountMinor: expectedAmountMinor,
      currencyCode: currencyCode,
      autoRenew: autoRenew,
      subscriptionStatus: subscriptionStatus,
      purchasedFrom: purchasedFrom,
      paymentMethodLabel: paymentMethodLabel,
      shares: shares,
    );
    await reload();
  }

  Future<CodexDeviceAuthSession> startDeviceAuth(
    AccountCardData account,
  ) async {
    await runner.addInternalLog(
      summary: 'Vincular ${account.profile.displayName}',
      status: 'success',
      output: 'Codex inició el flujo oficial de código de dispositivo.',
      profileId: account.profile.id,
      command: 'codex app-server account/login/start',
    );
    return usage.client.startDeviceAuth(account.profile.profileHome);
  }

  Future<void> completeDeviceAuth(AccountCardData account, bool success) async {
    await runner.addInternalLog(
      summary: 'Vincular ${account.profile.displayName}',
      status: success ? 'success' : 'error',
      output: success
          ? 'Codex confirmó la cuenta y guardó la credencial en el perfil.'
          : 'El acceso no fue confirmado.',
      profileId: account.profile.id,
      command: 'codex app-server account/login/completed',
    );
    await rescanProfiles();
    if (success) {
      final linked = accounts
          .where((item) => item.profile.id == account.profile.id)
          .firstOrNull;
      if (linked != null) await refreshOne(linked);
    }
  }

  void setSection(AppSection value) {
    section = value;
    notifyListeners();
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setStatusFilter(String value) {
    statusFilter = value;
    notifyListeners();
  }

  void selectAccount(String id) {
    selectedProfileId = id;
    notifyListeners();
  }

  void selectDay(DateTime day) {
    selectedDay = DateTime(day.year, day.month, day.day);
    notifyListeners();
  }

  Future<void> saveSettings({
    required String theme,
    required String accent,
    required double fontScale,
    required String fontFamily,
    required int concurrency,
    required int timeoutSeconds,
    required bool compactCards,
    required String profilesRoot,
  }) async {
    themePreference = theme;
    accentPreference = accent;
    this.fontScale = fontScale.clamp(.8, 1.2).toDouble();
    fontFamilyPreference = fontFamily;
    this.concurrency = concurrency.clamp(1, 6);
    this.timeoutSeconds = timeoutSeconds.clamp(5, 60);
    this.compactCards = compactCards;
    await Future.wait([
      database.saveSetting('theme', theme),
      database.saveSetting('accent', accent),
      database.saveSetting('font_scale', this.fontScale.toString()),
      database.saveSetting('font_family', fontFamily),
      database.saveSetting('concurrency', this.concurrency.toString()),
      database.saveSetting('timeout_seconds', this.timeoutSeconds.toString()),
      database.saveSetting('compact_cards', compactCards.toString()),
      database.saveSetting('profiles_root_path', profilesRoot.trim()),
    ]);
    usage.client = CodexAppServerClient(
      timeout: Duration(seconds: this.timeoutSeconds),
    );
    await rescanProfiles();
    notifyListeners();
  }

  Future<void> clearLogs() async {
    await database.delete(database.commandLogs).go();
    await reload();
  }

  Future<void> _loadSettings() async {
    themePreference = await database.setting('theme') ?? 'dark';
    accentPreference = await database.setting('accent') ?? 'cyan';
    fontScale =
        double.tryParse(await database.setting('font_scale') ?? '') ?? .9;
    fontScale = fontScale.clamp(.8, 1.2).toDouble();
    fontFamilyPreference = await database.setting('font_family') ?? 'system';
    concurrency =
        int.tryParse(await database.setting('concurrency') ?? '') ?? 3;
    timeoutSeconds =
        int.tryParse(await database.setting('timeout_seconds') ?? '') ?? 15;
    compactCards = (await database.setting('compact_cards')) == 'true';
    final storedWorkspace = await database.setting('current_workspace_id');
    currentWorkspaceId = storedWorkspace?.trim().isEmpty == false
        ? storedWorkspace
        : null;
  }
}
