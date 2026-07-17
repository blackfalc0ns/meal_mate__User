part of 'calendar_picker_panel.dart';

class CalendarDayTile extends StatelessWidget {
  const CalendarDayTile({
    super.key,
    required this.day,
    required this.onPressed,
    this.width,
    this.height,
    this.compact = false,
  });

  final CalendarDayEntity day;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final selected = day.isSelected;
    final textColor = selected
        ? color.onPrimary
        : day.isMuted
        ? color.onSurface.withValues(alpha: 0.25)
        : color.onSurface;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: selected
            ? color.primary
            : compact
            ? color.surface.withValues(alpha: 0)
            : color.surface,
        borderRadius: BorderRadius.circular(compact ? 14 : 12),
        elevation: compact || selected ? 0 : 2,
        shadowColor: color.shadow.withValues(alpha: 0.04),
        child: InkWell(
          borderRadius: BorderRadius.circular(compact ? 14 : 12),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: compact ? 4 : 5,
              horizontal: 4,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.dayNumber}',
                  style:
                      getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: compact ? 16 : (selected ? 17 : 14),
                        color: textColor,
                      ).copyWith(
                        height: 1,
                        fontWeight: compact && selected
                            ? FontWeight.w600
                            : FontWeight.w700,
                      ),
                ),
                if (!compact) ...[
                  SizedBox(height: selected ? 5 : 6),
                  Text(
                    day.weekday,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (selected
                                ? getMediumStyle(
                                    fontFamily: FontConstant.ibmPlexSansArabic,
                                    fontSize: FontSize.size10,
                                    color: textColor,
                                  )
                                : getRegularStyle(
                                    fontFamily: FontConstant.ibmPlexSansArabic,
                                    fontSize: FontSize.size10,
                                    color: textColor,
                                  ))
                            .copyWith(height: 1),
                  ),
                ],
                SizedBox(height: compact ? 4 : (selected ? 5 : 4)),
                if (!compact)
                  CalendarDayMealIndicator(
                    selected: selected,
                    muted: day.isMuted,
                    compact: compact,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
