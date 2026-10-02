part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRating extends StatelessWidget {
  const CalendarRating({
    super.key,
    required this.value,
    required this.ratingCount,
  });

  final String value;
  final int ratingCount;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final showRating = value.trim().isNotEmpty;

    return SizedBox(
      width: 38,
      child: showRating
          ? Row(
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
            )
          : const SizedBox.shrink(),
    );
  }
}
