part of 'calendar_meal_card.dart';

class CalendarMealTypeBadge extends StatelessWidget {
  const CalendarMealTypeBadge({super.key, required this.mealType});

  final String mealType;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          mealType,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.primary,
          ),
        ),
        const SizedBox(width: Spacing.xss),
        Icon(
          _iconForMealType(mealType),
          color: color.primary,
          size: Spacing.iconXs,
        ),
      ],
    );
  }

  IconData _iconForMealType(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('break') || lower.contains('فطور')) {
      return Icons.wb_sunny_rounded;
    }
    if (lower.contains('lunch') || lower.contains('غداء')) {
      return Icons.restaurant_rounded;
    }
    if (lower.contains('dinner') || lower.contains('عشاء')) {
      return Icons.nightlight_round;
    }
    return Icons.restaurant_menu_rounded;
  }
}
