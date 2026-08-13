import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_cli_ai/app/dashboard_controller.dart';
import 'package:multi_cli_ai/app/providers.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/formatters.dart';
import 'package:multi_cli_ai/core/widgets/app_primitives.dart';
import 'package:multi_cli_ai/features/accounts/domain/account_models.dart';
import 'package:multi_cli_ai/features/accounts/presentation/account_dialogs.dart';
import 'package:multi_cli_ai/features/profiles/domain/profile_provider.dart';
import 'package:multi_cli_ai/features/profiles/presentation/profile_provider_icon.dart';

export 'package:multi_cli_ai/features/accounts/presentation/account_dialogs.dart'
    show showCreateProfileDialog;

class AccountsView extends ConsumerWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dashboardControllerProvider);
    final ready = controller.accounts.where((item) {
      final provider = profileProvider(item.profile.toolKey);
      return provider.supportsUsage
          ? item.currentIsUsable
          : item.profile.isAvailable && item.profile.hasAuthFile;
    }).length;
    final attention = controller.accounts.where((item) {
      final provider = profileProvider(item.profile.toolKey);
      final state = item.currentState;
      return provider.supportsUsage
          ? state != null && !item.currentIsUsable
          : !item.profile.isAvailable;
    }).length;
    final unlinked = controller.accounts
        .where((item) => !item.profile.hasAuthFile)
        .length;
    final recent = controller.accounts
        .map((item) => item.currentCheck?.startedAt)
        .whereType<DateTime>()
        .fold<DateTime?>(null, (latest, value) {
          if (latest == null || value.isAfter(latest)) return value;
          return latest;
        });

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 17, 18, 0),
          sliver: SliverToBoxAdapter(
            child: SectionTitle(
              title: 'Perfiles de IA',
              subtitle: 'ChatGPT, Claude y sus perfiles aislados de multi-cli.',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${controller.accounts.length} perfiles',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () =>
                        showCreateProfileDialog(context, controller),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Nuevo perfil'),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
          sliver: SliverToBoxAdapter(
            child: _SummaryBand(
              total: controller.accounts.length,
              ready: ready,
              attention: attention,
              unlinked: unlinked,
              recent: recent,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          sliver: SliverToBoxAdapter(
            child: _AccountFilters(controller: controller),
          ),
        ),
        if (controller.visibleAccounts.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: controller.accounts.isEmpty
                  ? Icons.account_tree_outlined
                  : Icons.search_off,
              title: controller.accounts.isEmpty
                  ? 'No hay perfiles de IA'
                  : 'No hay coincidencias',
              message: controller.accounts.isEmpty
                  ? 'Crea una cuenta o redescubre el directorio de multi-cli.'
                  : 'Cambia la búsqueda o el filtro de estado.',
              action: controller.accounts.isEmpty
                  ? FilledButton.icon(
                      onPressed: () =>
                          showCreateProfileDialog(context, controller),
                      icon: const Icon(Icons.add),
                      label: const Text('Crear perfil'),
                    )
                  : null,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final columns = width >= 1120
                    ? 3
                    : width >= 720
                    ? 2
                    : 1;
                const spacing = 10.0;
                final extent = (width - spacing * (columns - 1)) / columns;
                final densityScale = controller.fontScale.clamp(.9, 1.2);
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    mainAxisExtent:
                        (controller.compactCards ? 213 : 246) * densityScale,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final account = controller.visibleAccounts[index];
                    return SizedBox(
                          width: extent,
                          child: AccountCard(
                            account: account,
                            refreshing: controller.refreshing.contains(
                              account.profile.id,
                            ),
                            compact: controller.compactCards,
                            controller: controller,
                          ),
                        )
                        .animate(delay: (index * 45).ms)
                        .fadeIn(duration: 260.ms)
                        .moveY(begin: 10, end: 0, curve: Curves.easeOutCubic);
                  }, childCount: controller.visibleAccounts.length),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _SummaryBand extends StatelessWidget {
  const _SummaryBand({
    required this.total,
    required this.ready,
    required this.attention,
    required this.unlinked,
    required this.recent,
  });

  final int total;
  final int ready;
  final int attention;
  final int unlinked;
  final DateTime? recent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border.symmetric(
          horizontal: BorderSide(color: theme.colorScheme.outline),
        ),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 8,
        children: [
          MetricItem(
            label: 'Perfiles',
            value: '$total',
            icon: Icons.layers_outlined,
          ),
          MetricItem(
            label: 'Listos',
            value: '$ready',
            icon: Icons.check_circle_outline,
            color: const Color(0xFF58E2AD),
          ),
          MetricItem(
            label: 'Atención',
            value: '$attention',
            icon: Icons.warning_amber_rounded,
            color: const Color(0xFFFFB84D),
          ),
          MetricItem(
            label: 'Sin vincular',
            value: '$unlinked',
            icon: Icons.link_off,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          MetricItem(
            label: 'Última consulta',
            value: relativeTime(recent),
            icon: Icons.schedule,
          ),
        ],
      ),
    );
  }
}

