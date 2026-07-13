part of 'calendar_restaurant_summary_card.dart';

class _RestaurantLogo extends StatelessWidget {
  const _RestaurantLogo();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: 58,
      height: 54,
      decoration: BoxDecoration(color: color.surface, shape: BoxShape.circle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.ramen_dining_rounded, color: color.primary, size: 22),
          Text(
            'HEALTHY',
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 7.5,
              color: color.primary,
            ).copyWith(height: 1),
          ),
          Text(
            'BOWL',
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 7.5,
              color: color.primary,
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
