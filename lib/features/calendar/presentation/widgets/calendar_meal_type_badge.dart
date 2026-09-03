part of 'calendar_meal_card.dart';

class CalendarMealTypeBadge extends StatelessWidget {
  const CalendarMealTypeBadge({super.key, required this.mealType});

  final String mealType;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,

      children: [
        Text(
          mealType,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.primary,
          ),
        ),
        const SizedBox(width: 2),
        Icon(Icons.wb_sunny_rounded, color: color.primary, size: 13),
      ],
    );
  }
}
