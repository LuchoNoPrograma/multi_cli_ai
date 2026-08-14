import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:multi_cli_ai/app/dashboard_controller.dart';
import 'package:multi_cli_ai/app/providers.dart';
import 'package:multi_cli_ai/core/currency_catalog.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/formatters.dart';
import 'package:multi_cli_ai/core/process/process_runner.dart';
import 'package:multi_cli_ai/core/theme/app_theme.dart';
import 'package:multi_cli_ai/core/widgets/app_primitives.dart';
import 'package:multi_cli_ai/features/accounts/data/account_repository.dart';
import 'package:multi_cli_ai/features/accounts/domain/account_models.dart';
import 'package:multi_cli_ai/features/accounts/presentation/account_dialogs.dart';
import 'package:multi_cli_ai/features/accounts/presentation/accounts_view.dart';
import 'package:multi_cli_ai/features/profiles/data/multi_cli_gateway.dart';
import 'package:multi_cli_ai/features/profiles/data/profile_discovery_service.dart';
import 'package:multi_cli_ai/features/profiles/domain/profile_provider.dart';
import 'package:multi_cli_ai/features/usage/data/usage_refresh_service.dart';
import 'package:multi_cli_ai/features/usage/presentation/calendar_view.dart';
import 'package:multi_cli_ai/features/workspaces/data/workspace_repository.dart';
import 'package:multi_cli_ai/providers/codex/codex_app_server_client.dart';

