part of 'restaurant_menu_view.dart';

class RestaurantMenuNutritionRow extends StatelessWidget {
  const RestaurantMenuNutritionRow({super.key, required this.option});

  final RestaurantMenuOption option;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final items = [
      RestaurantMenuNutrition(
        animationAsset: Assets.fireAnimation,
        value: option.calories,
        label: locale.calendar_calories,
      ),
      RestaurantMenuNutrition(
        animationAsset: Assets.muscleAnimation,
        value: option.protein,
        label: locale.calendar_protein,
      ),
      RestaurantMenuNutrition(
        animationAsset: Assets.wheatAnimation,
        value: option.carbs,
        label: locale.calendar_carbs,
      ),
      RestaurantMenuNutrition(
        animationAsset: Assets.dropletAnimation,
        value: option.fat,
        label: locale.calendar_fat,
      ),
    ];

    return Row(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Expanded(child: items[index]),
          if (index != items.length - 1)
            Container(
              width: Spacing.hairline,
              height: Spacing.xxl,
              color: color.outlineVariant,
            ),
        ],
      ],
    );
  }
}