class _AccountFilters extends StatelessWidget {
  const _AccountFilters({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final search = SizedBox(
        width: constraints.maxWidth < 680 ? constraints.maxWidth : 280,
        child: TextField(
          onChanged: controller.setQuery,
          decoration: const InputDecoration(
            hintText: 'Buscar nombre, perfil o correo',
            prefixIcon: Icon(Icons.search, size: 15),
          ),
        ),
      );
      final filters = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FilterItem(
            label: 'Todos',
            selected: controller.statusFilter == 'all',
            onTap: () => controller.setStatusFilter('all'),
          ),
          _FilterItem(
            label: 'Listos',
            selected: controller.statusFilter == 'ready',
            onTap: () => controller.setStatusFilter('ready'),
          ),
          _FilterItem(
            label: 'Atención',
            selected: controller.statusFilter == 'attention',
            onTap: () => controller.setStatusFilter('attention'),
          ),
          _FilterItem(
            label: 'Sin vincular',
            selected: controller.statusFilter == 'unlinked',
            onTap: () => controller.setStatusFilter('unlinked'),
          ),
        ],
      );
      if (constraints.maxWidth < 680) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            search,
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: filters,
            ),
          ],
        );
      }
      return Row(children: [search, const Spacer(), filters]);
    },
  );
}

