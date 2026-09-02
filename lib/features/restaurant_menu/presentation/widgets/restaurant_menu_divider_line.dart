part of 'restaurant_menu_view.dart';

class RestaurantMenuDividerLine extends StatelessWidget {
  const RestaurantMenuDividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 37, end: 36),
      child: Divider(
        height: 20.8,
        thickness: 1.04,
        color: color.outlineVariant,
      ),
    );
  }
}
