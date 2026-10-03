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
    final ratingValue = restaurant.rating.isNotEmpty
        ? restaurant.rating
        : '4.8';
    final count = restaurant.ratingCount > 0
        ? '(${restaurant.ratingCount})'
        : '(1.230)';

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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ratingValue,
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
              count,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
