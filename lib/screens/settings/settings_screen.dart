import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/variables_utils.dart';
import 'package:random_please/view_models/settings_view_model.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;
  final bool showCacheSection;

  const SettingsScreen(
      {super.key, this.isEmbedded = false, this.showCacheSection = true});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late SettingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SettingsViewModel(ref);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _viewModel.initialize();
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _clearCache() async {
    final confirmed = await _showConfirmDialog();
    if (confirmed != true) return;

    try {
      final success = await _viewModel.clearCache();
      if (success && mounted) {
        SnackBarUtils.showTyped(
          context,
          AppLocalizations.of(context)!.clearCache,
          SnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(
          context,
          'Error: $e',
          SnackBarType.error,
        );
      }
    }
  }

  void _onThemeChanged(ThemeMode? mode) {
    if (mode != null) {
      _viewModel.setThemeMode(mode);
    }
  }

  void _onLanguageChanged(String? lang) {
    if (lang != null) {
      _viewModel.setLocale(Locale(lang));
    }
  }

  Future<bool?> _showConfirmDialog() async {
    final loc = AppLocalizations.of(context)!;
    final textController = TextEditingController();

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(loc.clearAllCache),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.confirmClearAllCache),
              const SizedBox(height: 16),
              Text(
                loc.typeConfirmToProceed,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'confirm',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(loc.cancel),
            ),
            FilledButton(
              onPressed: textController.text.toLowerCase() == 'confirm'
                  ? () => Navigator.of(context).pop(true)
                  : null,
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text(loc.clearAllCache),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations loc) {
    final settings = ref.watch(settingsProvider);

    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        if (!mounted) {
          return const SizedBox.shrink();
        }

        if (_viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Widget themeColumn = Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.palette,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      loc.theme,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _OptionTile(
                  label: loc.system,
                  selected: settings.themeMode == ThemeMode.system,
                  onTap: () => _onThemeChanged(ThemeMode.system),
                ),
                _OptionTile(
                  label: loc.light,
                  selected: settings.themeMode == ThemeMode.light,
                  onTap: () => _onThemeChanged(ThemeMode.light),
                ),
                _OptionTile(
                  label: loc.dark,
                  selected: settings.themeMode == ThemeMode.dark,
                  onTap: () => _onThemeChanged(ThemeMode.dark),
                ),
              ],
            ),
          ),
        );

        Widget languageColumn = Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      loc.language,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _OptionTile(
                  label: '🇬🇧 ${loc.english}',
                  selected: settings.locale.languageCode == 'en',
                  onTap: () => _onLanguageChanged('en'),
                ),
                _OptionTile(
                  label: '🇻🇳 ${loc.vietnamese}',
                  selected: settings.locale.languageCode == 'vi',
                  onTap: () => _onLanguageChanged('vi'),
                ),
              ],
            ),
          ),
        );

        final List<Widget> items = [
          if (isTabletContext(context))
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: themeColumn),
                const SizedBox(width: 24),
                Expanded(child: languageColumn),
              ],
            )
          else ...[
            themeColumn,
            const SizedBox(height: 24),
            languageColumn,
          ],
        ];

        if (widget.showCacheSection) {
          items.addAll([
            const SizedBox(height: 24),
            Text('${loc.cache}: ${_viewModel.cacheInfo}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: _viewModel.clearing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.delete),
                    label: Text(loc.clearCache),
                    onPressed: _viewModel.clearing ? null : _clearCache,
                  ),
                ),
              ],
            ),
          ]);
        }

        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        );

        if (widget.isEmbedded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: content,
          );
        } else {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [content],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (widget.isEmbedded) {
      return _buildContent(loc);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
      ),
      body: _buildContent(loc),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