void main() {
  setUpAll(() => initializeDateFormatting('es'));

  test('currency catalog supports common and non-decimal currencies', () {
    expect(currencies.length, greaterThan(100));
    expect(currencyByCode('bob').name, 'Boliviano boliviano');
    expect(currencyMinorFactor('JPY'), 1);
    expect(currencyMinorFactor('KWD'), 1000);
    expect(currencyMinorFactor('USD'), 100);
  });

  test('profile names are validated before invoking multi-cli', () {
    expect(MultiCliGateway.validateName('nexo'), 'nexo');
    expect(MultiCliGateway.validateName('team_02'), 'team_02');
    expect(
      () => MultiCliGateway.validateName('../nexo'),
      throwsFormatException,
    );
    expect(
      () => MultiCliGateway.validateName('nexo; rm'),
      throwsFormatException,
    );
  });

  test('profile providers keep their Multi CLI prefixes isolated', () {
    final chatGpt = profileProvider('codex');
    final claude = profileProvider('claude-cli');

    expect(chatGpt.profileSpec('work'), 'codex/work');
    expect(chatGpt.commandName('work'), 'codex-work');
    expect(chatGpt.credentialFiles, contains('auth.json'));
    expect(chatGpt.supportsUsage, isTrue);
    expect(chatGpt.showsDefaultProfile, isTrue);
    expect(chatGpt.showsProfileSource('default'), isTrue);
    expect(chatGpt.iconAssetPath, contains('chatgpt-official.png'));
    expect(claude.profileSpec('work'), 'claude-cli/work');
    expect(claude.commandName('work'), 'claude-cli-work');
    expect(claude.credentialFiles, contains('.credentials.json'));
    expect(claude.supportsUsage, isFalse);
    expect(claude.showsDefaultProfile, isFalse);
    expect(claude.showsProfileSource('default'), isFalse);
    expect(claude.showsProfileSource('multicli'), isTrue);
    expect(claude.iconAssetPath, contains('claude-official.png'));
  });

  test('discovery indexes ChatGPT and Claude profiles', () async {
    final root = await Directory.systemTemp.createTemp(
      'multicli-ai-providers-',
    );
    addTearDown(() => root.delete(recursive: true));
    final codex = Directory('${root.path}/codex/team');
    final claude = Directory('${root.path}/claude-cli/research');
    await codex.create(recursive: true);
    await claude.create(recursive: true);
    await File('${codex.path}/auth.json').writeAsString('{}');
    await File('${claude.path}/.credentials.json').writeAsString('{}');
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.saveSetting('profiles_root_path', root.path);
    final now = DateTime.now().toUtc();
    await database
        .into(database.cliProfiles)
        .insert(
          CliProfile(
            id: 'legacy-claude-default',
            toolKey: 'claude-cli',
            profileName: 'principal',
            commandName: 'claude',
            displayName: 'Claude Code principal',
            profileHome: '${root.path}/legacy-claude-default',
            profileSource: 'default',
            profileType: 'base',
            hasAuthFile: false,
            isAvailable: true,
            isFavorite: false,
            createdAt: now,
            lastDiscoveredAt: now,
          ),
        );

    final profiles = await ProfileDiscoveryService(database).discoverProfiles();
    final team = profiles.singleWhere(
      (profile) => profile.toolKey == 'codex' && profile.profileName == 'team',
    );
    final research = profiles.singleWhere(
      (profile) =>
          profile.toolKey == 'claude-cli' && profile.profileName == 'research',
    );

    expect(team.commandName, 'codex-team');
    expect(team.hasAuthFile, isTrue);
    expect(research.commandName, 'claude-cli-research');
    expect(research.hasAuthFile, isTrue);
    expect(
      profiles.where(
        (profile) =>
            profile.toolKey == 'claude-cli' &&
            profile.profileSource == 'default',
      ),
      isEmpty,
    );
    final accounts = await AccountRepository(database).loadAccounts();
    expect(
      accounts.where((item) => item.profile.id == 'legacy-claude-default'),
      isEmpty,
    );
  });

  test(
    'Codex launch directories are validated without touching profiles',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'multicli-ai-working-dir-',
      );
      addTearDown(() => directory.delete(recursive: true));

      expect(
        MultiCliGateway.validateWorkingDirectory(directory.path),
        directory.absolute.path,
      );
      expect(
        () => MultiCliGateway.validateWorkingDirectory(
          '${directory.path}-missing',
        ),
        throwsStateError,
      );
    },
  );

  test('workspace history is global, normalized, and ordered by use', () async {
    final root = await Directory.systemTemp.createTemp('multicli-workspaces-');
    addTearDown(() => root.delete(recursive: true));
    final first = Directory('${root.path}/multi_cli_ai');
    final second = Directory('${root.path}/parla');
    await first.create();
    await second.create();
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = WorkspaceRepository(database);

    final initial = await repository.add('${first.path}/.');
    await repository.recordOpened(first.path);
    await repository.recordOpened('${first.path}/.');
    final recent = await repository.add(second.path);

    var workspaces = await repository.loadWorkspaces();
    expect(workspaces, hasLength(2));
    expect(workspaces.first.id, recent.id);
    expect(
      workspaces.singleWhere((item) => item.id == initial.id).openCount,
      2,
    );

    await repository.select(initial.id);
    await repository.rename(initial.id, 'Multi CLI AI');
    workspaces = await repository.loadWorkspaces();
    expect(workspaces.first.id, initial.id);
    expect(workspaces.first.name, 'Multi CLI AI');

    await repository.remove(recent.id);
    expect(await repository.loadWorkspaces(), hasLength(1));
  });

  test('terminal arguments preserve native working directories', () {
    const project = '/home/nini/StudioProjects/bora asai';
    const target = '/home/nini/.local/bin/multi-cli';
    const command = ['launch', 'codex/ari'];
    const title = 'codex-ari | bora asai';

    expect(
      ProcessRunner.buildTerminalArguments(
        terminal: 'gnome-terminal',
        target: target,
        arguments: command,
        workingDirectory: project,
        title: title,
      ),
      [
        '--title=$title',
        '--working-directory=$project',
        '--',
        target,
        ...command,
      ],
    );
    expect(
      ProcessRunner.buildTerminalArguments(
        terminal: 'wt',
        target: target,
        arguments: command,
        workingDirectory: project,
        title: title,
      ),
      ['--title', title, '-d', project, target, ...command],
    );
  });

  test('interactive terminals restore color and use a compact title', () {
    final environment = ProcessRunner.buildTerminalEnvironment({
      'PATH': '/usr/bin',
      'TERM': 'xterm-256color',
      'COLORTERM': 'truecolor',
      'NO_COLOR': '1',
    });

    expect(environment, isNot(contains('NO_COLOR')));
    expect(environment['TERM'], 'xterm-256color');
    expect(environment['COLORTERM'], 'truecolor');
    expect(
      MultiCliGateway.buildTerminalTitle(
        profileName: 'magic',
        workingDirectory: '/home/nini/StudioProjects/multi_cli_ai',
      ),
      'magic · multi_cli_ai',
    );
  });

  test('sensitive process output is redacted', () {
    final output = ProcessRunner.sanitizeOutput(
      'access_token=secret-value authorization: Bearer abcdef api_key: 123456',
    );
    expect(output, isNot(contains('secret-value')));
    expect(output, isNot(contains('abcdef')));
    expect(output, isNot(contains('123456')));
    expect(output, contains('[REDACTADO]'));
  });

  test('schema migration failures ask for the latest executable', () {
    final failure = StartupFailure.from(
      Exception(
        "You've bumped the schema version for your drift database but didn't "
        'provide a strategy for schema updates. Please adapt the migrations '
        'getter in your database class.',
      ),
    );

    expect(failure.kind, StartupFailureKind.updateRequired);
    expect(failure.title, 'Ejecutable desactualizado');
    expect(failure.message, contains('versión más reciente'));
    expect(failure.message, contains('Tus datos se conservarán'));
    expect(failure.message, isNot(contains('schema version')));
  });

  test('unexpected startup failures retain sanitized diagnostics', () {
    final failure = StartupFailure.from(
      Exception('authorization: Bearer secret-token; conexión rechazada'),
    );

    expect(failure.kind, StartupFailureKind.unexpected);
    expect(failure.title, 'No se pudo iniciar');
    expect(failure.message, contains('conexión rechazada'));
    expect(failure.message, contains('[REDACTADO]'));
    expect(failure.message, isNot(contains('secret-token')));
  });

  test('usage check storage values round-trip', () {
    for (final value in UsageCheckState.values) {
      expect(
        UsageCheckState.fromStorage(value.storageValue),
        value == UsageCheckState.error ? UsageCheckState.error : value,
      );
    }
  });

  test('Codex rate-limit mirrors are deduplicated by bucket and window', () {
    const primary = {
      'usedPercent': 12,
      'windowDurationMins': 300,
      'resetsAt': 1786650000,
    };
    const secondary = {
      'usedPercent': 7,
      'windowDurationMins': 10080,
      'resetsAt': 1787197754,
    };
    const snapshot = {
      'limitId': 'codex',
      'limitName': 'Codex',
      'primary': primary,
      'secondary': secondary,
    };

    final windows = CodexAppServerClient.parseQuotaWindows({
      'rateLimits': snapshot,
      'rateLimitsByLimitId': {'codex': snapshot},
    });

    expect(windows, hasLength(2));
    expect(windows.map((item) => item.windowType), ['primary', 'secondary']);
    expect(windows.first.windowDurationMinutes, 300);
    expect(windows.last.windowDurationMinutes, 10080);
  });

  test('Codex device auth trusts the completed notification result', () {
    final success = CodexDeviceAuthSession.parseCompletionNotification({
      'method': 'account/login/completed',
      'params': {'loginId': 'login-1', 'success': true, 'error': null},
    });
    final failure = CodexDeviceAuthSession.parseCompletionNotification({
      'method': 'account/login/completed',
      'params': {
        'loginId': 'login-2',
        'success': false,
        'error': 'authorization denied',
      },
    });

    expect(success.success, isTrue);
    expect(success.error, isNull);
    expect(failure.success, isFalse);
    expect(failure.error, 'authorization denied');
  });

  test('quota windows use human labels', () {
    expect(formatQuotaWindowLabel(300, 'primary'), 'Ventana de 5 h');
    expect(formatQuotaWindowLabel(10080, 'secondary'), 'Límite semanal');
    final now = DateTime(2026, 8, 13, 10);
    expect(
      formatTimeRemaining(
        now.add(const Duration(days: 6, hours: 13)),
        from: now,
      ),
      '6 d 13 h',
    );
    expect(
      formatTimeRemaining(
        now.add(const Duration(hours: 2, minutes: 18)),
        from: now,
      ),
      '2 h 18 min',
    );
  });

  test('large usage values use stable K, M, and B units', () {
    expect(formatCompactInt(999), '999');
    expect(formatCompactInt(1200), '1,2 K');
    expect(formatCompactInt(999999), '1 M');
    expect(formatCompactInt(1000000), '1 M');
    expect(formatCompactInt(1500000000), '1,5 B');
    expect(formatInteger(1234567), '1.234.567');
    expect(
      formatTokenDetails(322242242),
      '322 M tokens\n322.242.242 tokens exactos',
    );
    expect(formatFullDate(DateTime(2026, 8, 13)), 'Jueves 13 ago 2026');
  });

  test('calendar usage is consolidated and grouped by account', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final day = DateTime(2026, 8, 12);
    final profiles = [
      CliProfile(
        id: 'ari',
        toolKey: 'codex',
        profileName: 'ari',
        displayName: 'Ari Personal',
        profileHome: '/tmp/ari-calendar',
        profileSource: 'multicli',
        profileType: 'full',
        hasAuthFile: true,
        isAvailable: true,
        isFavorite: false,
        createdAt: day,
        lastDiscoveredAt: day,
      ),
      CliProfile(
        id: 'team',
        toolKey: 'codex',
        profileName: 'team',
        displayName: 'Equipo',
        profileHome: '/tmp/team-calendar',
        profileSource: 'multicli',
        profileType: 'full',
        hasAuthFile: true,
        isAvailable: true,
        isFavorite: false,
        createdAt: day,
        lastDiscoveredAt: day,
      ),
    ];
    for (final profile in profiles) {
      await database.into(database.cliProfiles).insert(profile);
    }
    final checks = [
      UsageCheck(
        id: 'ari-check',
        profileId: 'ari',
        queryMethod: 'codex-app-server',
        status: 'success',
        startedAt: day.add(const Duration(hours: 9)),
        accountEmail: 'ari@example.com',
      ),
      UsageCheck(
        id: 'team-check',
        profileId: 'team',
        queryMethod: 'codex-app-server',
        status: 'partial',
        startedAt: day.add(const Duration(hours: 10)),
        accountEmail: 'team@example.com',
      ),
    ];
    for (final check in checks) {
      await database.into(database.usageChecks).insert(check);
    }
    for (final bucket in [
      DailyUsageBucket(
        id: 'ari-older',
        checkId: 'ari-check',
        profileId: 'ari',
        day: DateTime.utc(2026, 8, 12),
        tokens: 1000000,
        source: 'test',
      ),
      DailyUsageBucket(
        id: 'ari-newer',
        checkId: 'ari-check',
        profileId: 'ari',
        day: DateTime.utc(2026, 8, 12),
        tokens: 1500000,
        source: 'test',
      ),
      DailyUsageBucket(
        id: 'team-usage',
        checkId: 'team-check',
        profileId: 'team',
        day: DateTime.utc(2026, 8, 12),
        tokens: 800000,
        source: 'test',
      ),
      DailyUsageBucket(
        id: 'ari-provider-date',
        checkId: 'ari-check',
        profileId: 'ari',
        day: DateTime.utc(2026, 8, 13),
        tokens: 79956487,
        source: 'account/usage/read',
      ),
    ]) {
      await database.into(database.dailyUsageBuckets).insert(bucket);
    }

    final calendar = await AccountRepository(database).loadCalendar();
    final result = calendar[day];

    expect(result, isNotNull);
    expect(result!.tokens, 2300000);
    expect(result.successfulChecks, 2);
    expect(result.accounts.map((item) => item.displayName), [
      'Ari Personal',
      'Equipo',
    ]);
    expect(result.accounts.first.tokens, 1500000);
    expect(calendar[DateTime(2026, 8, 13)]?.tokens, 79956487);
    expect(result.accounts.first.email, 'ari@example.com');
  });

  test('light and dark themes keep compact controls legible', () {
    for (final theme in [AppTheme.dark('cyan'), AppTheme.light('cyan')]) {
      expect(theme.iconTheme.color, theme.colorScheme.onSurfaceVariant);
      expect(
        theme.iconButtonTheme.style?.foregroundColor?.resolve({}),
        theme.colorScheme.onSurfaceVariant,
      );
      expect(
        theme.popupMenuTheme.labelTextStyle?.resolve({})?.fontWeight,
        FontWeight.w400,
      );
      expect(
        theme.popupMenuTheme.labelTextStyle?.resolve({})?.color,
        theme.colorScheme.onSurface,
      );
      expect(theme.dialogTheme.titleTextStyle?.fontSize, lessThan(16));
      expect(theme.tabBarTheme.unselectedLabelColor, isNot(Colors.black));
      expect(
        theme.filledButtonTheme.style?.minimumSize?.resolve({})?.height,
        38,
      );
      expect(
        theme.outlinedButtonTheme.style?.minimumSize?.resolve({})?.height,
        38,
      );
      expect(theme.textButtonTheme.style?.minimumSize?.resolve({})?.height, 36);
    }
  });

  testWidgets('create profile switches cleanly from ChatGPT to Claude', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 620));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final controller = DashboardController(
      database: database,
      discovery: ProfileDiscoveryService(database),
      multiCli: MultiCliGateway(database, runner),
      accountsRepository: AccountRepository(database),
      workspaceRepository: WorkspaceRepository(database),
      usage: UsageRefreshService(
        database: database,
        client: const CodexAppServerClient(),
        runner: runner,
      ),
      runner: runner,
    )..initialized = true;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark('cyan'),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => showCreateProfileDialog(context, controller),
                child: const Text('Abrir creación'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir creación'));
    await tester.pumpAndSettle();

    expect(find.text('Crear en ChatGPT'), findsOneWidget);
    final primaryButton = find.widgetWithText(FilledButton, 'Crear en ChatGPT');
    expect(tester.getSize(primaryButton).height, greaterThanOrEqualTo(38));
    InputDecoration aliasDecoration() => tester
        .widget<InputDecorator>(
          find
              .descendant(
                of: find.byType(TextFormField).first,
                matching: find.byType(InputDecorator),
              )
              .first,
        )
        .decoration;
    expect(aliasDecoration().prefixText, 'codex-');
    expect(find.byType(SegmentedButton<String>), findsNothing);
    expect(find.text('Copiar historial y ajustes'), findsOneWidget);
    expect(find.text('Sembrar configuración base'), findsNothing);

    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Claude · Claude Code').last);
    await tester.pumpAndSettle();

    expect(find.text('Crear en Claude'), findsOneWidget);
    expect(find.text('multi-cli new claude-cli/alias'), findsOneWidget);
    expect(aliasDecoration().prefixText, 'claude-cli-');
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty state remains usable in a narrow surface', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark('cyan'),
        home: const SizedBox(
          width: 320,
          height: 480,
          child: EmptyState(
            icon: Icons.account_tree_outlined,
            title: 'No hay perfiles Codex',
            message: 'Crea una cuenta para comenzar.',
          ),
        ),
      ),
    );

    expect(find.text('No hay perfiles Codex'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('brand icon is bundled as a Flutter asset', (tester) async {
    final data = await rootBundle.load('assets/branding/multicli-ai-icon.png');

    expect(data.lengthInBytes, greaterThan(1000));
  });

  testWidgets('account card fits two distinct quota stacks', (tester) async {
    await tester.binding.setSurfaceSize(const Size(460, 280));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final controller = DashboardController(
      database: database,
      discovery: ProfileDiscoveryService(database),
      multiCli: MultiCliGateway(database, runner),
      accountsRepository: AccountRepository(database),
      workspaceRepository: WorkspaceRepository(database),
      usage: UsageRefreshService(
        database: database,
        client: const CodexAppServerClient(),
        runner: runner,
      ),
      runner: runner,
    );
    expect(controller.concurrency, 3);
    final now = DateTime(2026, 8, 13);
    final check = UsageCheck(
      id: 'check',
      profileId: 'ari',
      queryMethod: 'codex-app-server',
      status: 'success',
      startedAt: now,
      planType: 'plus',
      accountEmail: 'ari@example.com',
    );
    final account = AccountCardData(
      profile: CliProfile(
        id: 'ari',
        toolKey: 'codex',
        profileName: 'ari',
        commandName: 'codex-ari',
        displayName: 'Ari',
        profileHome: '/tmp/ari',
        profileSource: 'multicli',
        profileType: 'full',
        hasAuthFile: true,
        isAvailable: true,
        isFavorite: false,
        createdAt: now,
        lastDiscoveredAt: now,
      ),
      metadata: null,
      costShares: const [],
      currentCheck: check,
      currentWindows: [
        QuotaWindow(
          id: 'short',
          checkId: 'check',
          limitId: 'codex',
          windowType: 'primary',
          usedPercent: 12,
          windowDurationMinutes: 300,
          resetsAt: now.add(const Duration(hours: 2)),
        ),
        QuotaWindow(
          id: 'weekly',
          checkId: 'check',
          limitId: 'codex',
          windowType: 'secondary',
          usedPercent: 7,
          windowDurationMinutes: 10080,
          resetsAt: now.add(const Duration(days: 6)),
        ),
      ],
      lastSuccessfulCheck: check,
      lastSuccessfulWindows: const [],
      resetCredits: null,
    );
    final otherAccount = AccountCardData(
      profile: account.profile.copyWith(
        id: 'sol',
        profileName: 'sol',
        displayName: 'Sol',
        profileHome: '/tmp/sol',
      ),
      metadata: null,
      costShares: const [],
      currentCheck: null,
      currentWindows: const [],
      lastSuccessfulCheck: null,
      lastSuccessfulWindows: const [],
      resetCredits: null,
    );
    final fillerAccounts = List.generate(
      8,
      (index) => AccountCardData(
        profile: account.profile.copyWith(
          id: 'filler-$index',
          profileName: 'filler-$index',
          displayName: 'Cuenta $index',
          profileHome: '/tmp/filler-$index',
        ),
        metadata: null,
        costShares: const [],
        currentCheck: null,
        currentWindows: const [],
        lastSuccessfulCheck: null,
        lastSuccessfulWindows: const [],
        resetCredits: null,
      ),
    );
    controller
      ..accounts = [otherAccount, ...fillerAccounts, account]
      ..selectedProfileId = otherAccount.profile.id
      ..workspaces = [
        Workspace(
          id: 'workspace',
          path: '/home/nini/StudioProjects/multi_cli_ai',
          pathKey: '/home/nini/StudioProjects/multi_cli_ai',
          name: 'multi_cli_ai',
          openCount: 1,
          createdAt: now,
          lastUsedAt: now,
        ),
      ]
      ..currentWorkspaceId = 'workspace';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark('cyan'),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 430,
              height: 216,
              child: AccountCard(
                account: account,
                refreshing: false,
                compact: false,
                controller: controller,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('codex-ari'), findsOneWidget);
    expect(find.text('Ventana de 5 h'), findsOneWidget);
    expect(find.text('Límite semanal'), findsOneWidget);
    expect(find.text('93% disponible'), findsOneWidget);
    expect(find.byTooltip('Lanzar agente con Ari'), findsOneWidget);
    final terminalRect = tester.getRect(
      find.byTooltip('Lanzar agente con Ari'),
    );
    final refreshRect = tester.getRect(
      find.byTooltip('Consultar sólo esta cuenta'),
    );
    expect(terminalRect.right, lessThanOrEqualTo(refreshRect.left));
    expect(
      tester
          .widget<Icon>(
            find.descendant(
              of: find.byTooltip('Editar perfil'),
              matching: find.byIcon(Icons.edit_outlined),
            ),
          )
          .size,
      18,
    );
    expect(
      tester
          .widget<Icon>(
            find.descendant(
              of: find.byTooltip('Más acciones'),
              matching: find.byIcon(Icons.more_vert),
            ),
          )
          .size,
      18,
    );
    final cardRect = tester.getRect(find.byType(AccountCard));
    final availableRect = tester.getRect(find.text('93% disponible'));
    final weeklyRect = tester.getRect(find.text('Límite semanal'));
    final weeklyResetRect = tester.getRect(
      find.textContaining('Reinicia en').last,
    );
    expect(cardRect.right - availableRect.right, closeTo(11, 1));
    expect(weeklyResetRect.left - weeklyRect.right, lessThanOrEqualTo(20));
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Más acciones'));
    await tester.pumpAndSettle();
    expect(find.text('Renombrar alias físico'), findsOneWidget);
    expect(find.text('Eliminar perfil'), findsOneWidget);
    expect(
      DefaultTextStyle.of(
        tester.element(find.text('Renombrar alias físico')),
      ).style.fontWeight,
      FontWeight.w400,
    );
    expect(
      IconTheme.of(
        tester.element(find.byIcon(Icons.drive_file_rename_outline)),
      ).color,
      AppTheme.dark('cyan').colorScheme.onSurfaceVariant,
    );
    expect(tester.takeException(), isNull);
    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Elegir destino'), findsNothing);
    expect(find.byIcon(Icons.terminal_rounded), findsOneWidget);

    await tester.binding.setSurfaceSize(const Size(900, 620));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Lanzar agente con Ari'));
    await tester.pumpAndSettle();
    final ariPicker = find.byKey(const ValueKey('launch-account-ari'));
    expect(
      find.descendant(of: ariPicker, matching: find.byIcon(Icons.check_circle)),
      findsOneWidget,
    );
    expect(
      tester
          .widget<GridView>(find.byKey(const Key('launch-account-list')))
          .controller!
          .offset,
      greaterThan(0),
    );
    expect(
      find.descendant(of: ariPicker, matching: find.text('88% disponible')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<LinearProgressIndicator>(
            find.byKey(const ValueKey('launch-account-availability-ari')),
          )
          .value,
      closeTo(.88, .001),
    );
    await tester.tap(find.byTooltip('Cerrar'));
    await tester.pumpAndSettle();
    unawaited(
      showEditAccountDialog(
        tester.element(find.byType(AccountCard)),
        controller,
        account,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Editar perfil "Ari"'), findsOneWidget);
    final accountTabScroll = tester.widget<ListView>(
      find
          .descendant(
            of: find.byType(TabBarView),
            matching: find.byType(ListView),
          )
          .first,
    );
    expect(accountTabScroll.padding, const EdgeInsets.fromLTRB(0, 9, 0, 4));
    final subscriptionTabIcon = find
        .descendant(
          of: find.byType(TabBar),
          matching: find.byIcon(Icons.event_repeat),
        )
        .first;
    expect(
      IconTheme.of(tester.element(subscriptionTabIcon)).color,
      AppTheme.dark('cyan').colorScheme.onSurfaceVariant,
    );
    await tester.tap(find.text('Renovación'));
    await tester.pumpAndSettle();
    expect(find.text('Fecha de próxima renovación'), findsOneWidget);
    expect(find.text('Precio por renovación'), findsOneWidget);
    expect(find.text('Estado de la suscripción'), findsOneWidget);
    expect(find.text('Estado comercial'), findsNothing);

    await tester.tap(find.byKey(const Key('next-renewal-date-field')));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    Navigator.of(tester.element(find.byType(DatePickerDialog))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('currency-field')));
    await tester.pumpAndSettle();
    expect(find.text('Seleccionar moneda'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('currency-search-field')),
      'JPY',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yen japonés'));
    await tester.pumpAndSettle();
    expect(find.text('JPY · Yen japonés'), findsOneWidget);
    await tester.tap(find.byTooltip('Cerrar'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark('cyan'),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 430,
              height: 186,
              child: AccountCard(
                account: account,
                refreshing: false,
                compact: true,
                controller: controller,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ventana de 5 h'), findsOneWidget);
    expect(find.text('Límite semanal'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('agent launcher keeps workspaces separate from accounts', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 620));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final controller = DashboardController(
      database: database,
      discovery: ProfileDiscoveryService(database),
      multiCli: MultiCliGateway(database, runner),
      accountsRepository: AccountRepository(database),
      workspaceRepository: WorkspaceRepository(database),
      usage: UsageRefreshService(
        database: database,
        client: const CodexAppServerClient(),
        runner: runner,
      ),
      runner: runner,
    )..initialized = true;
    final now = DateTime(2026, 8, 14);
    final account = AccountCardData(
      profile: CliProfile(
        id: 'ari',
        toolKey: 'codex',
        profileName: 'ari',
        commandName: 'codex-ari',
        displayName: 'Ari',
        profileHome: '/tmp/ari',
        profileSource: 'multicli',
        profileType: 'full',
        hasAuthFile: true,
        isAvailable: true,
        isFavorite: false,
        createdAt: now,
        lastDiscoveredAt: now,
      ),
      metadata: null,
      costShares: const [],
      currentCheck: null,
      currentWindows: const [],
      lastSuccessfulCheck: null,
      lastSuccessfulWindows: const [],
      resetCredits: null,
    );
    controller
      ..accounts = [account]
      ..selectedProfileId = account.profile.id
      ..workspaces = [
        Workspace(
          id: 'workspace',
          path: '/home/nini/StudioProjects/multi_cli_ai',
          pathKey: '/home/nini/StudioProjects/multi_cli_ai',
          name: 'multi_cli_ai',
          openCount: 3,
          createdAt: now,
          lastUsedAt: now,
        ),
        Workspace(
          id: 'workspace-2',
          path: '/home/nini/StudioProjects/parla',
          pathKey: '/home/nini/StudioProjects/parla',
          name: 'parla',
          openCount: 2,
          createdAt: now,
          lastUsedAt: now.subtract(const Duration(minutes: 5)),
        ),
        Workspace(
          id: 'workspace-3',
          path: '/home/nini/StudioProjects/bora_asai',
          pathKey: '/home/nini/StudioProjects/bora_asai',
          name: 'bora_asai',
          openCount: 1,
          createdAt: now,
          lastUsedAt: now.subtract(const Duration(minutes: 10)),
        ),
        Workspace(
          id: 'workspace-4',
          path: '/home/nini/StudioProjects/archivo',
          pathKey: '/home/nini/StudioProjects/archivo',
          name: 'archivo',
          openCount: 1,
          createdAt: now,
          lastUsedAt: now.subtract(const Duration(minutes: 15)),
        ),
      ]
      ..currentWorkspaceId = 'workspace';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardControllerProvider.overrideWith((ref) => controller),
        ],
        child: MaterialApp(
          theme: AppTheme.dark('cyan'),
          home: const Scaffold(body: AccountsView()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Workspaces recientes'), findsNothing);
    expect(find.text('multi_cli_ai'), findsNothing);
    expect(find.text('3 de 4'), findsNothing);
    expect(find.text('parla'), findsNothing);
    expect(find.text('bora_asai'), findsNothing);
    expect(find.text('archivo'), findsNothing);
    expect(find.byTooltip('Elegir destino'), findsNothing);
    await tester.tap(find.widgetWithText(FilledButton, 'Lanzar agente').first);
    await tester.pumpAndSettle();

    expect(find.text('Workspaces'), findsOneWidget);
    expect(find.text('Cuenta para lanzar'), findsOneWidget);
    expect(find.text('multi_cli_ai'), findsOneWidget);
    expect(find.byKey(const Key('launch-workspace-search')), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('launch-workspace-search')),
      'archivo',
    );
    await tester.pumpAndSettle();
    expect(find.text('archivo'), findsNWidgets(2));
    expect(find.text('multi_cli_ai'), findsNothing);
    expect(find.text('parla'), findsNothing);
    expect(find.text('Ari'), findsNWidgets(2));
    expect(find.text('Abrir en Inicio'), findsNothing);
    expect(
      tester
          .widget<ListView>(find.byKey(const Key('launch-workspace-list')))
          .scrollDirection,
      Axis.vertical,
    );
    var launchButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Lanzar agente').last,
    );
    expect(launchButton.onPressed, isNull);
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('launch-workspace-list')),
        matching: find.text('archivo'),
      ),
    );
    await tester.pumpAndSettle();
    launchButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Lanzar agente').last,
    );
    expect(launchButton.onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('calendar lays out at the minimum desktop size', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 620));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final runner = ProcessRunner(database);
    final controller =
        DashboardController(
            database: database,
            discovery: ProfileDiscoveryService(database),
            multiCli: MultiCliGateway(database, runner),
            accountsRepository: AccountRepository(database),
            workspaceRepository: WorkspaceRepository(database),
            usage: UsageRefreshService(
              database: database,
              client: const CodexAppServerClient(),
              runner: runner,
            ),
            runner: runner,
          )
          ..initialized = true
          ..selectedDay = DateTime(2026, 8, 13)
          ..calendar = {
            DateTime(2026, 8, 12): CalendarDayData(
              day: DateTime(2026, 8, 12),
              tokens: 4500000,
              successfulChecks: 1,
              failedChecks: 0,
              lowestRemaining: 61,
              resetCount: 0,
              renewalCount: 0,
              accounts: const [
                AccountDayUsage(
                  profileId: 'sol',
                  displayName: 'Sol Team',
                  email: 'sol@example.com',
                  tokens: 4500000,
                  successfulChecks: 1,
                  failedChecks: 0,
                  lowestRemaining: 61,
                  resetCount: 0,
                  renewalCount: 0,
                ),
              ],
            ),
            DateTime(2026, 8, 13): CalendarDayData(
              day: DateTime(2026, 8, 13),
              tokens: 322242242,
              successfulChecks: 2,
              failedChecks: 0,
              lowestRemaining: 42,
              resetCount: 1,
              renewalCount: 0,
              accounts: const [
                AccountDayUsage(
                  profileId: 'ari',
                  displayName: 'Ari Personal',
                  email: 'ari@example.com',
                  tokens: 322242242,
                  successfulChecks: 2,
                  failedChecks: 0,
                  lowestRemaining: 100,
                  resetCount: 1,
                  renewalCount: 0,
                ),
              ],
            ),
          };

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardControllerProvider.overrideWith((ref) => controller),
        ],
        child: MaterialApp(
          theme: AppTheme.dark('cyan'),
          home: const Scaffold(body: UsageCalendarView()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.text('Estadísticas de uso'), findsOneWidget);
    expect(find.text('Tokens en Agosto 2026'), findsOneWidget);
    expect(find.text('HOY'), findsOneWidget);
    expect(find.text('Hoy'), findsAtLeastNWidgets(1));
    expect(find.byType(Dialog), findsNothing);
    expect(find.text(formatFullDate(DateTime(2026, 8, 13))), findsOneWidget);
    expect(find.text('322 M'), findsAtLeastNWidgets(1));
    expect(find.text('322.242.242 exactos'), findsAtLeastNWidgets(1));
    expect(
      find.byTooltip(formatTokenDetails(322242242)),
      findsAtLeastNWidgets(2),
    );
    await tester.tap(find.byKey(const ValueKey('calendar-day-2026-8-13')));
    await tester.pumpAndSettle();
    expect(find.text('Uso por cuenta'), findsOneWidget);
    expect(find.text('Ari Personal'), findsOneWidget);
    expect(find.text('Cuota disponible'), findsOneWidget);
    expect(find.text('100% disponible'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(
            find.byKey(const ValueKey('calendar-availability-ari')),
          )
          .value,
      1,
    );
    expect(find.byType(Dialog), findsNothing);
    await tester.tap(find.byKey(const ValueKey('calendar-day-2026-8-12')));
    await tester.pumpAndSettle();
    expect(find.text(formatFullDate(DateTime(2026, 8, 12))), findsOneWidget);
    expect(find.text('Sol Team'), findsOneWidget);
    expect(find.text('Ari Personal'), findsNothing);
    expect(find.byType(Dialog), findsNothing);
    final nextMonth = DateTime(
      controller.selectedDay.year,
      controller.selectedDay.month + 1,
    );
    await tester.tap(find.byTooltip('Mes siguiente'));
    await tester.pumpAndSettle();
    expect(find.text(formatMonth(nextMonth)), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Hoy'));
    await tester.pumpAndSettle();
    expect(find.text(formatMonth(DateTime.now())), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
