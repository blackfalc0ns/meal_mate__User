part of 'restaurant_menu_view.dart';

class RestaurantMenuSectionTitle extends StatelessWidget {
  const RestaurantMenuSectionTitle({super.key, required this.mealType});

  final String mealType;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Text(
      locale.calendar_meals_for(mealType),

      style: getBoldStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: 18,
        color: color.onSurface,
      ),
    );
  }
}
