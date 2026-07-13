part of 'calendar_restaurant_picker_sheet.dart';

class _RestaurantLogo extends StatelessWidget {
  const _RestaurantLogo({required this.type});

  final CalendarRestaurantLogoType type;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    switch (type) {
      case CalendarRestaurantLogoType.healthyBowl:
        return _CircleTextLogo(
          top: 'HEALTHY',
          bottom: 'BOWL',
          icon: Icons.ramen_dining_rounded,
          foreground: color.primary,
          background: color.surface,
          outlined: true,
        );
      case CalendarRestaurantLogoType.dietHouse:
        return _CircleTextLogo(
          top: 'DIET',
          bottom: 'HOUSE',
          icon: Icons.eco_rounded,
          foreground: color.onSurface,
          background: color.surface,
          outlined: true,
        );
      case CalendarRestaurantLogoType.proteinKitchen:
        return _CircleTextLogo(
          eyebrow: 'THE',
          top: 'PROTEIN',
          bottom: 'KITCHEN',
          foreground: color.onInverseSurface,
          background: color.inverseSurface,
        );
      case CalendarRestaurantLogoType.starbucks:
        return const _ImageCircleLogo(asset: Assets.offerStarbucksLogo);
      case CalendarRestaurantLogoType.burgerKing:
        return const _ImageCircleLogo(asset: Assets.offerBurgerKingLogo);
    }
  }
}
