part of 'calendar_meal_picker_sheet.dart';

class CalendarMealPickerIngredientChip extends StatelessWidget {
  const CalendarMealPickerIngredientChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isMore = label == locale.calendar_more;

    return Container(
      margin: const EdgeInsetsDirectional.only(start: 1.5),
      height: 14.25,
      constraints: BoxConstraints(minWidth: isMore ? 27.7 : 33.55),
      padding: const EdgeInsets.symmetric(horizontal: 4.2, vertical: 2.5),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(7.13),
        border: Border.all(color: color.primary, width: 0.42),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMore) ...[
            Icon(_iconFor(label, locale), color: color.primary, size: 8.4),
            const SizedBox(width: 3.35),
          ],
          Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 5.03,
              color: isMore
                  ? color.onSurface
                  : color.onSurface.withValues(alpha: 0.62),
            ).copyWith(height: 1),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String label, AppLocalizations locale) {
    if (label == locale.calendar_grilled_chicken) {
      return Icons.set_meal_rounded;
    }
    if (label == locale.calendar_brown_rice) {
      return Icons.rice_bowl_rounded;
    }
    if (label == locale.calendar_broccoli) {
      return Icons.spa_rounded;
    }
    return Icons.eco_rounded;
  }
}
