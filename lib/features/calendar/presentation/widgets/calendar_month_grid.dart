part of 'calendar_picker_panel.dart';

class CalendarMonthGrid extends StatefulWidget {
  const CalendarMonthGrid({
    super.key,
    required this.days,
    required this.onDaySelected,
  });

  final List<CalendarDayEntity> days;
  final ValueChanged<CalendarDayEntity> onDaySelected;

  @override
  State<CalendarMonthGrid> createState() => _CalendarMonthGridState();
}

class _CalendarMonthGridState extends State<CalendarMonthGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    unawaited(_staggerController.forward());
  }

  @override
  void didUpdateWidget(covariant CalendarMonthGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.days != widget.days) {
      unawaited(_staggerController.forward(from: 0.0));
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final weekdays = [
      locale.calendar_weekday_sat_short,
      locale.calendar_weekday_sun_short,
      locale.calendar_weekday_mon_short,
      locale.calendar_weekday_tue_short,
      locale.calendar_weekday_wed_short,
      locale.calendar_weekday_thu_short,
      locale.calendar_weekday_fri_short,
    ];
    final totalDays = widget.days.length;

    return SizedBox(
      key: const ValueKey('month-grid'),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weekdays.length + widget.days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < weekdays.length) {
              return FadeScaleTransition(
                animation: CurvedAnimation(
                  parent: _staggerController,
                  curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
                ),
                child: CalendarMonthWeekdayLabel(label: weekdays[index]),
              );
            }

            final dayIndex = index - weekdays.length;
            final day = widget.days[dayIndex];
            final start =
                (dayIndex / (totalDays > 0 ? totalDays : 1) * 0.45).clamp(0.0, 0.6);
            final end = (start + 0.35).clamp(0.0, 1.0);
            final tileAnimation = CurvedAnimation(
              parent: _staggerController,
              curve: Interval(start, end, curve: Curves.easeOutCubic),
            );

            return FadeScaleTransition(
              animation: tileAnimation,
              child: CalendarDayTile(
                day: day,
                compact: true,
                onPressed: () => widget.onDaySelected(day),
              ),
            );
          },
        ),
    );
  }
}
