import 'package:flutter/material.dart';
import 'package:multi_cli_ai/app/dashboard_controller.dart';
import 'package:multi_cli_ai/core/theme/app_theme.dart';

Future<void> showSettingsDialog(
  BuildContext context,
  DashboardController controller,
) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (_) => _SettingsDialog(controller: controller),
);

class _SettingsDialog extends StatefulWidget {
  const _SettingsDialog({required this.controller});

  final DashboardController controller;

  @override
  State<_SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<_SettingsDialog> {
  late String theme = widget.controller.themePreference;
  late String accent = widget.controller.accentPreference;
  late double fontScale = widget.controller.fontScale;
  late String fontFamily = widget.controller.fontFamilyPreference;
  late double concurrency = widget.controller.concurrency.toDouble();
  late double timeout = widget.controller.timeoutSeconds.toDouble();
  late bool compact = widget.controller.compactCards;
  final root = TextEditingController();
  bool loadingRoot = true;
  bool saving = false;
  String? error;

  @override
  void initState() {
    super.initState();
    widget.controller.database.setting('profiles_root_path').then((value) {
      if (!mounted) return;
      root.text = value ?? '';
      setState(() => loadingRoot = false);
    });
  }

  @override
  void dispose() {
    root.dispose();
    super.dispose();
  }

  Future<void> save() async {
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.controller.saveSettings(
        theme: theme,
        accent: accent,
        fontScale: fontScale,
        fontFamily: fontFamily,
        concurrency: concurrency.round(),
        timeoutSeconds: timeout.round(),
        compactCards: compact,
        profilesRoot: root.text,
      );
      if (mounted) Navigator.pop(context);
    } catch (exception) {
      if (mounted) {
        setState(() {
          error = exception.toString().replaceFirst('Bad state: ', '');
          saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Configuración'),
      content: SizedBox(
        width: 620,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Label('APARIENCIA'),
              const SizedBox(height: 9),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: theme,
                      decoration: const InputDecoration(labelText: 'Tema'),
                      items: const [
                        DropdownMenuItem(value: 'dark', child: Text('Oscuro')),
                        DropdownMenuItem(value: 'light', child: Text('Claro')),
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('Sistema'),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => theme = value ?? 'dark'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: fontFamily,
                      decoration: const InputDecoration(
                        labelText: 'Tipografía',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('Sistema'),
                        ),
                        DropdownMenuItem(
                          value: 'ubuntu',
                          child: Text('Ubuntu'),
                        ),
                        DropdownMenuItem(
                          value: 'noto',
                          child: Text('Noto Sans'),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => fontFamily = value ?? 'system'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(child: Text('Tamaño del texto')),
                  Text('${(fontScale * 100).round()}%'),
                ],
              ),
              Slider(
                value: fontScale,
                min: .8,
                max: 1.2,
                divisions: 8,
                label: '${(fontScale * 100).round()}%',
                onChanged: (value) => setState(() => fontScale = value),
              ),
              Row(
                children: [
                  const Expanded(child: Text('Color de énfasis')),
                  _AccentButton(
                    name: 'cyan',
                    color: AppTheme.cyan,
                    selected: accent == 'cyan',
                    onTap: () => setState(() => accent = 'cyan'),
                  ),
                  const SizedBox(width: 8),
                  _AccentButton(
                    name: 'mint',
                    color: AppTheme.mint,
                    selected: accent == 'mint',
                    onTap: () => setState(() => accent = 'mint'),
                  ),
                  const SizedBox(width: 8),
                  _AccentButton(
                    name: 'amber',
                    color: AppTheme.amber,
                    selected: accent == 'amber',
                    onTap: () => setState(() => accent = 'amber'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: compact,
                onChanged: (value) => setState(() => compact = value),
                title: const Text('Tarjetas compactas'),
                subtitle: const Text('Muestra menos ventanas por cuenta.'),
              ),
              const Divider(height: 32),
              _Label('CONSULTAS'),
              const SizedBox(height: 9),
              Row(
                children: [
                  const Expanded(child: Text('Cuentas en paralelo')),
                  Text('${concurrency.round()}'),
                ],
              ),
              Slider(
                value: concurrency,
                min: 1,
                max: 6,
                divisions: 5,
                label: '${concurrency.round()}',
                onChanged: (value) => setState(() => concurrency = value),
              ),
              Row(
                children: [
                  const Expanded(child: Text('Tiempo máximo por petición')),
                  Text('${timeout.round()} s'),
                ],
              ),
              Slider(
                value: timeout,
                min: 5,
                max: 60,
                divisions: 11,
                label: '${timeout.round()} s',
                onChanged: (value) => setState(() => timeout = value),
              ),
              Text(
                'La concurrencia está acotada para no abrir demasiados app-server '
                'al mismo tiempo. Cada cuenta conserva su propio límite y error.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
              ),
              const Divider(height: 32),
              _Label('MULTI-CLI'),
              const SizedBox(height: 9),
              TextField(
                controller: root,
                enabled: !loadingRoot,
                decoration: const InputDecoration(
                  labelText: 'Directorio de perfiles',
                  hintText: '~/MultiCliProfiles',
                  prefixIcon: Icon(Icons.folder_outlined, size: 18),
                  helperText: 'Vacío usa MULTICLI_HOME o ~/MultiCliProfiles.',
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(error!, style: TextStyle(color: colors.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: saving ? null : save,
          icon: saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined, size: 18),
          label: const Text('Guardar'),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.labelSmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      letterSpacing: 0,
    ),
  );
}

class _AccentButton extends StatelessWidget {
  const _AccentButton({
    required this.name,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: switch (name) {
      'mint' => 'Menta',
      'amber' => 'Ámbar',
      _ => 'Cian',
    },
    child: InkResponse(
      onTap: onTap,
      radius: 22,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.onSurface
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 14, color: Color(0xFF051014))
            : null,
      ),
    ),
  );
}
