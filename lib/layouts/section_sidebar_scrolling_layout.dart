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
    if (widget.isEmbedded) {
      return _buildDesktopContent();
    } else {
      return Scaffold(
        body: SafeArea(child: _buildDesktopContent()),
      );
    }
  }

  Widget _buildDesktopContent() {
    return Row(
      children: [
        // Sidebar (30% width) - Removed header/appbar
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.sections.length,
              itemBuilder: (context, index) {
                final section = widget.sections[index];
                final isSelected = section.id == _currentSectionId;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.7)
                        : null,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : (section.iconColor ?? Colors.grey)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        section.icon,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : section.iconColor ?? Colors.grey,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      section.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : null,
                          ),
                    ),
                    subtitle: section.subtitle != null
                        ? Text(
                            section.subtitle!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer
                                              .withValues(alpha: 0.7)
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                    ),
                          )
                        : null,
                    onTap: () => _scrollToSection(section.id),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                  ),
                );
              },
            ),
          ),
        ),

        // Content area (70% width) - Updated styling for full width sections
        Expanded(
          flex: 7,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
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
                                                .onPrimaryContainer
                                                .withValues(alpha: 0.8),
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
                        padding: const EdgeInsets.all(24),
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
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              title: Text(widget.title ?? 'Sections'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                ),
              ],
            ),
      endDrawer: _buildMobileDrawer(),
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

  Widget _buildMobileDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          if (widget.title != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.sections.length,
              itemBuilder: (context, index) {
                final section = widget.sections[index];
                final isSelected = section.id == _currentSectionId;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.7)
                        : null,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : (section.iconColor ?? Colors.grey)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        section.icon,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : section.iconColor ?? Colors.grey,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      section.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : null,
                          ),
                    ),
                    subtitle: section.subtitle != null
                        ? Text(
                            section.subtitle!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer
                                              .withValues(alpha: 0.7)
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                    ),
                          )
                        : null,
                    onTap: () {
                      Navigator.of(context).pop(); // Close drawer
                      _scrollToSection(section.id);
                    },
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
