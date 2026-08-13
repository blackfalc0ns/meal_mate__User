part of 'calendar_restaurant_summary_card.dart';

class CalendarRestaurantTextBlock extends StatelessWidget {
  const CalendarRestaurantTextBlock({super.key, required this.restaurant});

  final CalendarRestaurantEntity restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Directionality(
      textDirection: Directionality.of(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  restaurant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size16,
                    color: color.onPrimary,
                  ).copyWith(height: 1.1),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Icon(Icons.verified_rounded, color: color.onPrimary, size: 15),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              CalendarMetaChip(
                icon: Icons.star_rounded,
                label: restaurant.deliveryDuration,
                iconColor: color.onPrimary,
              ),
              const SizedBox(width: Spacing.xs),
              CalendarMetaChip(
                icon: Icons.circle,
                label: restaurant.rating,
                iconColor: color.onPrimary,
                badgeColor: color.secondary,
              ),
              const SizedBox(width: Spacing.xs),
              Flexible(
                child: Text(
                  restaurant.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            restaurant.deliveryWindow,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
