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
    final isExhausted = restaurant.isQuotaExhausted ||
        (restaurant.maxUsageCount != null &&
            restaurant.maxUsageCount! > 0 &&
            (restaurant.usedCount ?? 0) >= restaurant.maxUsageCount!);
    final isDisabled = !restaurant.isEnabled || isExhausted;

    return Container(
      constraints: const BoxConstraints(minHeight: 92),
      child: Material(
        color: isDisabled
            ? color.surfaceContainerHighest.withValues(alpha: 0.35)
            : color.surface,
        borderRadius: BorderRadius.circular(15.46),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(15.46),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.46),
              border: Border.all(
                color: isDisabled
                    ? color.outline.withValues(alpha: 0.25)
                    : color.outlineVariant,
                width: 1.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                7.4,
                4.6,
                7.4,
                4.8,
              ),
              child: Row(
                children: [
                  Opacity(
                    opacity: isDisabled ? 0.55 : 1,
                    child: CalendarRestaurantPickerLogo(
                      type: restaurant.logoType,
                      logoUrl: restaurant.logoUrl,
                      semanticLabel: restaurant.name,
                    ),
                  ),
                  const SizedBox(width: 10.5),
                  Expanded(
                    child: CalendarRestaurantCopy(restaurant: restaurant),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Opacity(
                    opacity: isDisabled ? 0.5 : 1,
                    child: CalendarRating(
                      value: restaurant.rating,
                      ratingCount: restaurant.ratingCount,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  CalendarArrowBubble(isLocked: isDisabled),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

