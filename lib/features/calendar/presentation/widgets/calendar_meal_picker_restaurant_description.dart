part of 'calendar_meal_picker_sheet.dart';

class CalendarMealPickerRestaurantDescription extends StatelessWidget {
  const CalendarMealPickerRestaurantDescription();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 31, end: 88),
      child: Text(
        locale.calendar_restaurant_description,
        textAlign: TextAlign.right,
        style: getRegularStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: 12,
          color: color.onSurface.withValues(alpha: 0.62),
        ).copyWith(height: 20 / 12),
      ),
    );
  }
}
