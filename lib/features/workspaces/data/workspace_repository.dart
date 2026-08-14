import 'dart:io';

import 'package:drift/drift.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class WorkspaceRepository {
  WorkspaceRepository(this.database);

  final AppDatabase database;
  final Uuid _uuid = const Uuid();

  Future<List<Workspace>> loadWorkspaces() => (database.select(
    database.workspaces,
  )..orderBy([(row) => OrderingTerm.desc(row.lastUsedAt)])).get();

  Future<Workspace> add(String path) => _remember(path, opened: false);

  Future<Workspace> recordOpened(String path) => _remember(path, opened: true);

  Future<void> select(String id) async {
    final lastUsedAt = await _nextLastUsedAt();
    await (database.update(database.workspaces)
          ..where((row) => row.id.equals(id)))
        .write(WorkspacesCompanion(lastUsedAt: Value(lastUsedAt)));
  }

  Future<void> rename(String id, String name) async {
    final value = name.trim();
    if (value.isEmpty) {
      throw const FormatException(
        'El nombre del workspace no puede quedar vacío.',
      );
    }
    await (database.update(database.workspaces)
          ..where((row) => row.id.equals(id)))
        .write(WorkspacesCompanion(name: Value(value)));
  }

  Future<void> remove(String id) => (database.delete(
    database.workspaces,
  )..where((row) => row.id.equals(id))).go();

  Future<Workspace> _remember(String value, {required bool opened}) async {
    final path = validatePath(value);
    final key = pathKey(path);
    final existing = await (database.select(
      database.workspaces,
    )..where((row) => row.pathKey.equals(key))).getSingleOrNull();
    final now = await _nextLastUsedAt();
    if (existing == null) {
      final id = _uuid.v4();
      await database
          .into(database.workspaces)
          .insert(
            WorkspacesCompanion.insert(
              id: id,
              path: path,
              pathKey: key,
              name: defaultName(path),
              openCount: Value(opened ? 1 : 0),
              createdAt: now,
              lastUsedAt: now,
            ),
          );
      return (database.select(
        database.workspaces,
      )..where((row) => row.id.equals(id))).getSingle();
    }

    await (database.update(
      database.workspaces,
    )..where((row) => row.id.equals(existing.id))).write(
      WorkspacesCompanion(
        path: Value(path),
        lastUsedAt: Value(now),
        openCount: Value(existing.openCount + (opened ? 1 : 0)),
      ),
    );
    return (database.select(
      database.workspaces,
    )..where((row) => row.id.equals(existing.id))).getSingle();
  }

  static String validatePath(String value) {
    final directory = Directory(value.trim()).absolute;
    if (!directory.existsSync()) {
      throw StateError('El workspace seleccionado ya no existe.');
    }
    return p.normalize(directory.path);
  }

  static String pathKey(String path) {
    final normalized = p.normalize(Directory(path).absolute.path);
    return Platform.isWindows ? normalized.toLowerCase() : normalized;
  }

  static String defaultName(String path) {
    final name = p.basename(path);
    return name.isEmpty ? path : name;
  }

  Future<DateTime> _nextLastUsedAt() async {
    final latest =
        await (database.select(database.workspaces)
              ..orderBy([(row) => OrderingTerm.desc(row.lastUsedAt)])
              ..limit(1))
            .getSingleOrNull();
    final rawNow = DateTime.now().toUtc();
    final now = DateTime.fromMillisecondsSinceEpoch(
      (rawNow.millisecondsSinceEpoch ~/ 1000) * 1000,
      isUtc: true,
    );
    if (latest == null || now.isAfter(latest.lastUsedAt)) return now;
    return latest.lastUsedAt.add(const Duration(seconds: 1));
  }
}
