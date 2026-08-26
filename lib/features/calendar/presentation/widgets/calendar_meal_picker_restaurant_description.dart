part of 'calendar_meal_picker_sheet.dart';

class CalendarMealPickerRestaurantDescription extends StatelessWidget {
  const CalendarMealPickerRestaurantDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Text(
      locale.calendar_restaurant_description,
      textAlign: TextAlign.start,
      style: getRegularStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size12,
        color: color.onSurface.withValues(alpha: 0.62),
      ).copyWith(height: 1.7),
    );
  }
}
