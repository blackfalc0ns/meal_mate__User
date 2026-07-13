part of 'calendar_picker_panel.dart';

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.controller,
    required this.days,
    required this.onDaySelected,
  });

  final ScrollController controller;
  final List<CalendarDayEntity> days;
  final ValueChanged<CalendarDayEntity> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 81,
      child: _ScrollableDayStrip(
        controller: controller,
        days: days,
        onDaySelected: onDaySelected,
      ),
    );
  }
}
