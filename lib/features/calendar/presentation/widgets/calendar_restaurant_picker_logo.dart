part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantPickerLogo extends StatelessWidget {
  const CalendarRestaurantPickerLogo({
    required this.type,
    this.logoUrl,
    this.semanticLabel,
  });

  final CalendarRestaurantLogoType type;
  final String? logoUrl;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return AppCachedNetworkImage(
        imageUrl: logoUrl,
        width: 46,
        height: 46,
        shape: BoxShape.circle,
        semanticLabel: semanticLabel,
      );
    }

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
        return CalendarCircleTextLogo(
          top: 'COFFEE',
          bottom: 'BAR',
          icon: Icons.local_cafe_rounded,
          foreground: color.primary,
          background: color.surface,
          outlined: true,
        );
      case CalendarRestaurantLogoType.burgerKing:
        return CalendarCircleTextLogo(
          top: 'GRILL',
          bottom: 'HOUSE',
          icon: Icons.lunch_dining_rounded,
          foreground: color.onInverseSurface,
          background: color.inverseSurface,
        );
    }
  }
}
