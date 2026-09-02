part of 'restaurant_menu_view.dart';

class RestaurantMenuOptionsSection extends StatelessWidget {
  const RestaurantMenuOptionsSection({
    super.key,
    required this.mealType,
    required this.tabIndex,
    required this.options,
    this.onOptionSelected,
    this.onOptionDetailsSelected,
    this.isLoadingMore = false,
  });

  final String mealType;
  final int tabIndex;
  final List<RestaurantMenuOption> options;
  final ValueChanged<int>? onOptionSelected;
  final ValueChanged<int>? onOptionDetailsSelected;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final offset = Tween<Offset>(
          begin: const Offset(0.22, 0),
          end: Offset.zero,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: curvedAnimation,
          child: SizeTransition(
            sizeFactor: curvedAnimation,
            alignment: Alignment.topCenter,
            child: SlideTransition(position: offset, child: child),
          ),
        );
      },
      child: Column(
        key: ValueKey(tabIndex),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RestaurantMenuSectionTitle(mealType: mealType),
          const SizedBox(height: Spacing.base),
          for (var index = 0; index < options.length; index++) ...[
            RestaurantMenuOptionCard(
              option: options[index],
              onTap: onOptionSelected == null
                  ? null
                  : () => onOptionSelected!(index),
              onDetailsTap: onOptionDetailsSelected == null
                  ? null
                  : () => onOptionDetailsSelected!(index),
            ),
            if (index != options.length - 1) const RestaurantMenuDividerLine(),
          ],
          if (isLoadingMore) ...[
            const SizedBox(height: Spacing.md),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.md),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
