part of 'restaurant_menu_view.dart';

class RestaurantMenuDescription extends StatelessWidget {
  const RestaurantMenuDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Text(
      locale.calendar_restaurant_description,
      textAlign: TextAlign.start,
      style: getRegularStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size12,
        color: color.onSurface.withValues(alpha: 0.62),
      ).copyWith(height: 1.7),
    );
  }
}
