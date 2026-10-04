part of 'calendar_picker_panel.dart';

class CalendarMonthGrid extends StatelessWidget {
  const CalendarMonthGrid({
    super.key,
    required this.days,
    required this.onDaySelected,
  });

  final List<CalendarDayEntity> days;
  final ValueChanged<CalendarDayEntity> onDaySelected;

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

    return Column(
      key: const ValueKey('month-grid'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Spacing.xs),
          child: SizedBox(
            height: 22,
            child: Row(
              children: List.generate(weekdays.length, (index) {
                return Expanded(
                  child: CalendarMonthWeekdayLabel(label: weekdays[index]),
                );
              }),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: Spacing.xss,
            crossAxisSpacing: Spacing.sm,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (context, index) {
            final day = days[index];

            return CalendarDayTile(
              day: day,
              compact: true,
              onPressed: () => onDaySelected(day),
            );
          },
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 220.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.04,
          end: 0,
          duration: 220.ms,
          curve: Curves.easeOut,
        );
  }
}
