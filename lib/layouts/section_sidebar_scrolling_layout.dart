import 'package:flutter/material.dart';
import 'package:random_please/widgets/generic/section_list_view.dart';
import 'package:random_please/widgets/generic/section_item.dart';

// New mobile section selection screen
class MobileSectionSelectionScreen extends StatelessWidget {
  final String? title;
  final List<SectionItem> sections;
  final Function(String) onSectionSelected;

  const MobileSectionSelectionScreen({
    super.key,
    this.title,
    required this.sections,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: SectionListView(
          sections: sections,
          onSectionSelected: onSectionSelected,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}

class SectionSidebarScrollingLayout extends StatefulWidget {
  final String? title;
  final List<SectionItem> sections;
  final bool isEmbedded;
  final String? selectedSectionId;
  final Function(String)? onSectionChanged;

  const SectionSidebarScrollingLayout({
    super.key,
    this.title,
    required this.sections,
    this.isEmbedded = false,
    this.selectedSectionId,
    this.onSectionChanged,
  });

  @override
  State<SectionSidebarScrollingLayout> createState() =>
      _SectionSidebarScrollingLayoutState();
}

class _SectionSidebarScrollingLayoutState
    extends State<SectionSidebarScrollingLayout> {
  late ScrollController _scrollController;
  String? _currentSectionId;
  final Map<String, GlobalKey> _sectionKeys = {};
  bool _isScrolling = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _currentSectionId = widget.selectedSectionId ?? widget.sections.first.id;

    // Create keys for each section
    for (final section in widget.sections) {
      _sectionKeys[section.id] = GlobalKey();
    }

    // Listen to scroll changes
    _scrollController.addListener(_onScroll);

    // Auto-scroll to the selected section after the frame is built
    if (widget.selectedSectionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollToSection(widget.selectedSectionId!);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isScrolling) return;

    // Find which section is currently visible
    for (final section in widget.sections) {
      final key = _sectionKeys[section.id];
      if (key?.currentContext != null) {
        final renderBox = key!.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          final sectionTop = position.dy;
          final sectionHeight = renderBox.size.height;

          // Consider a section "current" if its top is within the viewport
          if (sectionTop <= 200 && sectionTop + sectionHeight > 100) {
            if (section.id != _currentSectionId) {
              setState(() {
                _currentSectionId = section.id;
              });
              widget.onSectionChanged?.call(section.id);
            }
            break;
          }
        }
      }
    }
  }

  void _scrollToSection(String sectionId) {
    final key = _sectionKeys[sectionId];
    if (key?.currentContext != null) {
      _isScrolling = true;
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ).then((_) {
        Future.delayed(const Duration(milliseconds: 600), () {
          _isScrolling = false;
        });
      });

      setState(() {
        _currentSectionId = sectionId;
      });
      widget.onSectionChanged?.call(sectionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1000;

    if (isDesktop) {
      return _buildDesktopLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.sections.map((section) {
              return Container(
                key: _sectionKeys[section.id],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header with full width background - Made smaller
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.4),
                      ),
                      child: Row(
                        children: [
                          // Icon with background border like sidebar
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: section.iconColor ??
                                  Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              section.icon,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  section.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                if (section.subtitle != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    section.subtitle!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Section content with full width background
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: Theme.of(context).colorScheme.surface,
                      child: section.content,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.sections.map((section) {
              return Container(
                key: _sectionKeys[section.id],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header with full width background - Made smaller
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.4),
                      ),
                      child: Row(
                        children: [
                          // Icon with background border like sidebar
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: section.iconColor ??
                                  Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              section.icon,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  section.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                if (section.subtitle != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    section.subtitle!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Section content with full width background
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: Theme.of(context).colorScheme.surface,
                      child: section.content,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
