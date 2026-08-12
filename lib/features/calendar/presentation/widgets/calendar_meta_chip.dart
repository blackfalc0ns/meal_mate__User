part of 'calendar_restaurant_summary_card.dart';

class CalendarMetaChip extends StatelessWidget {
  const CalendarMetaChip({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    this.badgeColor,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color? badgeColor;

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
                fontSize: FontSize.size9,
                color: color.onPrimary,
              ),
            ),
          ),
        const SizedBox(width: 2),
        Icon(
          icon,
          color: iconColor,
          size: badgeColor == null ? FontSize.size11 : FontSize.size9,
        ),
      ],
    );
  }
}
