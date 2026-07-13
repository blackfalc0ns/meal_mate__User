part of 'calendar_meal_picker_sheet.dart';

class CalendarMealPickerRestaurantHeader extends StatelessWidget {
  const CalendarMealPickerRestaurantHeader();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CalendarProteinLogo(size: 59.9),
          const SizedBox(width: 18),
          Text(
            locale.calendar_restaurant_name,
            style: getMediumStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 20.8,
              color: color.onSurface,
            ).copyWith(letterSpacing: 0.46),
          ),
          const SizedBox(width: Spacing.base),
          Icon(Icons.verified_user_rounded, color: color.primary, size: 25),
        ],
      ),
    );
  }
}
