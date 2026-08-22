import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_cli_ai/app/dashboard_controller.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/process/process_runner.dart';
import 'package:multi_cli_ai/features/accounts/data/account_repository.dart';
import 'package:multi_cli_ai/features/profiles/data/multi_cli_gateway.dart';
import 'package:multi_cli_ai/features/profiles/data/profile_discovery_service.dart';
import 'package:multi_cli_ai/features/usage/data/codex_weekly_keep_alive_service.dart';
import 'package:multi_cli_ai/features/usage/data/usage_refresh_service.dart';
import 'package:multi_cli_ai/features/workspaces/data/workspace_repository.dart';
import 'package:multi_cli_ai/providers/codex/codex_app_server_client.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});

final dashboardControllerProvider = ChangeNotifierProvider<DashboardController>(
  (ref) {
    final database = ref.watch(databaseProvider);
    final runner = ProcessRunner(database);
    final keepAlive = CodexWeeklyKeepAliveService(
      database: database,
      runner: runner,
    );
    ref.onDispose(keepAlive.dispose);
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
        keepAlive: keepAlive,
      ),
      runner: runner,
    );
    unawaited(controller.initialize());
    return controller;
  },
);
