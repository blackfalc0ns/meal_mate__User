part of 'calendar_meal_picker_sheet.dart';

class CalendarSourceCard extends StatelessWidget {
  const CalendarSourceCard({
    super.key,
    required this.icon,
    this.iconUrl,
    required this.title,
    required this.subtitle,
    required this.country,
  });

  final IconData icon;
  final String? iconUrl;
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
          if (iconUrl == null || iconUrl!.isEmpty)
            Icon(icon, size: Spacing.iconMd - Spacing.xs, color: color.primary)
          else
            AppCachedNetworkImage(
              imageUrl: iconUrl,
              width: Spacing.iconMd - Spacing.xs,
              height: Spacing.iconMd - Spacing.xs,
              fit: BoxFit.contain,
              semanticLabel: title,
            ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.primary,
                  ).copyWith(height: 1),
                ),
               
              ],
            ),
          ),
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
