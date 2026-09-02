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
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(Spacing.radiusXs),
            ),
            child: Text(
              label,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onPrimary,
              ),
            ),
          ),
        const SizedBox(width: Spacing.calendarRestaurantSummaryMetaGap),
        if (imageUrl?.isNotEmpty == true)
          AppCachedNetworkImage(width:25,height:25,
             imageUrl: imageUrl!,
            // width: badgeColor == null ? FontSize.size11 : FontSize.size10,
            // height: badgeColor == null ? FontSize.size11 : FontSize.size10,
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
