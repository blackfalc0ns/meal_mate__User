part of 'calendar_restaurant_summary_card.dart';

class CalendarRestaurantSummaryLogo extends StatelessWidget {
  const CalendarRestaurantSummaryLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

    return Container(
      width: Spacing.calendarRestaurantSummaryLogoSize,
      height: Spacing.calendarRestaurantSummaryLogoSize,
      decoration: BoxDecoration(color: color.surface, shape: BoxShape.circle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ramen_dining_rounded,
            color: color.primary,
            size: Spacing.calendarRestaurantSummaryNutritionIconSize,
          ),
          Text(
            'HEALTHY',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.primary,
            ).copyWith(height: 1),
          ),
          Text(
            'BOWL',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.primary,
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
