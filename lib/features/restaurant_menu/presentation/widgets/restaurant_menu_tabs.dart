part of 'restaurant_menu_view.dart';

class RestaurantMenuTabs extends StatelessWidget {
  const RestaurantMenuTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.isLoading = false,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    if (isLoading) {
      return SizedBox(
        height: Spacing.restaurantDetailsTabsHeight,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Divider(
                height: Spacing.border,
                thickness: Spacing.border,
                color: color.outlineVariant,
              ),
            ),
            const Positioned(
              left: Spacing.restaurantDetailsTabsHorizontalInset,
              right: Spacing.restaurantDetailsTabsHorizontalInset,
              top: 0,
              bottom: 0,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: ShimmerPlaceholder.rect(
                        width: 70,
                        height: 14,
                        borderRadius: Spacing.xs,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ShimmerPlaceholder.rect(
                        width: 70,
                        height: 14,
                        borderRadius: Spacing.xs,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ShimmerPlaceholder.rect(
                        width: 70,
                        height: 14,
                        borderRadius: Spacing.xs,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: Spacing.restaurantDetailsTabsHeight,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Divider(
              height: Spacing.border,
              thickness: Spacing.border,
              color: color.outlineVariant,
            ),
          ),
          labels.isEmpty
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    for (var index = 0; index < labels.length; index++)
                      Expanded(
                        child: RestaurantMenuTabLabel(
                          text: labels[index],
                          active: selectedIndex == index,
                          onTap: () => onChanged(index),
                        ),
                      ),
                  ],
                ),
          Positioned(
            left: Spacing.restaurantDetailsTabsHorizontalInset,
            right: Spacing.restaurantDetailsTabsHorizontalInset,
            bottom: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tabCount = labels.isEmpty ? 1 : labels.length;

                return AnimatedAlign(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment(
                    labels.length <= 1
                        ? 1
                        : 1 - ((selectedIndex * 2) / (labels.length - 1)),
                    0,
                  ),
                  child: Container(
                    width: constraints.maxWidth / tabCount,
                    height: Spacing.restaurantDetailsTabsIndicatorHeight,
                    decoration: BoxDecoration(
                      color: color.primary,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Spacing.radiusLg),
                      ),
                    ),
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
