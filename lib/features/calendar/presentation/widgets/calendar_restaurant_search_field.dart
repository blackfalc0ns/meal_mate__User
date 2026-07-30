part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantSearchField extends StatelessWidget {
  const CalendarRestaurantSearchField();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: 35,
      padding: const EdgeInsetsDirectional.fromSTEB(13, 0, 13, 0),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(17.5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: color.onSurface.withValues(alpha: 0.62),
            size: 22,
          ),
          Expanded(
            child: Text(
              locale.calendar_search_restaurant_hint,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: 13,
                color: color.onSurface.withValues(alpha: 0.62),
              ).copyWith(height: 20 / 13),
            ),
          ),
          const SizedBox(width: 22),
        ],
      ),
    );
  }
}
