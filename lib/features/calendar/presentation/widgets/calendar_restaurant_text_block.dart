part of 'calendar_restaurant_summary_card.dart';

class CalendarRestaurantTextBlock extends StatelessWidget {
  const CalendarRestaurantTextBlock({super.key, required this.restaurant});

  final CalendarRestaurantEntity restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final restaurantName = restaurant.name.isNotEmpty
        ? restaurant.name
        : 'DIET HOUSE';
    final ratingStr = restaurant.rating;
    final ratingDouble =
        ratingStr != null ? double.tryParse(ratingStr) : null;
    final hasValidRating =
        ratingDouble != null &&
        ratingDouble > 0 &&
        restaurant.ratingCount > 0;
    final locale = context.localization;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurantName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size14,
            color: color.onPrimary,
          ),
        ),
        const SizedBox(height: 2),
        if (hasValidRating)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ratingStr!,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onPrimary,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.star_rounded,
                color: color.secondary,
                size: Spacing.iconSm - 2,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                '(${restaurant.ratingCount})',
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          )
        else
          Text(
            locale.calendar_restaurant_no_reviews,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onPrimary.withValues(alpha: 0.85),
            ),
          ),
      ],
    );
  }
}
