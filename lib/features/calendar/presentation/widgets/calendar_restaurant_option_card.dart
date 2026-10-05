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
    final locale = context.localization;
    final hasLimit =
        restaurant.maxUsageCount != null && restaurant.maxUsageCount! > 0;
    final isExhausted =
        restaurant.isQuotaExhausted ||
        (hasLimit && (restaurant.usedCount ?? 0) >= restaurant.maxUsageCount!);
    final isDisabled = !restaurant.isEnabled || isExhausted;

    return Container(
      constraints: const BoxConstraints(minHeight: 84),
      child: Material(
        color: isDisabled
            ? color.surfaceContainerHighest.withValues(alpha: 0.35)
            : color.surface,
        borderRadius: BorderRadius.circular(Spacing.base),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(Spacing.base),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spacing.base),
              border: Border.all(
                color: isDisabled
                    ? color.outline.withValues(alpha: 0.25)
                    : color.outlineVariant,
                width: 1.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                Spacing.md,
                Spacing.sm,
                Spacing.md,
                Spacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: isDisabled ? 0.55 : 1,
                    child: CalendarRestaurantPickerLogo(
                      type: restaurant.logoType,
                      logoUrl: restaurant.logoUrl,
                      semanticLabel: restaurant.name,
                      size: 64,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: CalendarRestaurantCopy(restaurant: restaurant),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (hasLimit) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isExhausted
                                ? color.error.withValues(alpha: 0.1)
                                : color.surfaceContainerHighest.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(Spacing.sm),
                            border: Border.all(
                              color: isExhausted
                                  ? color.error.withValues(alpha: 0.3)
                                  : color.outlineVariant.withValues(alpha: 0.45),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isExhausted) ...[
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 12,
                                  color: color.error,
                                ),
                                const SizedBox(width: Spacing.xxs),
                                Text(
                                  locale
                                      .calendar_restaurant_quota_exhausted_badge(
                                        restaurant.maxUsageCount!,
                                      ),
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size11,
                                    color: color.error,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  '${locale.calendar_restaurant_repetition_prefix} ',
                                  style: getMediumStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size11,
                                    color: color.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '${restaurant.usedCount ?? 0}',
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size12,
                                    color: color.primary,
                                  ),
                                ),
                                Text(
                                  ' / ',
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size12,
                                    color: color.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '${restaurant.maxUsageCount}',
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size12,
                                    color: color.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                      ],

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Opacity(
                            opacity: isDisabled ? 0.5 : 1,
                            child: CalendarRating(
                              value: restaurant.rating,
                              ratingCount: restaurant.ratingCount,
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          CalendarArrowBubble(isLocked: isDisabled),
                        ],
                      ),
                    ],
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
