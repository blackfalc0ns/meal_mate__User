part of 'restaurant_menu_view.dart';

class RestaurantMenuContent extends StatelessWidget {
  const RestaurantMenuContent({
    super.key,
    required this.scrollController,
    required this.onScrollNotification,
    required this.headerSliver,
    required this.tabLabels,
    required this.selectedTabIndex,
    required this.currentSlotKey,
    required this.currentMealType,
    required this.options,
    required this.isLoading,
    required this.isLoadingMore,
    required this.isSaving,
    required this.canSave,
    required this.failure,
    required this.mode,
    required this.bottomContentPadding,
    required this.onTabChanged,
    required this.onMealToggled,
    required this.onOptionDetails,
    required this.onSave,
    required this.isOptionAnimated,
    required this.onOptionAnimated,
    this.selectionControlBuilder,
  });

  final ScrollController scrollController;
  final NotificationListenerCallback<ScrollNotification> onScrollNotification;
  final Widget headerSliver;
  final List<String> tabLabels;
  final int selectedTabIndex;
  final String currentSlotKey;
  final String currentMealType;
  final List<RestaurantMenuOption> options;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSaving;
  final bool canSave;
  final Failure? failure;
  final RestaurantMenuMode mode;
  final double bottomContentPadding;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<String>? onMealToggled;
  final ValueChanged<RestaurantMenuOption>? onOptionDetails;
  final VoidCallback? onSave;
  final bool Function(String mealId) isOptionAnimated;
  final ValueChanged<String> onOptionAnimated;
  final Widget Function(BuildContext context, RestaurantMenuOption option)?
  selectionControlBuilder;

  static Widget buildHeaderSliver({
    required bool isFullPage,
    required String restaurantName,
    String? restaurantLogoAsset,
    String? restaurantLogoUrl,
    String? restaurantInitials,
    required List<RestaurantMenuOrigin> origins,
    required bool isLoading,
  }) {
    return SliverToBoxAdapter(
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
              restaurantName: restaurantName,
              restaurantLogoAsset: restaurantLogoAsset,
              restaurantLogoUrl: restaurantLogoUrl,
              restaurantInitials: restaurantInitials,
              description: const RestaurantMenuDescription(),
              isLoading: isLoading,
            ),
            const SizedBox(height: Spacing.sm),
            const RestaurantMenuDividerLine(),
            RestaurantMenuSourceSection(origins: origins, isLoading: isLoading),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          headerSliver,
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Spacing.base),
                  RestaurantMenuTabs(
                    labels: tabLabels,
                    selectedIndex: selectedTabIndex,
                    isLoading: isLoading,
                    onChanged: onTabChanged,
                  ),
                  const SizedBox(height: Spacing.sm),
                ],
              ),
            ),
          ),
          if (failure != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                ),
                child: ApiErrorWidget(exception: failure!.exception),
              ),
            )
          else if (isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.screenH),
                child: RestaurantMenuLoadingSkeleton(),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RestaurantMenuSectionTitle(mealType: currentMealType),
                    const SizedBox(height: Spacing.base),
                  ],
                ),
              ),
            ),
            RestaurantMenuOptionsSection(
              selectedSlotKey: currentSlotKey,
              options: options,
              isOptionAnimated: isOptionAnimated,
              onOptionAnimated: onOptionAnimated,
              onMealToggled: onMealToggled,
              onOptionDetails: onOptionDetails,
              selectionControlBuilder: selectionControlBuilder,
            ),
          ],
          if (isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.md),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
            ),
          if (mode == RestaurantMenuMode.selection && onSave != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.lg,
                  Spacing.lg,
                  Spacing.lg,
                  0,
                ),
                child: AppButton(
                  text: locale.calendar_done,
                  isLoading: isSaving,
                  onPressed: canSave ? onSave : null,
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(height: Spacing.xxl + bottomContentPadding),
          ),
        ],
      ),
    );
  }
}
