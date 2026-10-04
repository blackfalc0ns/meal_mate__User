part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantCopy extends StatelessWidget {
  const CalendarRestaurantCopy({super.key, required this.restaurant});

  final CalendarRestaurantOptionEntity restaurant;

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
            color: isDisabled
                ? color.onSurface.withValues(alpha: 0.55)
                : color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xxs),
        Text(
          locale.calendar_restaurant_subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: isDisabled
                ? color.onSurfaceVariant.withValues(alpha: 0.5)
                : color.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.xxs),
        //   if (isExhausted)
        //     Row(
        //       children: [
        //         Icon(Icons.lock_outline_rounded, size: 12, color: color.error),
        //         const SizedBox(width: Spacing.xxs),
        //         Expanded(
        //           child: Text(
        //             locale.calendar_restaurant_quota_exhausted(
        //               restaurant.maxUsageCount ?? 0,
        //             ),
        //             maxLines: 1,
        //             overflow: TextOverflow.ellipsis,
        //             textAlign: TextAlign.start,
        //             style: getMediumStyle(
        //               fontFamily: FontConstant.alexandria,
        //               fontSize: FontSize.size10,
        //               color: color.error,
        //             ),
        //           ),
        //         ),
        //       ],
        //     )
        //  else if (!restaurant.isEnabled)
        //     Row(
        //       children: [
        //         Icon(Icons.block_rounded, size: 12, color: color.error),
        //         const SizedBox(width: Spacing.xxs),
        //         Expanded(
        //           child: Text(
        //             locale.calendar_error_day_unavailable,
        //             maxLines: 1,
        //             overflow: TextOverflow.ellipsis,
        //             textAlign: TextAlign.start,
        //             style: getMediumStyle(
        //               fontFamily: FontConstant.alexandria,
        //               fontSize: FontSize.size10,
        //               color: color.error,
        //             ),
        //           ),
        //         ),
        //       ],
        //     )
        //   else
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          text: TextSpan(
            children: [
              TextSpan(
                text: '${restaurant.mealCount}',
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.primary,
                ),
              ),
              TextSpan(
                text: locale.calendar_meal_suffix,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
