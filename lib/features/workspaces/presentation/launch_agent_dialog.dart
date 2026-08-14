import 'package:flutter/material.dart';
import 'package:multi_cli_ai/app/dashboard_controller.dart';
import 'package:multi_cli_ai/core/database/app_database.dart';
import 'package:multi_cli_ai/core/widgets/app_primitives.dart';
import 'package:multi_cli_ai/features/accounts/domain/account_models.dart';
import 'package:multi_cli_ai/features/profiles/domain/profile_provider.dart';
import 'package:multi_cli_ai/features/profiles/presentation/profile_provider_icon.dart';
import 'package:multi_cli_ai/features/workspaces/presentation/workspace_dialogs.dart';

Future<void> showLaunchAgentDialog(
  BuildContext context,
  DashboardController controller,
) => showDialog<void>(
  context: context,
  builder: (context) => _LaunchAgentDialog(controller: controller),
);

class _LaunchAgentDialog extends StatefulWidget {
  const _LaunchAgentDialog({required this.controller});

  final DashboardController controller;

  @override
  State<_LaunchAgentDialog> createState() => _LaunchAgentDialogState();
}

class _LaunchAgentDialogState extends State<_LaunchAgentDialog> {
  final workspaceSearchController = TextEditingController();
  String? workspaceId;
  String? profileId;
  String workspaceQuery = '';
  bool launching = false;

  DashboardController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    workspaceId = controller.currentWorkspace?.id;
    final selected = controller.selectedAccount;
    if (selected != null && _canLaunch(selected)) {
      profileId = selected.profile.id;
    } else {
      for (final account in controller.accounts) {
        if (_canLaunch(account)) {
          profileId = account.profile.id;
          break;
        }
      }
    }
  }

  Workspace? get selectedWorkspace {
    for (final workspace in controller.workspaces) {
      if (workspace.id == workspaceId) return workspace;
    }
    return null;
  }

  AccountCardData? get selectedAccount {
    for (final account in controller.accounts) {
      if (account.profile.id == profileId) return account;
    }
    return null;
  }

  List<Workspace> get visibleWorkspaces {
    final query = workspaceQuery.trim().toLowerCase();
    if (query.isEmpty) return controller.workspaces;
    return controller.workspaces
        .where(
          (workspace) =>
              workspace.name.toLowerCase().contains(query) ||
              workspace.path.toLowerCase().contains(query),
        )
        .toList();
  }

  void _searchWorkspaces(String value) {
    setState(() {
      workspaceQuery = value;
      final selected = selectedWorkspace;
      if (selected != null && !visibleWorkspaces.contains(selected)) {
        workspaceId = null;
      }
    });
  }

  void _clearWorkspaceSearch() {
    workspaceSearchController.clear();
    setState(() => workspaceQuery = '');
  }

  Future<void> _addWorkspace() async {
    final workspace = await pickWorkspace(context, controller);
    if (workspace != null && mounted) {
      workspaceSearchController.clear();
      setState(() {
        workspaceQuery = '';
        workspaceId = workspace.id;
      });
    }
  }

  Future<void> _renameWorkspace(Workspace workspace) async {
    await renameWorkspace(context, controller, workspace);
    if (!mounted) return;
    final selected = selectedWorkspace;
    if (selected != null && !visibleWorkspaces.contains(selected)) {
      setState(() => workspaceId = null);
    }
  }

  Future<void> _removeWorkspace(Workspace workspace) async {
    await forgetWorkspace(context, controller, workspace);
    if (mounted && selectedWorkspace == null) setState(() {});
  }

  Future<void> _launch() async {
    final workspace = selectedWorkspace;
    final account = selectedAccount;
    if (workspace == null || account == null || launching) return;
    setState(() => launching = true);
    try {
      controller.selectAccount(account.profile.id);
      await controller.launchProfile(account, workingDirectory: workspace.path);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      setState(() => launching = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Bad state: ', '')),
        ),
      );
    }
  }

  @override
  void dispose() {
    workspaceSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = (MediaQuery.sizeOf(context).height * .62).clamp(
      380.0,
      520.0,
    );
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.terminal_rounded, size: 20),
          const SizedBox(width: 9),
          const Expanded(child: Text('Lanzar agente')),
          AppIconButton(
            icon: Icons.close,
            tooltip: 'Cerrar',
            onPressed: launching ? null : () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: 760,
        height: height,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final maxWorkspaceHeight = (height * .42).clamp(150.0, 220.0);
            final workspaceHeight = (50.0 + controller.workspaces.length * 60)
                .clamp(118.0, maxWorkspaceHeight);
            return Column(
              children: [
                SizedBox(
                  height: workspaceHeight,
                  child: _WorkspacePickerPanel(
                    workspaces: visibleWorkspaces,
                    hasWorkspaceHistory: controller.workspaces.isNotEmpty,
                    selectedId: workspaceId,
                    searchController: workspaceSearchController,
                    query: workspaceQuery,
                    onSelected: (value) =>
                        setState(() => workspaceId = value.id),
                    onSearch: _searchWorkspaces,
                    onClearSearch: _clearWorkspaceSearch,
                    onAdd: _addWorkspace,
                    onRename: _renameWorkspace,
                    onRemove: _removeWorkspace,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _AccountPickerPanel(
                    accounts: controller.accounts,
                    selectedId: profileId,
                    onSelected: (value) =>
                        setState(() => profileId = value.profile.id),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: launching ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed:
              selectedWorkspace == null || selectedAccount == null || launching
              ? null
              : _launch,
          icon: launching
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.terminal_rounded, size: 17),
          label: const Text('Lanzar agente'),
        ),
      ],
    );
  }
}

