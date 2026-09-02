part of 'restaurant_menu_view.dart';

class RestaurantMenuIngredientChip extends StatelessWidget {
  const RestaurantMenuIngredientChip({
    super.key,
    required this.label,
    this.iconUrl,
  });

  final String label;
  final String? iconUrl;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isMore = label == locale.calendar_more;

    return Container(
      margin: const EdgeInsetsDirectional.only(start: 1.5),
      height: Spacing.lg,
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
            if (iconUrl == null || iconUrl!.isEmpty)
              Icon(_iconFor(label, locale), color: color.primary, size: 10)
            else
              AppCachedNetworkImage(
                imageUrl: iconUrl,
                width: 10,
                height: 10,
                fit: BoxFit.contain,
                semanticLabel: label,
              ),
            const SizedBox(width: 3.35),
          ],
          Text(
            label,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
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
