part of 'calendar_restaurant_summary_card.dart';

class CalendarMetaChip extends StatelessWidget {
  const CalendarMetaChip({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    this.badgeColor,
    this.imageUrl,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color? badgeColor;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (badgeColor == null)
          Text(
            label,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onPrimary,
            ),
          )
        else
          DecoratedBox(
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(Spacing.radiusXs),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
              child: Text(
                label,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onPrimary,
                ),
              ),
            ),
          ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryMetaGap),
        if (imageUrl?.isNotEmpty == true)
          AppCachedNetworkImage(
            width: 25,
            height: 25,
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          )
        else
          Icon(
            icon,
            color: iconColor,
            size: badgeColor == null ? FontSize.size11 : FontSize.size10,
          ),
      ],
    );
  }
}
