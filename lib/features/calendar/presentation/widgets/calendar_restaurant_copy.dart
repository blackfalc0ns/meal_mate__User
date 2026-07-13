part of 'calendar_restaurant_picker_sheet.dart';

class _RestaurantCopy extends StatelessWidget {
  const _RestaurantCopy({required this.restaurant});

  final CalendarRestaurantOptionEntity restaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            restaurant.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 11.79,
              color: color.onSurface,
            ).copyWith(letterSpacing: 0),
          ),
          const SizedBox(height: 1.8),
          Text(
            restaurant.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: getRegularStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 8.5,
              color: color.onSurface.withValues(alpha: 0.62),
            ).copyWith(letterSpacing: 0),
          ),
          const SizedBox(height: 1.8),
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: getRegularStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: 10.96,
                color: color.onSurface,
              ).copyWith(letterSpacing: 0),
              children: [
                TextSpan(
                  text: '${restaurant.mealCount}',
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 10.96,
                    color: color.onSurface,
                  ).copyWith(letterSpacing: 0),
                ),
                TextSpan(text: locale.calendar_meal_suffix),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
