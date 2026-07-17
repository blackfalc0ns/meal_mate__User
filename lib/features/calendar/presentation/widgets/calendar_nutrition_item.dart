part of 'calendar_meal_card.dart';

class CalendarMealCardNutritionItem extends StatelessWidget {
  const CalendarMealCardNutritionItem({
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
      width: label == locale.calendar_calories ? 54 : 44,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: color.primary),
              const SizedBox(width: 1.5),
              FittedBox(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size10,
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
              fontSize: FontSize.size9,
              color: color.onSurface.withValues(alpha: 0.62),
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }
}
