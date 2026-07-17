part of 'calendar_meal_card.dart';

class CalendarMealCardIngredientChip extends StatelessWidget {
  const CalendarMealCardIngredientChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isMore = label == locale.calendar_more;

    return Container(
      height: Spacing.lg,
      constraints: BoxConstraints(
        minWidth: isMore ? 28.6 : 30,
        maxWidth: isMore ? 42 : 58,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(7.4),
        border: Border.all(color: color.primary, width: 0.45),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isMore) ...[
            Icon(
              _ingredientIcon(label, locale),
              size: 10,
              color: color.primary,
            ),
            const SizedBox(width: 2),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size10,
                color: isMore
                    ? color.onSurface
                    : color.onSurface.withValues(alpha: 0.62),
              ).copyWith(height: 1),
            ),
          ),
        ],
      ),
    );
  }

  IconData _ingredientIcon(String label, AppLocalizations locale) {
    if (label == locale.calendar_carrot) {
      return Icons.eco_rounded;
    }
    if (label == locale.calendar_broccoli) {
      return Icons.spa_rounded;
    }
    return Icons.rice_bowl_rounded;
  }
}
