part of 'calendar_restaurant_summary_card.dart';

class CalendarRestaurantSummaryLogo extends StatelessWidget {
  const CalendarRestaurantSummaryLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: Spacing.calendarRestaurantSummaryLogoSize,
      height: Spacing.calendarRestaurantSummaryLogoSize,
      decoration: BoxDecoration(color: color.surface, shape: BoxShape.circle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.ramen_dining_rounded, color: color.primary, size: 28),
          Text(
            'HEALTHY',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.primary,
            ).copyWith(height: 1),
          ),
          Text(
            'BOWL',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.primary,
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
