import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/services/random_tools_manager.dart';
import 'package:random_please/services/tool_order_service.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  String _selectedTool = ''; // Will be set to first tool when loaded
  List<ToolItem> _tools = [];
  bool _loading = true;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    // Don't load tools here - wait for didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _hasInitialized = true;
      _loadTools();
    }
  }

  Future<void> _loadTools() async {
    final loc = AppLocalizations.of(context)!;
    final tools = await RandomToolsManager.getOrderedTools(loc);

    if (mounted) {
      setState(() {
        _tools = tools;
        _loading = false;
        // Always set first tool as selected
        if (tools.isNotEmpty) {
          _selectedTool = tools.first.id;
        }
      });
    }
  }

  /// Reload tools when order changes
  Future<void> reloadToolOrder() async {
    setState(() {
      _hasInitialized = false;
      _loading = true;
    });
    await _loadTools();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Row(
      children: [
        // Left Sidebar - 20% width
        Container(
          width: max(min(width * 0.2, 350), 200),
          padding: const EdgeInsets.only(top: 16),
          child: ListView(
            children: _buildToolList(),
          ),
        ),
        // Right Content Area - 75% width
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: _buildSelectedToolWidget(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildToolList() {
    return _tools.map((tool) => _buildToolTile(tool)).toList();
  }

  Widget _buildToolTile(ToolItem tool) {
    final isSelected = _selectedTool == tool.id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: tool.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            tool.icon,
            color: tool.color,
            size: 20,
          ),
        ),
        title: Text(
          tool.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : null,
              ),
        ),
        subtitle: Text(
          tool.subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withValues(alpha: 0.7)
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
              ),
        ),
        onTap: () {
          setState(() {
            _selectedTool = tool.id;
          });
        },
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _buildSelectedToolWidget() {
    final selectedTool = RandomToolsManager.findToolById(_selectedTool, _tools);
    if (selectedTool != null) {
      return selectedTool.screenBuilder(true);
    }

    // Fallback if no tool is found
    if (_tools.isNotEmpty) {
      return _tools.first.screenBuilder(true);
    }

    return const Center(child: Text('No tools available'));
  }
}
