part of 'calendar_restaurant_summary_card.dart';

class CalendarRestaurantSummaryLogo extends StatelessWidget {
  const CalendarRestaurantSummaryLogo({
    super.key,
    this.logoUrl,
    this.semanticLabel,
  });

  final String? logoUrl;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return AppCachedNetworkImage(
        imageUrl: logoUrl,
        width: Spacing.calendarRestaurantSummaryLogoSize,
        height: Spacing.calendarRestaurantSummaryLogoSize,
        shape: BoxShape.circle,
        semanticLabel: semanticLabel,
      );
    }

    return Container(
      width: Spacing.calendarRestaurantSummaryLogoSize,
      height: Spacing.calendarRestaurantSummaryLogoSize,
      decoration: BoxDecoration(color: color.surface, shape: BoxShape.circle),
      child: Icon(
        Icons.restaurant_rounded,
        color: color.primary,
        size: Spacing.calendarRestaurantSummaryNutritionIconSize + 6,
      ),
    );
  }
}
