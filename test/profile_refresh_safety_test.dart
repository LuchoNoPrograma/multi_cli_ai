import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_cli_ai/app/dashboard_controller.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/process/process_runner.dart';
import 'package:multi_cli_ai/features/accounts/data/account_repository.dart';
import 'package:multi_cli_ai/features/accounts/domain/account_models.dart';
import 'package:multi_cli_ai/features/profiles/data/multi_cli_gateway.dart';
import 'package:multi_cli_ai/features/profiles/data/profile_discovery_service.dart';
import 'package:multi_cli_ai/features/usage/data/usage_refresh_service.dart';
import 'package:multi_cli_ai/features/workspaces/data/workspace_repository.dart';
import 'package:multi_cli_ai/providers/codex/codex_app_server_client.dart';

void main() {
  test('usage refresh rediscovers profiles before starting Codex', () async {
    final root = await Directory.systemTemp.createTemp(
      'multicli-ai-refresh-safety-',
    );
    addTearDown(() => root.delete(recursive: true));
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.saveSetting('profiles_root_path', root.path);

    final staleHome = '${root.path}/codex/willy';
    final now = DateTime.now().toUtc();
    await database
        .into(database.cliProfiles)
        .insert(
          CliProfile(
            id: 'willy',
            toolKey: 'codex',
            profileName: 'willy',
            commandName: 'codex-willy',
            displayName: 'Willy',
            profileHome: staleHome,
            profileSource: 'multicli',
            profileType: 'full',
            hasAuthFile: true,
            isAvailable: true,
            isFavorite: false,
            createdAt: now,
            lastDiscoveredAt: now,
          ),
        );

    final runner = ProcessRunner(database);
    final client = _RecordingCodexClient();
    final controller = DashboardController(
      database: database,
      discovery: ProfileDiscoveryService(database),
      multiCli: MultiCliGateway(database, runner),
      accountsRepository: AccountRepository(database),
      workspaceRepository: WorkspaceRepository(database),
      usage: UsageRefreshService(
        database: database,
        client: client,
        runner: runner,
      ),
      runner: runner,
    );
    await controller.reload();
    final staleAccount = controller.accounts.singleWhere(
      (item) => item.profile.id == 'willy',
    );
    expect(staleAccount.profile.isAvailable, isTrue);

    await controller.refreshAll();

    expect(client.profileHomes, isNot(contains(staleHome)));
    expect(
      controller.accounts
          .singleWhere((item) => item.profile.id == 'willy')
          .profile
          .isAvailable,
      isFalse,
    );
    await expectLater(
      controller.refreshOne(staleAccount),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('No se realizó ninguna consulta'),
        ),
      ),
    );
    expect(client.profileHomes, isNot(contains(staleHome)));
  });
}

class _RecordingCodexClient extends CodexAppServerClient {
  final List<String> profileHomes = [];

  @override
  Future<CodexRefreshResult> refresh(String profileHome) async {
    profileHomes.add(profileHome);
    final now = DateTime.now().toUtc();
    return CodexRefreshResult(
      state: UsageCheckState.success,
      startedAt: now,
      completedAt: now,
    );
  }
}
