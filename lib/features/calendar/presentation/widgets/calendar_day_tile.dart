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
    final isFrozen = day.isFrozen;
    final textColor = selected && !isFrozen
        ? color.onPrimary
        : isFrozen
            ? color.onSurface
            : day.isMuted
                ? color.onSurface.withValues(alpha: 0.25)
                : color.onSurface;

    final backgroundColor = isFrozen
        ? const Color(0xFFEBF5FA)
        : selected
            ? color.primary
            : compact
                ? color.surface.withValues(alpha: 0)
                : color.surface;

    final borderRadius = BorderRadius.circular(compact ? 14 : 12);

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: borderRadius,
        elevation: compact || selected || isFrozen ? 0 : 2,
        shadowColor: color.shadow.withValues(alpha: 0.04),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: isFrozen && selected
                ? Border.all(color: const Color(0xFF4A9AC2), width: 1.5)
                : null,
          ),
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: compact ? 4 : 3,
                horizontal: 4,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${day.dayNumber}',
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
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
                    const SizedBox(height: 3),
                    Text(
                      day.weekday,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (selected && !isFrozen
                              ? getMediumStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size10,
                                  color: textColor,
                                )
                              : getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size10,
                                  color: textColor,
                                ))
                          .copyWith(height: 1),
                    ),
                  ],
                  SizedBox(height: compact ? 4 : (selected ? 4 : 3)),
                  if (!compact)
                    isFrozen
                        ? SvgPicture.asset(
                            Assets.calendarSnowflake,
                            width: 11,
                            height: 11,
                          )
                        : CalendarDayMealIndicator(
                            selected: selected,
                            muted: day.isMuted,
                            compact: compact,
                          ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
