import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_cli_ai/app/dashboard_controller.dart';
import 'package:multi_cli_ai/app/providers.dart';
import 'package:multi_cli_ai/core/widgets/app_primitives.dart';
import 'package:multi_cli_ai/features/accounts/presentation/accounts_view.dart';
import 'package:multi_cli_ai/features/activity/presentation/activity_view.dart';
import 'package:multi_cli_ai/features/settings/presentation/settings_dialog.dart';
import 'package:multi_cli_ai/features/usage/presentation/calendar_view.dart';

class DashboardShell extends ConsumerWidget {
  const DashboardShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dashboardControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _OperationsBar(controller: controller),
            if (controller.loading || controller.refreshing.isNotEmpty)
              LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Colors.transparent,
                value: controller.refreshing.length <= 1 ? null : null,
              ),
            Expanded(child: _body(context, controller)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, DashboardController controller) {
    if (controller.fatalError != null && !controller.initialized) {
      final failure = controller.fatalError!;
      return EmptyState(
        icon: failure.kind == StartupFailureKind.updateRequired
            ? Icons.system_update_alt
            : Icons.error_outline,
        title: failure.title,
        message: failure.message,
        action: FilledButton.icon(
          onPressed: controller.initialize,
          icon: const Icon(Icons.refresh),
          label: const Text('Reintentar'),
        ),
      );
    }
    if (!controller.initialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final content = switch (controller.section) {
      AppSection.accounts => const AccountsView(key: ValueKey('accounts')),
      AppSection.calendar => const UsageCalendarView(key: ValueKey('calendar')),
      AppSection.activity => const ActivityView(key: ValueKey('activity')),
    };
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(.015, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: content,
    );
  }
}

class _OperationsBar extends StatelessWidget {
  const _OperationsBar({required this.controller});

  final DashboardController controller;

  Future<void> _guard(BuildContext context, Future<void> future) async {
    try {
      await future;
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Bad state: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 132,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    'assets/branding/multicli-ai-icon.png',
                    width: 20,
                    height: 20,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                const SizedBox(width: 7),
                Text('MultiCLI AI', style: theme.textTheme.titleMedium),
              ],
            ),
          ),
          _TopMenuItem(
            label: 'Cuentas',
            selected: controller.section == AppSection.accounts,
            onTap: () => controller.setSection(AppSection.accounts),
          ),
          _TopMenuItem(
            label: 'Estadísticas',
            selected: controller.section == AppSection.calendar,
            onTap: () => controller.setSection(AppSection.calendar),
          ),
          _TopMenuItem(
            label: 'Log',
            selected: controller.section == AppSection.activity,
            onTap: () => controller.setSection(AppSection.activity),
          ),
          const Spacer(),
          if (controller.refreshing.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Text(
                '${controller.refreshing.length} en consulta',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          AppIconButton(
            icon: Icons.sync,
            tooltip: 'Redescubrir perfiles',
            onPressed: controller.loading
                ? null
                : () => _guard(context, controller.rescanProfiles()),
          ),
          AppIconButton(
            icon: Icons.refresh,
            tooltip: 'Actualizar todas las cuentas',
            onPressed: controller.refreshing.isEmpty
                ? () => _guard(context, controller.refreshAll())
                : null,
          ),
          AppIconButton(
            icon: Icons.person_add_alt_1_outlined,
            tooltip: 'Crear perfil',
            onPressed: () => showCreateProfileDialog(context, controller),
          ),
          Container(
            width: 1,
            height: 18,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: theme.colorScheme.outline,
          ),
          AppIconButton(
            icon: Icons.settings_outlined,
            tooltip: 'Configuración',
            onPressed: () => showSettingsDialog(context, controller),
          ),
        ],
      ),
    );
  }
}

class _TopMenuItem extends StatefulWidget {
  const _TopMenuItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TopMenuItem> createState() => _TopMenuItemState();
}

class _TopMenuItemState extends State<_TopMenuItem> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(3),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: hovered
                ? theme.colorScheme.surfaceContainer
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: widget.selected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            widget.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.selected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
