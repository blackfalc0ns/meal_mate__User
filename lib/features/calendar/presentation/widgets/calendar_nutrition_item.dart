part of 'calendar_meal_card.dart';

class _NutritionItem extends StatelessWidget {
  const _NutritionItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: label == locale.calendar_calories ? 48 : 34,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 10.5, color: color.primary),
              const SizedBox(width: 1.5),
              FittedBox(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size7,
                    color: color.onSurface,
                  ).copyWith(height: 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 6.1,
              color: color.onSurface.withValues(alpha: 0.62),
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
