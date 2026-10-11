part of 'calendar_restaurant_picker_sheet.dart';

class CalendarRating extends StatelessWidget {
  const CalendarRating({super.key, this.value, required this.ratingCount});

  final String? value;
  final int ratingCount;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final ratingDouble = value != null ? double.tryParse(value!) : null;
    final showRating =
        ratingDouble != null && ratingDouble > 0 && ratingCount > 0;

    if (!showRating) {
      return Text(
        locale.calendar_restaurant_no_reviews,
        style: getRegularStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size11,
          color: color.onSurfaceVariant,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value!,
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
