part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantCopy extends StatelessWidget {
  const CalendarRestaurantCopy({super.key, required this.restaurant});

  final CalendarRestaurantOptionEntity restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final tierLogo = restaurant.tierLogoUrl;
    final hasDescription = restaurant.description.trim().isNotEmpty;
    final hasLimit =
        restaurant.maxUsageCount != null && restaurant.maxUsageCount! > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          restaurant.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
        ),
        if (hasDescription) ...[
          const SizedBox(height: Spacing.xxs),
          Text(
            restaurant.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ],
        const SizedBox(height: Spacing.xxs),
        Row(
          children: [
            if (tierLogo != null && tierLogo.isNotEmpty) ...[
              AppCachedNetworkImage(
                imageUrl: tierLogo,
                width: 14,
                height: 14,
                shape: BoxShape.circle,
                semanticLabel: restaurant.tierName,
              ),
              const SizedBox(width: Spacing.xs),
            ],
            Expanded(
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                  children: [
                    if (restaurant.tierName.isNotEmpty)
                      TextSpan(text: '${restaurant.tierName} - '),
                    TextSpan(
                      text: '${restaurant.mealCount}',
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurface,
                      ),
                    ),
                    TextSpan(text: locale.calendar_meal_suffix),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (hasLimit) ...[
          const SizedBox(height: Spacing.xxs),
          _CalendarRestaurantUsageBadge(
            usedCount: restaurant.usedCount ?? 0,
            limit: restaurant.maxUsageCount!,
            isExhausted: restaurant.isQuotaExhausted ||
                ((restaurant.usedCount ?? 0) >= restaurant.maxUsageCount!),
          ),
        ],
      ],
    );
  }
}

class _CalendarRestaurantUsageBadge extends StatelessWidget {
  const _CalendarRestaurantUsageBadge({
    required this.usedCount,
    required this.limit,
    required this.isExhausted,
  });

  final int usedCount;
  final int limit;
  final bool isExhausted;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final badgeColor = isExhausted ? color.error : color.primary;
    final badgeBg = isExhausted
        ? color.error.withValues(alpha: 0.1)
        : color.primary.withValues(alpha: 0.08);
    final badgeBorder = isExhausted
        ? color.error.withValues(alpha: 0.25)
        : color.primary.withValues(alpha: 0.2);

    final text = isExhausted
        ? locale.calendar_restaurant_quota_exhausted(limit)
        : locale.calendar_restaurant_usage_limit(usedCount, limit);

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(6, 2, 6, 2),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(Spacing.radiusPill),
        border: Border.all(color: badgeBorder, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExhausted ? Icons.block_rounded : Icons.repeat_rounded,
            size: 11,
            color: badgeColor,
          ),
          const SizedBox(width: Spacing.xxs),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}

