part of 'calendar_meal_picker_sheet.dart';

class CalendarMealPickerNutrition extends StatelessWidget {
  const CalendarMealPickerNutrition({
    super.key,
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
      width: label == locale.calendar_calories ? 38 : 31,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color.primary, size: 12.5),
              const SizedBox(width: 1.5),
              Flexible(
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
          const SizedBox(height: 1),
          FittedBox(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size10,
                color: color.onSurface.withValues(alpha: 0.62),
              ).copyWith(height: 1),
            ),
          ),
        ],
      ),
    );
  }
}
