part of 'restaurant_menu_view.dart';

class RestaurantMenuContent extends StatelessWidget {
  const RestaurantMenuContent({
    super.key,
    required this.isFullPage,
    required this.isLoading,
    required this.isLoadingMore,
    required this.isSaving,
    required this.canSave,
    required this.failure,
    required this.mode,
    required this.resolvedRestaurantName,
    required this.restaurantLogoAsset,
    required this.restaurantLogoUrl,
    required this.restaurantInitials,
    required this.origins,
    required this.mealTabs,
    required this.selectedTab,
    required this.selectedSlot,
    required this.options,
    required this.onTabChanged,
    required this.onOptionSelected,
    required this.onOptionDetailsSelected,
    required this.onLoadMore,
    required this.onSave,
    required this.bottomContentPadding,
  });

  final bool isFullPage;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSaving;
  final bool canSave;
  final Failure? failure;
  final RestaurantMenuMode mode;
  final String resolvedRestaurantName;
  final String? restaurantLogoAsset;
  final String? restaurantLogoUrl;
  final String? restaurantInitials;
  final List<RestaurantMenuOrigin> origins;
  final List<String> mealTabs;
  final int selectedTab;
  final String selectedSlot;
  final List<RestaurantMenuOption> options;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<int>? onOptionSelected;
  final ValueChanged<int>? onOptionDetailsSelected;
  final ValueChanged<String>? onLoadMore;
  final VoidCallback? onSave;
  final double bottomContentPadding;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200 &&
            !isLoading &&
            !isLoadingMore) {
          onLoadMore?.call(selectedSlot);
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
              child: Column(
                children: [
                  if (!isFullPage) ...[
                    const SizedBox(height: Spacing.lg),
                    const RestaurantMenuSheetHandle(),
                  ],
                  const SizedBox(height: Spacing.md),
                  RestaurantMenuHeader(
                    restaurantName: resolvedRestaurantName,
                    restaurantLogoAsset: restaurantLogoAsset,
                    restaurantLogoUrl: restaurantLogoUrl,
                    restaurantInitials: restaurantInitials,
                  ),
                  const RestaurantMenuDescription(),
                  const RestaurantMenuDividerLine(),
                  RestaurantMenuSourceSection(
                    origins: origins,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: Spacing.base),
                  RestaurantMenuTabs(
                    labels: mealTabs,
                    selectedIndex: selectedTab,
                    isLoading: isLoading,
                    onChanged: onTabChanged,
                  ),
                  const SizedBox(height: Spacing.sm),
                  if (failure != null)
                    ApiErrorWidget(exception: failure!.exception)
                  else if (isLoading)
                    const RestaurantMenuLoadingSkeleton()
                  else
                    RestaurantMenuOptionsSection(
                      mealType: mealTabs[selectedTab],
                      tabIndex: selectedTab,
                      options: options,
                      isLoadingMore: isLoadingMore,
                      onOptionSelected: onOptionSelected,
                      onOptionDetailsSelected: onOptionDetailsSelected,
                    ),
                  if (mode == RestaurantMenuMode.selection &&
                      onSave != null) ...[
                    const SizedBox(height: Spacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg,
                      ),
                      child: AppButton(
                        text: locale.calendar_done,
                        isLoading: isSaving,
                        onPressed: canSave ? onSave : null,
                      ),
                    ),
                  ],
                  SizedBox(height: Spacing.xxl + bottomContentPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
