part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRestaurantSearchField extends StatelessWidget {
  const CalendarRestaurantSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: 35,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(17.5),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 13),
          child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: color.onSurface.withValues(alpha: 0.62),
            size: 22,
          ),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: 13,
                color: color.onSurface,
              ).copyWith(height: 20 / 13),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: locale.calendar_search_restaurant_hint,
                hintStyle: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: 13,
                  color: color.onSurface.withValues(alpha: 0.62),
                ).copyWith(height: 20 / 13),
              ),
            ),
          ),
              const SizedBox(width: 22),
            ],
          ),
        ),
      ),
    );
  }
}
