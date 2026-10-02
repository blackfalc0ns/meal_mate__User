part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantCopy extends StatelessWidget {
  const CalendarRestaurantCopy({super.key, required this.restaurant});

  final CalendarRestaurantOptionEntity restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final tierLogo = restaurant.tierLogoUrl;

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
          ).copyWith(letterSpacing: 0),
        ),
        const SizedBox(height: 1.8),
        Text(
          restaurant.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onSurface.withValues(alpha: 0.62),
          ).copyWith(letterSpacing: 0),
        ),
        const SizedBox(height: 1.8),
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
                  ).copyWith(letterSpacing: 0),
                  children: [
                    if (restaurant.tierName.isNotEmpty)
                      TextSpan(text: '${restaurant.tierName} - '),
                    TextSpan(
                      text: '${restaurant.mealCount}',
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: 10.96,
                        color: color.onSurface,
                      ).copyWith(letterSpacing: 0),
                    ),
                    TextSpan(text: locale.calendar_meal_suffix),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
