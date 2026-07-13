part of 'calendar_restaurant_summary_card.dart';

class CalendarRestaurantTextBlock extends StatelessWidget {
  const CalendarRestaurantTextBlock({required this.restaurant});

  final CalendarRestaurantEntity restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.verified_rounded, color: color.onPrimary, size: 13),
              const SizedBox(width: Spacing.xs),
              Text(
                restaurant.name,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: 11.7,
                  color: color.onPrimary,
                ).copyWith(letterSpacing: 0),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            restaurant.category,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 8.5,
              color: color.onPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CalendarMetaChip(
                icon: Icons.star_rounded,
                label: restaurant.rating,
              ),
              const SizedBox(width: 10),
              CalendarMetaChip(
                icon: Icons.access_time_rounded,
                label: restaurant.deliveryDuration,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            restaurant.deliveryWindow,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 8.5,
              color: color.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
