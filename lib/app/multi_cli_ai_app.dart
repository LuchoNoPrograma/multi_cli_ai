import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_cli_ai/app/providers.dart';
import 'package:multi_cli_ai/core/theme/app_theme.dart';
import 'package:multi_cli_ai/features/dashboard/presentation/dashboard_shell.dart';

class MultiCliAiApp extends ConsumerWidget {
  const MultiCliAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dashboardControllerProvider);
    final mode = switch (controller.themePreference) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MultiCLI AI',
      theme: AppTheme.light(
        controller.accentPreference,
        fontScale: controller.fontScale,
        fontFamily: controller.fontFamilyPreference,
      ),
      darkTheme: AppTheme.dark(
        controller.accentPreference,
        fontScale: controller.fontScale,
        fontFamily: controller.fontFamilyPreference,
      ),
      themeMode: mode,
      home: const DashboardShell(),
    );
  }
}
