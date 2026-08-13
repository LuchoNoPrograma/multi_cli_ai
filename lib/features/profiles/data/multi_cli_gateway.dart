import 'dart:io';

import 'package:drift/drift.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/process/process_runner.dart';
import 'package:multi_cli_ai/features/profiles/domain/profile_provider.dart';
import 'package:path/path.dart' as p;

class ProfileCreateRequest {
  const ProfileCreateRequest({
    required this.toolKey,
    required this.name,
    required this.displayName,
    this.profileType = 'full',
    this.seedFromBase = false,
  });

  final String toolKey;
  final String name;
  final String displayName;
  final String profileType;
  final bool seedFromBase;
}

class MultiCliGateway {
  MultiCliGateway(this.database, this.runner);

  final AppDatabase database;
  final ProcessRunner runner;

  static final RegExp _safeName = RegExp(r'^[A-Za-z0-9][A-Za-z0-9_-]{0,47}$');

  String get userHomeDirectory {
    final environment = Platform.environment;
    final home = Platform.isWindows
        ? environment['USERPROFILE']
        : environment['HOME'];
    if (home == null || home.trim().isEmpty) {
      throw StateError('No se pudo determinar la carpeta de Inicio.');
    }
    return validateWorkingDirectory(home, label: 'La carpeta de Inicio');
  }

  static String validateName(String raw) {
    final name = raw.trim();
    if (!_safeName.hasMatch(name)) {
      throw const FormatException(
        'Usa entre 1 y 48 caracteres: letras, números, guion o guion bajo.',
      );
    }
    return name;
  }

  Future<SafeProcessResult> create(ProfileCreateRequest request) async {
    final name = validateName(request.name);
    final provider = profileProvider(request.toolKey);
    final args = <String>['new', provider.profileSpec(name)];
    if (request.profileType == 'shared') args.add('--shared');
    if (request.profileType == 'cli') args.add('--cli');
    if (!request.seedFromBase) args.add('--no-seed');
    final result = await runner.run(
      executable: 'multi-cli',
      arguments: args,
      summary: 'Crear perfil ${provider.productName} $name',
      timeout: const Duration(minutes: 2),
    );
    if (!result.succeeded) {
      throw StateError(
        result.combinedOutput.isEmpty
            ? 'Multi CLI no pudo crear el perfil.'
            : result.combinedOutput,
      );
    }
    return result;
  }

  Future<SafeProcessResult> rename(CliProfile profile, String rawName) async {
    if (profile.profileSource != 'multicli') {
      throw StateError(
        'El perfil principal no puede renombrarse con Multi CLI.',
      );
    }
    final name = validateName(rawName);
    final provider = profileProvider(profile.toolKey);
    if (name == profile.profileName) {
      throw StateError('El nombre físico no cambió.');
    }
    final result = await runner.run(
      executable: 'multi-cli',
      arguments: [
        'rename',
        provider.profileSpec(profile.profileName),
        provider.profileSpec(name),
      ],
      summary: 'Renombrar ${profile.profileName} a $name',
      profileId: profile.id,
      timeout: const Duration(minutes: 2),
    );
    if (!result.succeeded) throw StateError(result.combinedOutput);

    final newHome = p.join(p.dirname(profile.profileHome), name);
    await (database.update(
      database.cliProfiles,
    )..where((row) => row.id.equals(profile.id))).write(
      CliProfilesCompanion(
        profileName: Value(name),
        commandName: Value(provider.commandName(name)),
        profileHome: Value(newHome),
        lastDiscoveredAt: Value(DateTime.now().toUtc()),
      ),
    );
    return result;
  }

  Future<SafeProcessResult> delete(CliProfile profile) async {
    if (profile.profileSource != 'multicli') {
      throw StateError(
        'El perfil principal no se elimina desde esta aplicación.',
      );
    }
    final provider = profileProvider(profile.toolKey);
    final result = await runner.run(
      executable: 'multi-cli',
      arguments: ['delete', provider.profileSpec(profile.profileName)],
      summary: 'Eliminar perfil ${profile.profileName}',
      profileId: profile.id,
      stdinText: 'y\n',
      timeout: const Duration(minutes: 2),
    );
    if (!result.succeeded) throw StateError(result.combinedOutput);
    await (database.delete(
      database.cliProfiles,
    )..where((row) => row.id.equals(profile.id))).go();
    return result;
  }

  Future<void> launch(
    CliProfile profile, {
    required String workingDirectory,
  }) async {
    if (!Directory(profile.profileHome).existsSync()) {
      throw StateError('La carpeta del perfil ya no existe.');
    }
    final launchDirectory = validateWorkingDirectory(
      workingDirectory,
      label: 'La carpeta seleccionada',
    );
    final terminalTitle = buildTerminalTitle(
      profileName: profile.profileName,
      workingDirectory: launchDirectory,
    );
    final provider = profileProvider(profile.toolKey);
    if (profile.profileSource == 'multicli') {
      await runner.startInTerminal(
        executable: 'multi-cli',
        arguments: [
          'launch',
          provider.profileSpec(profile.profileName),
          if (provider.launchArguments.isNotEmpty) ...[
            '--',
            ...provider.launchArguments,
          ],
        ],
        summary: 'Abrir ${profile.displayName}',
        profileId: profile.id,
        workingDirectory: launchDirectory,
        title: terminalTitle,
      );
    } else {
      await runner.startInTerminal(
        executable: provider.executable,
        arguments: provider.launchArguments,
        summary: 'Abrir ${provider.productName} principal',
        profileId: profile.id,
        workingDirectory: launchDirectory,
        title: terminalTitle,
      );
    }
    await (database.update(
      database.cliProfiles,
    )..where((row) => row.id.equals(profile.id))).write(
      CliProfilesCompanion(lastLaunchedAt: Value(DateTime.now().toUtc())),
    );
  }

  static String buildTerminalTitle({
    required String profileName,
    required String workingDirectory,
  }) {
    final directoryName = p.basename(workingDirectory);
    final directoryLabel = directoryName.isEmpty
        ? workingDirectory
        : directoryName;
    return '$profileName · $directoryLabel';
  }

  Future<void> saveDisplayData({
    required CliProfile profile,
    required String displayName,
    required bool favorite,
  }) =>
      (database.update(
        database.cliProfiles,
      )..where((row) => row.id.equals(profile.id))).write(
        CliProfilesCompanion(
          displayName: Value(
            displayName.trim().isEmpty
                ? profile.profileName
                : displayName.trim(),
          ),
          isFavorite: Value(favorite),
        ),
      );

  static String validateWorkingDirectory(
    String value, {
    String label = 'La carpeta seleccionada',
  }) {
    final directory = Directory(value.trim()).absolute;
    if (!directory.existsSync()) {
      throw StateError('$label no existe.');
    }
    return p.normalize(directory.path);
  }
}
