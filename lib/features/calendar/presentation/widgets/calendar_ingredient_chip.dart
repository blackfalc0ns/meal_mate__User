part of 'calendar_meal_card.dart';

class CalendarMealCardIngredientChip extends StatelessWidget {
  const CalendarMealCardIngredientChip({super.key, required this.ingredient});

  final CalendarMealIngredientEntity ingredient;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isMore = ingredient.label == locale.calendar_more;

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
            SizedBox(
              width: 10,
              height: 10,
              child: ClipOval(
                child: ingredient.iconUrl == null || ingredient.iconUrl!.isEmpty
                    ? Image.asset(ingredient.asset, fit: BoxFit.cover)
                    : AppCachedNetworkImage(
                        imageUrl: ingredient.iconUrl!,
                        fit: BoxFit.cover,
                        semanticLabel: ingredient.label,
                      ),
              ),
            ),
            const SizedBox(width: 2),
          ],
          Flexible(
            child: Text(
              ingredient.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
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
}
