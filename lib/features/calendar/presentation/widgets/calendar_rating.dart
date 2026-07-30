part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRating extends StatelessWidget {
  const CalendarRating({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: 38,
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: color.primary, size: 13),
          const SizedBox(width: Spacing.xs),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: 10.96,
              color: color.onSurface,
            ).copyWith(letterSpacing: 0),
          ),
        ],
      ),
    );
  }
}
