part of 'calendar_meal_picker_sheet.dart';

class CalendarTabLabel extends StatelessWidget {
  const CalendarTabLabel({
    required this.text,
    required this.active,
    required this.onTap,
  });

  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusSm),
      child: SizedBox(
        width: 100,
        height: 26.3,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            textAlign: TextAlign.center,
            style: getMediumStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 13.52,
              color: active ? color.primary : color.onSurface,
            ).copyWith(height: 12.48 / 13.52, letterSpacing: 0),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
