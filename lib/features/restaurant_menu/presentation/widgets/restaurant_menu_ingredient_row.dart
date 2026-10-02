part of 'restaurant_menu_view.dart';

class RestaurantMenuIngredientRow extends StatelessWidget {
  const RestaurantMenuIngredientRow({super.key, required this.ingredients});

  final List<RestaurantMenuIngredient> ingredients;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (final ingredient in ingredients) ...[
            RestaurantMenuIngredientChip(
              label: ingredient.label,
              iconUrl: ingredient.iconUrl,
            ),
            const SizedBox(width: 3.5),
          ],
        ],
      ),
    );
  }
}
