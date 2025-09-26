import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/services/random_tools_manager.dart';
import 'package:random_please/widgets/generic/section_item.dart';
import 'package:random_please/widgets/generic/section_list_view.dart';
import 'package:random_please/widgets/generic/section_grid_view.dart';

class RandomToolsScreen extends StatelessWidget {
  final bool isEmbedded;
  final Function(Widget, String, {String? parentCategory, IconData? icon})?
      onToolSelected;

  const RandomToolsScreen({
    super.key,
    this.isEmbedded = false,
    this.onToolSelected,
  });

  Future<List<SectionItem>> _buildSections(AppLocalizations loc) async {
    final tools = await RandomToolsManager.getOrderedTools(loc);
    return RandomToolsManager.toolsToSectionItems(tools);
  }

  void _onSectionSelected(String sectionId, List<SectionItem> sections,
      AppLocalizations loc, BuildContext context) {
    final section = sections.firstWhere((s) => s.id == sectionId);

    if (isEmbedded && onToolSelected != null) {
      // Desktop mode: sử dụng callback để hiển thị công cụ trong main widget
      onToolSelected!(section.content, section.title,
          parentCategory: 'RandomToolsScreen', icon: section.icon);
    } else {
      // Mobile mode: navigation stack bình thường
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(title: Text(section.title)),
                  body: section.content,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800;

    return FutureBuilder<List<SectionItem>>(
      future: _buildSections(loc),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final sections = snapshot.data ?? [];

        Widget content;
        if (isDesktop) {
          // Desktop: Use AutoScaleSectionGridView
          content = AutoScaleSectionGridView(
            sections: sections,
            onSectionSelected: (sectionId) =>
                _onSectionSelected(sectionId, sections, loc, context),
            minCellWidth: 400,
            fixedCellHeight: 100,
            decorator: const SectionGridDecorator(
              padding: EdgeInsets.all(16),
            ),
          );
        } else {
          // Mobile: Use SectionListView
          content = SectionListView(
            sections: sections,
            onSectionSelected: (sectionId) =>
                _onSectionSelected(sectionId, sections, loc, context),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          );
        }

        return content;
      },
    );
  }
}
