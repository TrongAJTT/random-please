import 'package:flutter/material.dart';

class TwoPanelsMainMultiTabLayout extends StatefulWidget {
  /// Main tabs data
  final List<TabData> mainTabs;

  /// Secondary panel widget (nullable - can be hidden)
  final Widget? secondaryPanel;

  /// Secondary tab data for mobile (nullable - can be hidden)
  final TabData? secondaryTab;

  /// Secondary panel title (for desktop title bar)
  final String? secondaryPanelTitle;

  /// Secondary panel actions (appear on desktop title bar and mobile app bar when on secondary tab)
  final List<Widget>? secondaryPanelActions;

  /// Whether the layout is embedded in another widget
  final bool isEmbedded;

  /// App bar title for non-embedded layout
  final String? title;

  /// App bar actions for non-embedded layout
  final List<Widget>? appBarActions;

  /// Initial main tab index
  final int initialMainTabIndex;

  /// Callback when main tab index changes
  final Function(int)? onMainTabChanged;

  /// Whether secondary panel/tab is enabled
  final bool secondaryEnabled;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Main panel title (for title bar)
  final String? mainPanelTitle;

  /// Main panel actions (appear on title bar)
  final List<Widget>? mainPanelActions;

  /// Main tab index
  final int mainTabIndex;

  const TwoPanelsMainMultiTabLayout({
    super.key,
    required this.mainTabs,
    this.secondaryPanel,
    this.secondaryTab,
    this.secondaryPanelTitle,
    this.secondaryPanelActions,
    this.isEmbedded = false,
    this.title,
    this.appBarActions,
    this.initialMainTabIndex = 0,
    this.onMainTabChanged,
    this.secondaryEnabled = true,
    this.floatingActionButton,
    this.mainPanelTitle,
    this.mainPanelActions,
    this.mainTabIndex = 0,
  }) : assert(mainTabs.length >= 2, 'Must have at least 2 main tabs');

  @override
  State<TwoPanelsMainMultiTabLayout> createState() =>
      _TwoPanelsMainMultiTabLayoutState();
}

