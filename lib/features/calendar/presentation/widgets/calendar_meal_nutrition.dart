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

  String get _formattedValue {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    final parsed = num.tryParse(trimmed);
    if (parsed != null) {
      if (parsed % 1 == 0) {
        return parsed.toInt().toString();
      }
      return parsed.toString();
    }
    return trimmed;
  }

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
              if (animationAsset != null)
                SizedBox.square(
                  dimension: 14,
                  child: Lottie.asset(
                    animationAsset!,
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                )
              else if (icon != null)
                Icon(icon, color: color.primary, size: 12.5),
              const SizedBox(width: 1.5),
              Flexible(
                child: Text(
                  _formattedValue,
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
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurface.withValues(alpha: 0.62),
            )
          ),
        ],
      ),
    );
  }
}
