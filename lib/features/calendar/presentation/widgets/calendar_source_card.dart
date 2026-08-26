part of 'calendar_meal_picker_sheet.dart';

class CalendarSourceCard extends StatelessWidget {
  const CalendarSourceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.country,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String country;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: Spacing.restaurantDetailsSourceCardWidth,
      height: Spacing.restaurantDetailsSourceCardHeight,
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.hairline,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: Spacing.iconMd - Spacing.xs, color: color.primary),
          const SizedBox(height: Spacing.xs),
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.primary,
            ).copyWith(height: 1),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            subtitle,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurface,
            ).copyWith(height: 1),
          ),
          const Spacer(),
          Container(
            height: Spacing.base,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
            decoration: BoxDecoration(
              color: color.primaryContainer,
              borderRadius: BorderRadius.circular(Spacing.radiusXs),
            ),
            child: Center(
              child: Text(
                country,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: color.onSurface,
                ).copyWith(height: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
