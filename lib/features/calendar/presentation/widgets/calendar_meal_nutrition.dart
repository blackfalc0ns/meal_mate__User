part of 'calendar_meal_picker_sheet.dart';

class CalendarMealPickerNutrition extends StatelessWidget {
  const CalendarMealPickerNutrition({
    super.key,
    this.icon,
    this.animationAsset,
    required this.value,
    required this.label,
  });

  final IconData? icon;
  final String? animationAsset;
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
              Lottie.asset(
                width: 30,
                height: 30,
                animationAsset!,
                fit: BoxFit.contain,
                repeat: true,
              ),
              const SizedBox(width: 1.5),
              Flexible(
                child: Text(
                  value.formattedValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurface,
                  ).copyWith(height: 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.onSurface.withValues(alpha: 0.62),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
