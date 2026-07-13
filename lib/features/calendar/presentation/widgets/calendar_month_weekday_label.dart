part of 'calendar_picker_panel.dart';

class CalendarMonthWeekdayLabel extends StatelessWidget {
  const CalendarMonthWeekdayLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Center(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: getLightStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: 16,
          color: color.onSurface.withValues(alpha: 0.4),
        ).copyWith(height: 1),
      ),
    );
  }
}
