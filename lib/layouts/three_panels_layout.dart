import 'package:flutter/material.dart';

class ThreePanelLayout extends StatefulWidget {
  final Widget mainPanel;
  final Widget topRightPanel;
  final Widget? bottomRightPanel;
  final String? mainPanelTitle;
  final String? topRightPanelTitle;
  final String? bottomRightPanelTitle;
  final bool isEmbedded;
  final String? title;
  final bool hideBottomPanel;
  final List<Widget>? mainPanelActions;
  final List<Widget>? topRightPanelActions;
  final List<Widget>? bottomRightPanelActions;

  const ThreePanelLayout({
    super.key,
    required this.mainPanel,
    required this.topRightPanel,
    this.bottomRightPanel,
    this.mainPanelTitle,
    this.topRightPanelTitle,
    this.bottomRightPanelTitle,
    this.isEmbedded = false,
    this.title,
    this.hideBottomPanel = false,
    this.mainPanelActions,
    this.topRightPanelActions,
    this.bottomRightPanelActions,
  });

  @override
  State<ThreePanelLayout> createState() => _ThreePanelLayoutState();
}

class _ThreePanelLayoutState extends State<ThreePanelLayout>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // Calculate initial tab count
    final hasTopRightPanel = widget.topRightPanelTitle != null;
    final hasBottomRightPanel =
        !widget.hideBottomPanel && widget.bottomRightPanel != null;
    final tabCount =
        1 + (hasTopRightPanel ? 1 : 0) + (hasBottomRightPanel ? 1 : 0);

    _tabController = TabController(length: tabCount, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(ThreePanelLayout oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Calculate old and new tab counts
    final oldHasTopRightPanel = oldWidget.topRightPanelTitle != null;
    final oldHasBottomRightPanel =
        !oldWidget.hideBottomPanel && oldWidget.bottomRightPanel != null;
    final oldTabCount =
        1 + (oldHasTopRightPanel ? 1 : 0) + (oldHasBottomRightPanel ? 1 : 0);

    final newHasTopRightPanel = widget.topRightPanelTitle != null;
    final newHasBottomRightPanel =
        !widget.hideBottomPanel && widget.bottomRightPanel != null;
    final newTabCount =
        1 + (newHasTopRightPanel ? 1 : 0) + (newHasBottomRightPanel ? 1 : 0);

    if (oldTabCount != newTabCount) {
      _tabController.dispose();
      _tabController = TabController(length: newTabCount, vsync: this);
      _tabController.addListener(() {
        setState(() {});
      });
      // Reset to first tab
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    final layoutContent = _buildLayoutContent(isDesktop);

    // Wrap with Scaffold to provide Material ancestor and handle back button
    if (widget.isEmbedded) {
      // If embedded, don't wrap with Scaffold (parent should provide it)
      return layoutContent;
    } else {
      // Standalone layout - wrap with Scaffold and SafeArea
      return Scaffold(
        body: SafeArea(child: layoutContent),
      );
    }
  }

  Widget _buildLayoutContent(bool isDesktop) {
    // Wrap the content with Material to ensure Material ancestor for InkWell widgets
    return Material(
      child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildPanelHeader({
    required String title,
    required IconData icon,
    required Color iconColor,
    List<Widget>? actions,
    bool isMainPanel = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 65,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: isMainPanel ? 24 : 20,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: isMainPanel
                  ? Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      )
                  : Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
            ),
          ),
          if (actions != null) ...actions,
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    // Check if we should show right panels
    final hasTopRightPanel = widget.topRightPanelTitle != null;
    final hasBottomRightPanel =
        !widget.hideBottomPanel && widget.bottomRightPanel != null;
    final hasAnyRightPanel = hasTopRightPanel || hasBottomRightPanel;

    if (!hasAnyRightPanel) {
      // No right panels - center the main panel
      return Row(
        children: [
          // Left spacer: 20%
          const Expanded(flex: 20, child: SizedBox()),
          // Main panel: 60% centered
          Expanded(
            flex: 60,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.mainPanelTitle != null)
                    _buildPanelHeader(
                      title: widget.mainPanelTitle!,
                      icon: Icons.show_chart,
                      iconColor: Theme.of(context).colorScheme.primary,
                      actions: widget.mainPanelActions,
                      isMainPanel: true,
                    ),
                  Expanded(child: widget.mainPanel),
                ],
              ),
            ),
          ),
          // Right spacer: 20%
          const Expanded(flex: 20, child: SizedBox()),
        ],
      );
    }

    return Row(
      children: [
        // Main panel - 60% width
        Expanded(
          flex: 60,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.mainPanelTitle != null)
                  _buildPanelHeader(
                    title: widget.mainPanelTitle!,
                    icon: Icons.show_chart,
                    iconColor: Theme.of(context).colorScheme.primary,
                    actions: widget.mainPanelActions,
                    isMainPanel: true,
                  ),
                Expanded(child: widget.mainPanel),
              ],
            ),
          ),
        ),

        // Right side panels - 40% width
        Expanded(
          flex: 40,
          child: widget.hideBottomPanel || widget.bottomRightPanel == null
              ? // Single top right panel taking full height
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.topRightPanelTitle != null)
                        _buildPanelHeader(
                          title: widget.topRightPanelTitle!,
                          icon: Icons.functions,
                          iconColor: Theme.of(context).colorScheme.secondary,
                          actions: widget.topRightPanelActions,
                        ),
                      Expanded(child: widget.topRightPanel),
                    ],
                  ),
                )
              : // Two panels split vertically
              Column(
                  children: [
                    // Top right panel - 50% height
                    Expanded(
                      flex: 50,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 8, 8, 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context)
                                .dividerColor
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.topRightPanelTitle != null)
                              _buildPanelHeader(
                                title: widget.topRightPanelTitle!,
                                icon: Icons.functions,
                                iconColor:
                                    Theme.of(context).colorScheme.secondary,
                                actions: widget.topRightPanelActions,
                              ),
                            Expanded(child: widget.topRightPanel),
                          ],
                        ),
                      ),
                    ),

                    // Bottom right panel - 50% height
                    Expanded(
                      flex: 50,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 4, 8, 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context)
                                .dividerColor
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.bottomRightPanelTitle != null)
                              _buildPanelHeader(
                                title: widget.bottomRightPanelTitle!,
                                icon: Icons.history,
                                iconColor:
                                    Theme.of(context).colorScheme.tertiary,
                                actions: widget.bottomRightPanelActions,
                              ),
                            Expanded(child: widget.bottomRightPanel!),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    // Check if we have more than just the main panel
    final hasTopRightPanel = widget.topRightPanelTitle != null;
    final hasBottomRightPanel =
        !widget.hideBottomPanel && widget.bottomRightPanel != null;
    final totalTabs =
        1 + (hasTopRightPanel ? 1 : 0) + (hasBottomRightPanel ? 1 : 0);

    // If only main panel, show it directly without tabs
    if (totalTabs == 1) {
      return Column(
        children: [
          // Title bar with back button and main panel actions
          if (widget.title != null)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.2),
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Back button (only show if not embedded)
                  if (!widget.isEmbedded && Navigator.canPop(context))
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  // Add space if back button is shown
                  if (!widget.isEmbedded && Navigator.canPop(context))
                    const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  // Show main panel actions
                  if (widget.mainPanelActions != null)
                    ...widget.mainPanelActions!,
                ],
              ),
            ),
          // Main panel content directly
          Expanded(child: widget.mainPanel),
        ],
      );
    }

    // Multiple panels - show with tabs
    return Column(
      children: [
        // Tab bar with title and actions
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Column(
            children: [
              // Title bar with back button and actions for current tab
              if (widget.title != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Back button (only show if not embedded)
                      if (!widget.isEmbedded && Navigator.canPop(context))
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      // Add space if back button is shown
                      if (!widget.isEmbedded && Navigator.canPop(context))
                        const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.title!,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      // Show actions based on current tab
                      ..._getCurrentTabActions(),
                    ],
                  ),
                ),

              // Tab bar
              TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                tabs: [
                  Tab(
                    icon: const Icon(Icons.show_chart, size: 20),
                    text: widget.mainPanelTitle ?? 'Main',
                  ),
                  if (hasTopRightPanel)
                    Tab(
                      icon: const Icon(Icons.functions, size: 20),
                      text: widget.topRightPanelTitle ?? 'Functions',
                    ),
                  if (hasBottomRightPanel)
                    Tab(
                      icon: const Icon(Icons.history, size: 20),
                      text: widget.bottomRightPanelTitle ?? 'History',
                    ),
                ],
              ),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              widget.mainPanel,
              if (hasTopRightPanel) widget.topRightPanel,
              if (hasBottomRightPanel) widget.bottomRightPanel!,
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _getCurrentTabActions() {
    final currentIndex = _tabController.index;

    switch (currentIndex) {
      case 0:
        return widget.mainPanelActions ?? [];
      case 1:
        return widget.topRightPanelActions ?? [];
      case 2:
        return widget.bottomRightPanelActions ?? [];
      default:
        return [];
    }
  }
}
