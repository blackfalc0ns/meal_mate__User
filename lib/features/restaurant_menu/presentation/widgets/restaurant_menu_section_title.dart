part of 'restaurant_menu_view.dart';

class RestaurantMenuSectionTitle extends StatelessWidget {
  const RestaurantMenuSectionTitle({super.key, required this.mealType});

  final String mealType;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 36),
      child: Text(
        locale.calendar_meals_for(mealType),
        textAlign: TextAlign.right,
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: 18,
          color: color.onSurface,
        ),
      ),
    );
  }
}