class _FilterItem extends StatelessWidget {
  const _FilterItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: .08)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: selected ? theme.colorScheme.primary : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: selected
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class AccountCard extends StatefulWidget {
  const AccountCard({
    required this.account,
    required this.refreshing,
    required this.compact,
    required this.controller,
    super.key,
  });

  final AccountCardData account;
  final bool refreshing;
  final bool compact;
  final DashboardController controller;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  bool hovered = false;

  Future<void> _guard(Future<void> future) async {
    try {
      await future;
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Bad state: ', '')),
        ),
      );
    }
  }

  Future<void> _launchAt(
    AccountCardData account,
    _LaunchDestination destination,
  ) async {
    final home = widget.controller.userHomeDirectory;
    final directory = switch (destination) {
      _LaunchDestination.home => home,
      _LaunchDestination.choose => await getDirectoryPath(
        initialDirectory: home,
        confirmButtonText: 'Abrir aquí',
        canCreateDirectories: true,
      ),
    };
    if (directory == null) return;
    await widget.controller.launchProfile(account, workingDirectory: directory);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = widget.account;
    final provider = profileProvider(account.profile.toolKey);
    final stateColor = _stateColor(context, account);
    final windows = account.visibleWindows
        .take(widget.compact ? 1 : 2)
        .toList();
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: hovered
              ? theme.colorScheme.surfaceContainer
              : theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: hovered
                ? theme.colorScheme.primary.withValues(alpha: .42)
                : theme.colorScheme.outline,
          ),
          boxShadow: hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        padding: const EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusDot(color: stateColor, size: 7),
                const SizedBox(width: 8),
                ProfileProviderIcon(toolKey: account.profile.toolKey, size: 28),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              account.profile.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                          if (account.profile.isFavorite) ...[
                            const SizedBox(width: 5),
                            Icon(
                              Icons.star,
                              size: 13,
                              color: theme.colorScheme.tertiary,
                            ),
                          ],
                          const SizedBox(width: 7),
                          _StateBadge(account: account, color: stateColor),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Tooltip(
                        message:
                            account.profile.commandName ?? provider.executable,
                        child: Row(
                          children: [
                            Text(
                              provider.displayName,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '·',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                account.profile.commandName ??
                                    provider.executable,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppIconButton(
                  icon: Icons.edit_outlined,
                  tooltip: 'Editar perfil',
                  onPressed: () => showEditAccountDialog(
                    context,
                    widget.controller,
                    account,
                  ),
                ),
                const SizedBox(width: 2),
                SizedBox(
                  width: 38,
                  height: 38,
                  child: PopupMenuButton<String>(
                    tooltip: 'Más acciones',
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    position: PopupMenuPosition.under,
                    menuPadding: const EdgeInsets.symmetric(vertical: 4),
                    constraints: const BoxConstraints.tightFor(width: 196),
                    onSelected: (value) {
                      if (value == 'rename') {
                        showRenameProfileDialog(
                          context,
                          widget.controller,
                          account,
                        );
                      } else if (value == 'delete') {
                        showDeleteProfileDialog(
                          context,
                          widget.controller,
                          account,
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'rename',
                        enabled: account.profile.profileSource == 'multicli',
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: const Row(
                          children: [
                            Icon(Icons.drive_file_rename_outline, size: 15),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Renombrar alias físico',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        enabled: account.profile.profileSource == 'multicli',
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 15,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Eliminar perfil',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!account.currentIsUsable) ...[
              const SizedBox(height: 5),
              _StateLine(account: account, color: stateColor, showBadge: false),
            ],
            const SizedBox(height: 7),
            Row(
              children: [
                Expanded(
                  child: _InlineInfo(
                    icon: Icons.workspace_premium_outlined,
                    value: account.displayPlan.isEmpty
                        ? 'No detectado'
                        : account.displayPlan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InlineInfo(
                    icon: Icons.alternate_email,
                    value: account.displayEmail.isEmpty
                        ? 'Sin correo observado'
                        : account.displayEmail,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (windows.isEmpty)
              _NoUsageData(account: account)
            else
              ...windows.map((window) => _QuotaBar(window: window)),
            const Spacer(),
            Row(
              children: [
                Expanded(child: _BillingLine(account: account)),
                if (account.profile.hasAuthFile || !provider.supportsDeviceAuth)
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: PopupMenuButton<_LaunchDestination>(
                      tooltip: 'Abrir ${provider.productName}',
                      icon: Icon(
                        Icons.terminal_rounded,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      position: PopupMenuPosition.under,
                      menuPadding: const EdgeInsets.symmetric(vertical: 4),
                      constraints: const BoxConstraints.tightFor(width: 184),
                      onSelected: (destination) =>
                          unawaited(_guard(_launchAt(account, destination))),
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: _LaunchDestination.home,
                          height: 38,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Icon(Icons.home_outlined, size: 15),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Abrir en Inicio',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: _LaunchDestination.choose,
                          height: 38,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Icon(Icons.folder_open_outlined, size: 15),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Elegir carpeta…',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  AppIconButton(
                    icon: Icons.link,
                    tooltip: 'Vincular cuenta',
                    onPressed: () => showDeviceAuthDialog(
                      context,
                      widget.controller,
                      account,
                    ),
                  ),
                if (widget.refreshing && provider.supportsUsage)
                  const SizedBox(
                    width: 38,
                    height: 38,
                    child: Center(
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
                    ),
                  )
                else if (provider.supportsUsage)
                  AppIconButton(
                    icon: Icons.refresh,
                    tooltip: 'Consultar sólo esta cuenta',
                    onPressed: () =>
                        _guard(widget.controller.refreshOne(account)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _LaunchDestination { home, choose }

class _StateLine extends StatelessWidget {
  const _StateLine({
    required this.account,
    required this.color,
    this.showBadge = true,
  });

  final AccountCardData account;
  final Color color;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = account.currentCheck;
    return Row(
      children: [
        if (showBadge) ...[
          _StateBadge(account: account, color: color),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            _stateDetail(account),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          relativeTime(
            current?.startedAt ?? account.lastSuccessfulCheck?.startedAt,
          ),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StateBadge extends StatelessWidget {
  const _StateBadge({required this.account, required this.color});

  final AccountCardData account;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .11),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: color.withValues(alpha: .3)),
    ),
    child: Text(
      _stateLabel(account),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
    ),
  );
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 13, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _NoUsageData extends StatelessWidget {
  const _NoUsageData({required this.account});

  final AccountCardData account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = profileProvider(account.profile.toolKey);
    return Container(
      height: 36,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .42),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        !provider.supportsUsage
            ? 'Cuotas no disponibles para ${provider.productName}.'
            : account.currentCheck == null
            ? 'Actualiza para consultar límites oficiales.'
            : 'La fuente no devolvió ventanas de cuota.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _QuotaBar extends StatelessWidget {
  const _QuotaBar({required this.window});

  final QuotaWindow window;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final used = window.usedPercent?.clamp(0, 100).toDouble();
    final remaining = used == null ? null : 100 - used;
    final color = remaining == null
        ? theme.colorScheme.onSurfaceVariant
        : remaining <= 10
        ? theme.colorScheme.error
        : remaining <= 25
        ? theme.colorScheme.tertiary
        : theme.colorScheme.primary;
    final title = formatQuotaWindowLabel(
      window.windowDurationMinutes,
      window.windowType,
    );
    final reset = window.resetsAt == null
        ? null
        : 'Reinicia en ${formatTimeRemaining(window.resetsAt!)}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (reset != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 1,
                        height: 12,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          reset,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                remaining == null
                    ? 'Sin porcentaje'
                    : '${remaining.toStringAsFixed(0)}% disponible',
                maxLines: 1,
                textAlign: TextAlign.right,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0,
              end: remaining == null ? 0 : remaining / 100,
            ),
            duration: const Duration(milliseconds: 620),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
              color: color,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _BillingLine extends StatelessWidget {
  const _BillingLine({required this.account});

  final AccountCardData account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metadata = account.metadata;
    final shares = account.costShares;
    final pending = shares.where((item) => item.paymentStatus != 'paid').length;
    return Row(
      children: [
        Icon(
          Icons.event_repeat,
          size: 13,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            metadata?.nextRenewalOn == null
                ? 'Renovación no registrada'
                : 'Renueva ${formatDate(metadata!.nextRenewalOn)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        if (shares.isNotEmpty)
          Text(
            pending == 0
                ? '${shares.length} pagos al día'
                : '$pending pagos pendientes',
            style: theme.textTheme.labelSmall?.copyWith(
              color: pending == 0
                  ? const Color(0xFF58E2AD)
                  : theme.colorScheme.tertiary,
            ),
          ),
      ],
    );
  }
}

Color _stateColor(BuildContext context, AccountCardData account) {
  final provider = profileProvider(account.profile.toolKey);
  if (!account.profile.isAvailable) return Theme.of(context).colorScheme.error;
  if (!account.profile.hasAuthFile) {
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }
  if (!provider.supportsUsage) return const Color(0xFF58E2AD);
  return switch (account.currentState) {
    UsageCheckState.success => const Color(0xFF58E2AD),
    UsageCheckState.partial => Theme.of(context).colorScheme.tertiary,
    null => Theme.of(context).colorScheme.primary,
    _ => Theme.of(context).colorScheme.error,
  };
}

String _stateLabel(AccountCardData account) {
  final provider = profileProvider(account.profile.toolKey);
  if (!account.profile.isAvailable) return 'NO DISPONIBLE';
  if (!account.profile.hasAuthFile) return 'SIN VINCULAR';
  if (!provider.supportsUsage) return 'LISTA';
  return switch (account.currentState) {
    UsageCheckState.success => 'ACTIVA',
    UsageCheckState.partial => 'PARCIAL',
    UsageCheckState.timeout => 'TIEMPO AGOTADO',
    UsageCheckState.authRequired => 'REQUIERE ACCESO',
    UsageCheckState.toolMissing => 'CLI AUSENTE',
    UsageCheckState.profileMissing => 'PERFIL AUSENTE',
    UsageCheckState.unavailable => 'NO DISPONIBLE',
    UsageCheckState.error => 'ERROR',
    null => 'SIN CONSULTAR',
  };
}

String _stateDetail(AccountCardData account) {
  final provider = profileProvider(account.profile.toolKey);
  final check = account.currentCheck;
  if (!account.profile.isAvailable) return 'La carpeta del perfil ya no existe';
  if (!account.profile.hasAuthFile) {
    return 'Credencial administrada por multi-cli';
  }
  if (!provider.supportsUsage) {
    return '${provider.productName} disponible para abrir';
  }
  if (check == null) return 'Aún no se consultó el app-server';
  if (account.currentIsUsable) {
    final count = account.visibleWindows.length;
    return '$count ${count == 1 ? 'ventana oficial' : 'ventanas oficiales'}';
  }
  final lastGood = account.lastSuccessfulCheck;
  if (lastGood != null) {
    return 'Último dato válido ${relativeTime(lastGood.startedAt)}';
  }
  return check.errorMessage ?? 'No se obtuvo una respuesta válida';
}
