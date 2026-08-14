import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:multi_cli_ai/app/dashboard_controller.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';

Future<Workspace?> pickWorkspace(
  BuildContext context,
  DashboardController controller,
) async {
  final path = await getDirectoryPath(
    initialDirectory:
        controller.currentWorkspace?.path ?? controller.userHomeDirectory,
    confirmButtonText: 'Usar workspace',
    canCreateDirectories: true,
  );
  if (path == null) return null;
  try {
    return await controller.addWorkspace(path);
  } catch (error) {
    if (!context.mounted) return null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString().replaceFirst('Bad state: ', ''))),
    );
    return null;
  }
}

Future<void> renameWorkspace(
  BuildContext context,
  DashboardController controller,
  Workspace workspace,
) async {
  final nameController = TextEditingController(text: workspace.name);
  final name = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Renombrar workspace'),
      content: TextField(
        controller: nameController,
        autofocus: true,
        maxLength: 80,
        decoration: const InputDecoration(labelText: 'Nombre'),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(nameController.text),
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
  nameController.dispose();
  if (name == null) return;
  try {
    await controller.renameWorkspace(workspace, name);
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString().replaceFirst('FormatException: ', '')),
      ),
    );
  }
}

Future<void> forgetWorkspace(
  BuildContext context,
  DashboardController controller,
  Workspace workspace,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Quitar del historial'),
      content: Text(workspace.name),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Quitar'),
        ),
      ],
    ),
  );
  if (confirmed == true) await controller.forgetWorkspace(workspace);
}
