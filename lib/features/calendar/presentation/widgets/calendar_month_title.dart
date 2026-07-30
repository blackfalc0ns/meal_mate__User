part of 'calendar_picker_panel.dart';

class CalendarMonthTitle extends StatelessWidget {
  const CalendarMonthTitle({required this.monthTitle});

  final String monthTitle;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final parts = monthTitle.split(' ');
    final month = parts.isNotEmpty ? parts.first : monthTitle;
    final year = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return RichText(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: 26,
          color: color.onSurface,
        ).copyWith(height: 1),
        children: [
          TextSpan(
            text: month,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: 26,
              color: color.primary,
            ).copyWith(height: 1),
          ),
          if (year.isNotEmpty) TextSpan(text: ' $year'),
        ],
      ),
    );
  }
}
