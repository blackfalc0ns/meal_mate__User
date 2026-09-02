part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantOptionCard extends StatelessWidget {
  const CalendarRestaurantOptionCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  final CalendarRestaurantOptionEntity restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isDisabled = !restaurant.isEnabled;

    return SizedBox(
      height: 74.22,
      child: Material(
        color: color.surface,
        borderRadius: BorderRadius.circular(15.46),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(15.46),
          child: Opacity(
            opacity: isDisabled ? 0.48 : 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.46),
                border: Border.all(color: color.outlineVariant, width: 1.55),
              ),
              padding: const EdgeInsets.fromLTRB(7.4, 4.6, 7.4, 4.8),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  const CalendarArrowBubble(),
                  const SizedBox(width: 27.6),
                  CalendarRating(
                    value: restaurant.rating,
                    ratingCount: restaurant.ratingCount,
                  ),
                  const SizedBox(width: 27.6),
                  Expanded(
                    child: CalendarRestaurantCopy(restaurant: restaurant),
                  ),
                  const SizedBox(width: 10.5),
                  CalendarRestaurantPickerLogo(
                    type: restaurant.logoType,
                    logoUrl: restaurant.logoUrl,
                    semanticLabel: restaurant.name,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