class _WorkspacePickerPanel extends StatelessWidget {
  const _WorkspacePickerPanel({
    required this.workspaces,
    required this.hasWorkspaceHistory,
    required this.selectedId,
    required this.searchController,
    required this.query,
    required this.onSelected,
    required this.onSearch,
    required this.onClearSearch,
    required this.onAdd,
    required this.onRename,
    required this.onRemove,
  });

  final List<Workspace> workspaces;
  final bool hasWorkspaceHistory;
  final String? selectedId;
  final TextEditingController searchController;
  final String query;
  final ValueChanged<Workspace> onSelected;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;
  final VoidCallback onAdd;
  final ValueChanged<Workspace> onRename;
  final ValueChanged<Workspace> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Row(
              children: [
                const SizedBox(width: 12),
                Text('Workspaces', style: theme.textTheme.titleMedium),
                const SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    key: const Key('launch-workspace-search'),
                    controller: searchController,
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre o ruta',
                      prefixIcon: const Icon(Icons.search, size: 15),
                      suffixIcon: query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Limpiar búsqueda',
                              onPressed: onClearSearch,
                              icon: const Icon(Icons.close, size: 15),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                AppIconButton(
                  icon: Icons.create_new_folder_outlined,
                  tooltip: 'Añadir workspace',
                  onPressed: onAdd,
                ),
                const SizedBox(width: 3),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outline),
          Expanded(
            child: workspaces.isEmpty
                ? Center(
                    child: Text(
                      hasWorkspaceHistory
                          ? 'Sin coincidencias'
                          : 'Sin workspaces guardados',
                    ),
                  )
                : ListView.separated(
                    key: const Key('launch-workspace-list'),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    itemCount: workspaces.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      final workspace = workspaces[index];
                      final selected = workspace.id == selectedId;
                      return _PickerRow(
                        selected: selected,
                        onTap: () => onSelected(workspace),
                        leading: Icon(
                          selected ? Icons.folder : Icons.folder_outlined,
                          size: 18,
                        ),
                        title: workspace.name,
                        subtitle: workspace.path,
                        action: SizedBox(
                          width: 30,
                          height: 30,
                          child: PopupMenuButton<String>(
                            tooltip: 'Administrar workspace',
                            icon: const Icon(Icons.more_vert, size: 16),
                            padding: EdgeInsets.zero,
                            position: PopupMenuPosition.under,
                            onSelected: (value) {
                              if (value == 'rename') {
                                onRename(workspace);
                              } else if (value == 'remove') {
                                onRemove(workspace);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'rename',
                                child: Text('Renombrar'),
                              ),
                              PopupMenuItem(
                                value: 'remove',
                                child: Text('Quitar del historial'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AccountPickerPanel extends StatelessWidget {
  const _AccountPickerPanel({
    required this.accounts,
    required this.selectedId,
    required this.onSelected,
  });

  final List<AccountCardData> accounts;
  final String? selectedId;
  final ValueChanged<AccountCardData> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Cuenta para lanzar',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  '${accounts.length}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outline),
          Expanded(
            child: accounts.isEmpty
                ? const Center(child: Text('Sin cuentas disponibles'))
                : LayoutBuilder(
                    builder: (context, constraints) => GridView.builder(
                      padding: const EdgeInsets.all(5),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth >= 620 ? 2 : 1,
                        mainAxisExtent: 60,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts[index];
                        final enabled = _canLaunch(account);
                        final selected = account.profile.id == selectedId;
                        final provider = profileProvider(
                          account.profile.toolKey,
                        );
                        return Opacity(
                          opacity: enabled ? 1 : .46,
                          child: _PickerRow(
                            selected: selected,
                            onTap: enabled ? () => onSelected(account) : null,
                            leading: ProfileProviderIcon(
                              toolKey: account.profile.toolKey,
                              size: 24,
                            ),
                            title: account.profile.displayName,
                            subtitle: _accountSubtitle(account, provider),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.selected,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final bool selected;
  final VoidCallback? onTap;
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Material(
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: .09)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 58,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Row(
                children: [
                  leading,
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (action != null) ...[action!, const SizedBox(width: 3)],
                  Icon(
                    selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 17,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool _canLaunch(AccountCardData account) {
  final provider = profileProvider(account.profile.toolKey);
  return account.profile.isAvailable &&
      (account.profile.hasAuthFile || !provider.supportsDeviceAuth);
}

String _accountSubtitle(AccountCardData account, ProfileProvider provider) {
  if (!account.profile.isAvailable) return 'Perfil no disponible';
  if (!account.profile.hasAuthFile && provider.supportsDeviceAuth) {
    return 'Cuenta sin vincular';
  }
  if (account.displayEmail.isNotEmpty) return account.displayEmail;
  return account.profile.commandName ?? provider.executable;
}
