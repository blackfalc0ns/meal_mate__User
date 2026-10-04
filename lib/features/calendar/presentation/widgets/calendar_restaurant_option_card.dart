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
    final isDisabled = !restaurant.isEnabled || restaurant.isQuotaExhausted;

    return Container(
      constraints: const BoxConstraints(minHeight: 80),
      child: Material(
        color: color.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Opacity(
            opacity: isDisabled ? 0.5 : 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDisabled
                      ? color.outline.withValues(alpha: 0.3)
                      : color.outlineVariant,
                  width: 1.2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  vertical: Spacing.sm,
                  horizontal: Spacing.sm,
                ),
                child: Row(
                  children: [
                    CalendarRestaurantPickerLogo(
                      type: restaurant.logoType,
                      logoUrl: restaurant.logoUrl,
                      semanticLabel: restaurant.name,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: CalendarRestaurantCopy(restaurant: restaurant),
                    ),
                    const SizedBox(width: Spacing.xs),
                    CalendarRating(
                      value: restaurant.rating,
                      ratingCount: restaurant.ratingCount,
                    ),
                    const SizedBox(width: Spacing.xs),
                    const CalendarArrowBubble(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
