import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:multi_cli_ai/app/dashboard_controller.dart';
import 'package:multi_cli_ai/app/providers.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/process/process_runner.dart';
import 'package:multi_cli_ai/core/theme/app_theme.dart';
import 'package:multi_cli_ai/features/accounts/data/account_repository.dart';
import 'package:multi_cli_ai/features/activity/presentation/activity_view.dart';
import 'package:multi_cli_ai/features/profiles/data/multi_cli_gateway.dart';
import 'package:multi_cli_ai/features/profiles/data/profile_discovery_service.dart';
import 'package:multi_cli_ai/features/usage/data/usage_refresh_service.dart';
import 'package:multi_cli_ai/features/workspaces/data/workspace_repository.dart';
import 'package:multi_cli_ai/providers/codex/codex_app_server_client.dart';

void main() {
  setUpAll(() => initializeDateFormatting('es'));

  testWidgets('activity uses a selectable log and detail layout', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 620));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final controller = _controller(database);
    final now = DateTime(2026, 8, 13, 10, 30);
    const longCommand =
        '/usr/bin/gnome-terminal --title=codex-ari '
        '--working-directory=/home/nini/StudioProjects/multi_cli_ai -- '
        '/home/nini/.local/bin/multi-cli launch codex/ari';
    controller.logs = [
      CommandLog(
        id: 'refresh-ari',
        profileId: 'ari',
        command: longCommand,
        summary: 'Consultar cuota de Ari',
        output: 'Cuota actualizada correctamente.',
        status: 'success',
        exitCode: 0,
        startedAt: now,
        completedAt: now,
      ),
      CommandLog(
        id: 'refresh-sol',
        profileId: 'sol',
        command: 'codex app-server account/read',
        summary: 'Consultar cuenta de Sol',
        output: 'La sesión expiró.',
        status: 'error',
        exitCode: 1,
        startedAt: now.subtract(const Duration(minutes: 8)),
        completedAt: now.subtract(const Duration(minutes: 7, seconds: 59)),
      ),
    ];

    await _pumpActivity(tester, controller);

    expect(find.text('Log'), findsOneWidget);
    expect(find.text('2 eventos'), findsOneWidget);
    expect(find.text('0 ms'), findsNothing);
    expect(find.text('Cuota actualizada correctamente.'), findsOneWidget);
    final commandText = tester.widget<Text>(find.text(longCommand));
    expect(commandText.maxLines, 2);
    expect(commandText.style?.fontWeight, FontWeight.w400);
    await tester.tap(find.text('Consultar cuenta de Sol'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('La sesión expiró.'), findsOneWidget);
    expect(find.text('Código 1'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('activity-search')),
      'Ari',
    );
    await tester.pump();
    expect(find.text('1 de 2'), findsOneWidget);
    expect(find.text('Consultar cuenta de Sol'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('activity opens log detail on a narrow surface', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 620));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final controller = _controller(database)
      ..logs = [
        CommandLog(
          id: 'narrow-log',
          command: 'multi-cli create codex/ari',
          summary: 'Crear perfil Ari',
          output: 'Perfil creado.',
          status: 'success',
          exitCode: 0,
          startedAt: DateTime(2026, 8, 13),
          completedAt: DateTime(2026, 8, 13, 0, 0, 1),
        ),
      ];

    await _pumpActivity(tester, controller);
    await tester.tap(find.text('Crear perfil Ari'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Perfil creado.'), findsOneWidget);
    expect(find.text('SALIDA'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

DashboardController _controller(AppDatabase database) {
  final runner = ProcessRunner(database);
  return DashboardController(
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
}

Future<void> _pumpActivity(
  WidgetTester tester,
  DashboardController controller,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dashboardControllerProvider.overrideWith((ref) => controller),
      ],
      child: MaterialApp(
        theme: AppTheme.dark('cyan'),
        home: const Scaffold(body: ActivityView()),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
}
