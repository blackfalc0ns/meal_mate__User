part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantPickerLogo extends StatelessWidget {
  const CalendarRestaurantPickerLogo({required this.type});

  final CalendarRestaurantLogoType type;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    switch (type) {
      case CalendarRestaurantLogoType.healthyBowl:
        return CalendarCircleTextLogo(
          top: 'HEALTHY',
          bottom: 'BOWL',
          icon: Icons.ramen_dining_rounded,
          foreground: color.primary,
          background: color.surface,
          outlined: true,
        );
      case CalendarRestaurantLogoType.dietHouse:
        return CalendarCircleTextLogo(
          top: 'DIET',
          bottom: 'HOUSE',
          icon: Icons.eco_rounded,
          foreground: color.onSurface,
          background: color.surface,
          outlined: true,
        );
      case CalendarRestaurantLogoType.proteinKitchen:
        return CalendarCircleTextLogo(
          eyebrow: 'THE',
          top: 'PROTEIN',
          bottom: 'KITCHEN',
          foreground: color.onInverseSurface,
          background: color.inverseSurface,
        );
      case CalendarRestaurantLogoType.starbucks:
        return const CalendarImageCircleLogo(asset: Assets.offerStarbucksLogo);
      case CalendarRestaurantLogoType.burgerKing:
        return const CalendarImageCircleLogo(asset: Assets.offerBurgerKingLogo);
    }
  }
}
