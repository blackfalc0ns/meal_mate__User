part of 'restaurant_menu_view.dart';

class RestaurantMenuMealsBody extends StatefulWidget {
  const RestaurantMenuMealsBody({
    super.key,
    required this.mode,
    required this.menuData,
    required this.tabs,
    required this.headerSliver,
    this.onMealToggled,
    this.onOptionDetails,
    this.onLoadMore,
    this.onSave,
    this.canSave = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSaving = false,
    this.failure,
    this.bottomContentPadding = Spacing.zero,
    this.selectionControlBuilder,
    this.isMealSelected,
  });

  final RestaurantMenuMode mode;
  final RestaurantMenuData menuData;
  final List<RestaurantMenuTab> tabs;
  final Widget headerSliver;
  final ValueChanged<String>? onMealToggled;
  final ValueChanged<RestaurantMenuOption>? onOptionDetails;
  final ValueChanged<String>? onLoadMore;
  final VoidCallback? onSave;
  final bool canSave;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSaving;
  final Failure? failure;
  final double bottomContentPadding;
  final Widget Function(BuildContext context, RestaurantMenuOption option)?
  selectionControlBuilder;
  final bool Function(String mealId)? isMealSelected;

  @override
  State<RestaurantMenuMealsBody> createState() =>
      RestaurantMenuMealsBodyState();
}

class RestaurantMenuMealsBodyState extends State<RestaurantMenuMealsBody> {
  late final ScrollController _scrollController;
  String? _selectedSlotKey;
  int _selectedFallbackIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _reconcileSelectedSlotKey();
  }

  @override
  void didUpdateWidget(covariant RestaurantMenuMealsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    _reconcileSelectedSlotKey();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _reconcileSelectedSlotKey() {
    if (widget.tabs.isNotEmpty) {
      final exists = widget.tabs.any((t) => t.key == _selectedSlotKey);
      if (!exists) {
        _selectedSlotKey = widget.tabs.first.key;
      }
    } else {
      _selectedSlotKey = null;
    }
  }

  void _onTabChanged(int index) {
    if (widget.tabs.isNotEmpty) {
      if (index >= 0 && index < widget.tabs.length) {
        final newKey = widget.tabs[index].key;
        if (_selectedSlotKey != newKey) {
          setState(() {
            _selectedSlotKey = newKey;
          });
          _resetScrollPosition();
        }
      }
    } else {
      if (_selectedFallbackIndex != index) {
        setState(() {
          _selectedFallbackIndex = index;
        });
        _resetScrollPosition();
      }
    }
  }

  void _resetScrollPosition() {
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      _scrollController.jumpTo(0);
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0 ||
        notification.metrics.axis != Axis.vertical ||
        notification is! ScrollUpdateNotification ||
        widget.isLoading ||
        widget.isLoadingMore) {
      return false;
    }
    if (notification.metrics.extentAfter <= 200) {
      final slotKey = _currentSlotKey;
      widget.onLoadMore?.call(slotKey);
    }
    return false;
  }

  String get _currentSlotKey {
    if (widget.tabs.isNotEmpty) {
      return _selectedSlotKey ?? widget.tabs.first.key;
    }
    return _selectedFallbackIndex.toString();
  }

  void _handleOptionDetails(RestaurantMenuOption option) {
    if (widget.onOptionDetails != null) {
      widget.onOptionDetails!(option);
      return;
    }
    _openOptionDetails(option);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final tabs = widget.tabs;
    final tabLabels = tabs.isEmpty
        ? [
            locale.calendar_breakfast,
            locale.calendar_lunch,
            locale.calendar_dinner,
          ]
        : tabs.map((t) => t.label).toList();

    final selectedTabIndex = tabs.isNotEmpty
        ? tabs
              .indexWhere((t) => t.key == _selectedSlotKey)
              .clamp(0, tabs.length - 1)
        : _selectedFallbackIndex.clamp(0, tabLabels.length - 1);

    final currentSlotKey = tabs.isNotEmpty
        ? tabs[selectedTabIndex].key
        : tabLabels[selectedTabIndex];

    final currentMealType = tabLabels.isNotEmpty
        ? tabLabels[selectedTabIndex]
        : '';

    final options = tabs.isNotEmpty && selectedTabIndex < tabs.length
        ? tabs[selectedTabIndex].options
        : const <RestaurantMenuOption>[];

    return RestaurantMenuContent(
      scrollController: _scrollController,
      onScrollNotification: _onScrollNotification,
      headerSliver: widget.headerSliver,
      tabLabels: tabLabels,
      selectedTabIndex: selectedTabIndex,
      currentSlotKey: currentSlotKey,
      currentMealType: currentMealType,
      options: options,
      isLoading: widget.isLoading,
      isLoadingMore: widget.isLoadingMore,
      isSaving: widget.isSaving,
      canSave: widget.canSave,
      failure: widget.failure,
      mode: widget.mode,
      bottomContentPadding: widget.bottomContentPadding,
      onTabChanged: _onTabChanged,
      onMealToggled: widget.mode == RestaurantMenuMode.selection
          ? widget.onMealToggled
          : null,
      onOptionDetails: _handleOptionDetails,
      onSave: widget.onSave,
      selectionControlBuilder: widget.selectionControlBuilder,
    );
  }
}
