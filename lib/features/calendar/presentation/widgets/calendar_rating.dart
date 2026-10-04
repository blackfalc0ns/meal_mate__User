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

    if (!showRating) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
        ),
        const SizedBox(width: Spacing.xxs),
        Icon(Icons.star_rounded, color: color.primary, size: 15),
      ],
    );
  }
}