class _TwoPanelsMainMultiTabLayoutState
    extends State<TwoPanelsMainMultiTabLayout> with TickerProviderStateMixin {
  late TabController _mainTabController;
  TabController? _mobileTabController;

  int _currentMainTabIndex = 0;
  bool _isOnSecondaryTab = false; // For mobile floating button state

  @override
  void initState() {
    super.initState();
    _currentMainTabIndex =
        widget.initialMainTabIndex.clamp(0, widget.mainTabs.length - 1);
    _mainTabController = TabController(
      length: widget.mainTabs.length,
      vsync: this,
      initialIndex: widget.mainTabIndex,
    );
    _mainTabController.addListener(_onMainTabChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupMobileTabController();
  }

  @override
  void didUpdateWidget(TwoPanelsMainMultiTabLayout oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.mainTabs.length != oldWidget.mainTabs.length) {
      _mainTabController.removeListener(_onMainTabChanged);
      _mainTabController.dispose();
      _mainTabController = TabController(
          length: widget.mainTabs.length,
          vsync: this,
          initialIndex: widget.mainTabIndex);
      _mainTabController.addListener(_onMainTabChanged);

      _mobileTabController?.removeListener(_onMobileTabChanged);
      _mobileTabController?.dispose();
      _setupMobileTabController();
    }

    if (widget.mainTabIndex != oldWidget.mainTabIndex &&
        widget.mainTabIndex != _mobileTabController?.index) {
      _mainTabController.animateTo(widget.mainTabIndex);
      _mobileTabController?.animateTo(widget.mainTabIndex);
    }

    // Handle secondary tab enable/disable change
    if (oldWidget.secondaryEnabled != widget.secondaryEnabled) {
      _setupMobileTabController();
    }
  }

  void _setupMobileTabController() {
    _mobileTabController = TabController(
      length: widget.mainTabs.length + 1,
      vsync: this,
      initialIndex: widget.mainTabIndex,
    );
    _mobileTabController?.addListener(_onMobileTabChanged);
  }

  void _onMainTabChanged() {
    if (_mainTabController.indexIsChanging) return;

    final newIndex = _mainTabController.index;
    if (newIndex != _currentMainTabIndex) {
      setState(() {
        _currentMainTabIndex = newIndex;
      });
      widget.onMainTabChanged?.call(newIndex);
    }
  }

  void _onMobileTabChanged() {
    if (_mobileTabController == null || _mobileTabController!.indexIsChanging) {
      return;
    }

    final currentIndex = _mobileTabController!.index;
    final isSecondaryTab = widget.secondaryEnabled &&
        widget.secondaryTab != null &&
        currentIndex == widget.mainTabs.length;

    setState(() {
      _isOnSecondaryTab = isSecondaryTab;
      if (!isSecondaryTab) {
        _currentMainTabIndex = currentIndex;
        widget.onMainTabChanged?.call(currentIndex);
      }
    });
  }

  void _toggleMainSecondaryTab() {
    if (_mobileTabController == null) return;

    final hasSecondaryTab =
        widget.secondaryEnabled && widget.secondaryTab != null;
    if (!hasSecondaryTab) return;

    final secondaryTabIndex = widget.mainTabs.length;

    if (_isOnSecondaryTab) {
      // Switch to last main tab
      _mobileTabController!.animateTo(_currentMainTabIndex);
    } else {
      // Switch to secondary tab
      _mobileTabController!.animateTo(secondaryTabIndex);
    }
  }

  @override
  void dispose() {
    _mainTabController.removeListener(_onMainTabChanged);
    _mainTabController.dispose();
    _mobileTabController?.removeListener(_onMobileTabChanged);
    _mobileTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    if (isDesktop) {
      return _buildDesktopLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    final showSecondaryPanel =
        widget.secondaryEnabled && widget.secondaryPanel != null;

    final mainContentCard = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main panel title bar
          if (widget.mainPanelTitle != null)
            Container(
              height: 48, // Fixed height for consistency
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border(
                  bottom: BorderSide(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calculate,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.mainPanelTitle!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  if (widget.mainPanelActions != null) ...[
                    const SizedBox(width: 8),
                    ...widget.mainPanelActions!,
                  ],
                ],
              ),
            ),
          // Main tabs
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: widget.mainPanelTitle != null
                  ? null
                  : const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _mainTabController,
              isScrollable: widget.mainTabs.length >= 6,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: widget.mainTabs
                  .map((tab) => Tab(
                        icon: tab.icon != null ? Icon(tab.icon) : null,
                        text: tab.label,
                      ))
                  .toList(),
            ),
          ),
          // Main tab views
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: TabBarView(
                controller: _mainTabController,
                children: widget.mainTabs.map((tab) => tab.content).toList(),
              ),
            ),
          ),
        ],
      ),
    );

    final secondaryPanelCard = showSecondaryPanel
        ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildSecondaryPanelWithTitleBar(),
            ),
          )
        : null;

    final desktopContent = showSecondaryPanel
        ? Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(flex: 2, child: mainContentCard),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: secondaryPanelCard!),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: SizedBox(width: 800, child: mainContentCard),
            ),
          );

    if (widget.isEmbedded) {
      // For embedded mode, return content directly without Scaffold
      return desktopContent;
    } else {
      // For standalone mode, wrap in Scaffold with AppBar
      return Scaffold(
        appBar: AppBar(
          title: widget.title != null ? Text(widget.title!) : null,
          actions: widget.appBarActions,
        ),
        body: desktopContent,
        floatingActionButton: widget.floatingActionButton,
      );
    }
  }

  Widget _buildSecondaryPanelWithTitleBar() {
    return Column(
      children: [
        // Secondary panel title bar
        if (widget.secondaryPanelTitle != null)
          Container(
            height: 48, // Fixed height to match main panel
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.secondaryPanelTitle!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                if (widget.secondaryPanelActions != null) ...[
                  const SizedBox(width: 8),
                  ...widget.secondaryPanelActions!,
                ],
              ],
            ),
          ),
        // Secondary panel content
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: widget.secondaryPanelTitle != null
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  : BorderRadius.circular(12),
            ),
            child: widget.secondaryPanel!,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final hasSecondaryTab =
        widget.secondaryEnabled && widget.secondaryTab != null;
    final allTabs = [
      ...widget.mainTabs,
      if (hasSecondaryTab) widget.secondaryTab!,
    ];

    final tabContent = Column(
      children: [
        // Tab bar
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _mobileTabController!,
            isScrollable: allTabs.length >= 5,
            tabs: allTabs
                .map((tab) => Tab(
                      icon: tab.icon != null ? Icon(tab.icon, size: 20) : null,
                      text: tab.label,
                    ))
                .toList(),
          ),
        ),
        // Tab views
        Expanded(
          child: TabBarView(
            controller: _mobileTabController!,
            children: allTabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );

    if (widget.isEmbedded) {
      return Stack(
        children: [
          tabContent,
          if (hasSecondaryTab) _buildPositionedFloatingButton(),
        ],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: widget.title != null ? Text(widget.title!) : null,
          actions: _getMobileAppBarActions(),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(), // Empty container to maintain spacing
          ),
        ),
        body: tabContent,
        floatingActionButton: hasSecondaryTab
            ? _buildFloatingActionButton()
            : widget.floatingActionButton,
      );
    }
  }

  Widget _buildPositionedFloatingButton() {
    final hasSecondaryTab =
        widget.secondaryEnabled && widget.secondaryTab != null;
    if (!hasSecondaryTab) return const SizedBox.shrink();

    return Positioned(
      bottom: 16,
      right: 16,
      child: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    final hasSecondaryTab =
        widget.secondaryEnabled && widget.secondaryTab != null;
    if (!hasSecondaryTab) return const SizedBox.shrink();

    return FloatingActionButton.small(
      onPressed: _toggleMainSecondaryTab,
      tooltip:
          _isOnSecondaryTab ? 'Back to calculator' : widget.secondaryTab!.label,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          _isOnSecondaryTab
              ? Icons.calculate
              : (widget.secondaryTab!.icon ?? Icons.more_horiz),
          key: ValueKey(_isOnSecondaryTab),
        ),
      ),
    );
  }

  List<Widget>? _getMobileAppBarActions() {
    final hasSecondaryTab =
        widget.secondaryEnabled && widget.secondaryTab != null;

    // If we're on secondary tab, show secondary panel actions
    if (hasSecondaryTab &&
        _isOnSecondaryTab &&
        widget.secondaryPanelActions != null) {
      return widget.secondaryPanelActions;
    }

    // If we're on main tab and have main panel actions, show them
    if (!_isOnSecondaryTab && widget.mainPanelActions != null) {
      return [
        ...widget.mainPanelActions!,
        if (widget.appBarActions != null) ...widget.appBarActions!,
      ];
    }

    // Otherwise, show default app bar actions
    return widget.appBarActions;
  }

  /// External API for tab navigation
  void navigateToTab(int tabIndex) {
    if (tabIndex >= 0 && tabIndex < widget.mainTabs.length) {
      setState(() {
        _currentMainTabIndex = tabIndex;
      });
      widget.onMainTabChanged?.call(tabIndex);
    }
  }

  /// Get current tab index
  int get currentTabIndex => _currentMainTabIndex;
}

class TabData {
  final String label;
  final IconData? icon;
  final Widget content;

  const TabData({
    required this.label,
    this.icon,
    required this.content,
  });
}
