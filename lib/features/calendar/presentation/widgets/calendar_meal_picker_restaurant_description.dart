part of 'calendar_meal_picker_sheet.dart';

class CalendarMealPickerRestaurantDescription extends StatelessWidget {
  const CalendarMealPickerRestaurantDescription();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 88.0, end: 28.0),
      child: Text(
        locale.calendar_restaurant_description,

        style: getRegularStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: 12,
          color: color.onSurface.withValues(alpha: 0.62),
        ).copyWith(height: 20 / 12),
      ),
    );
  }
}
