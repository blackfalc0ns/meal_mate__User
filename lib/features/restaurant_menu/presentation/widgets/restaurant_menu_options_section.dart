part of 'restaurant_menu_view.dart';

class RestaurantMenuOptionsSection extends StatelessWidget {
  const RestaurantMenuOptionsSection({
    super.key,
    required this.selectedSlotKey,
    required this.options,
    this.isOptionAnimated,
    this.onOptionAnimated,
    this.onMealToggled,
    this.onOptionDetails,
    this.selectionControlBuilder,
  });

  final String selectedSlotKey;
  final List<RestaurantMenuOption> options;
  final bool Function(String mealId)? isOptionAnimated;
  final ValueChanged<String>? onOptionAnimated;
  final ValueChanged<String>? onMealToggled;
  final ValueChanged<RestaurantMenuOption>? onOptionDetails;
  final Widget Function(BuildContext context, RestaurantMenuOption option)?
  selectionControlBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isOdd) return const RestaurantMenuDividerLine();
            final optionIndex = index ~/ 2;
            final option = options[optionIndex];

            return RestaurantMenuOptionCard(
              key: ValueKey((selectedSlotKey, option.id)),
              option: option,
              onTap: onMealToggled == null
                  ? null
                  : () => onMealToggled!(option.id),
              onDetailsTap: onOptionDetails == null
                  ? null
                  : () => onOptionDetails!(option),
              selectionControlBuilder: selectionControlBuilder,
            );
          },
          childCount: options.isEmpty ? 0 : options.length * 2 - 1,
          findChildIndexCallback: (Key key) {
            if (key is ValueKey) {
              final val = key.value;
              String? mealId;
              if (val is (String, String)) {
                if (val.$1 != selectedSlotKey) return null;
                mealId = val.$2;
              } else if (val is String) {
                mealId = val;
              }
              if (mealId != null) {
                final idx = options.indexWhere((opt) => opt.id == mealId);
                if (idx != -1) return idx * 2;
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}
