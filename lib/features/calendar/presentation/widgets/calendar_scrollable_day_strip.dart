part of 'calendar_picker_panel.dart';

class CalendarScrollableDayStrip extends StatefulWidget {
  const CalendarScrollableDayStrip({
    required this.controller,
    required this.days,
    required this.onDaySelected,
  });

  final ScrollController controller;
  final List<CalendarDayEntity> days;
  final ValueChanged<CalendarDayEntity> onDaySelected;

  @override
  State<CalendarScrollableDayStrip> createState() =>
      CalendarScrollableDayStripState();
}

class CalendarScrollableDayStripState
    extends State<CalendarScrollableDayStrip> {
  static const _tileWidth = 54.5;
  static const _tileGap = 10.25;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelectedDay());
  }

  @override
  void didUpdateWidget(covariant CalendarScrollableDayStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.days != widget.days) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelectedDay());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: widget.controller,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 5),
      itemCount: widget.days.length,
      separatorBuilder: (_, _) => const SizedBox(width: _tileGap),
      itemBuilder: (context, index) {
        final day = widget.days[index];
        return CalendarDayTile(
          day: day,
          width: _tileWidth,
          height: 71.5,
          onPressed: () {
            widget.onDaySelected(day);
            _centerDay(index);
          },
        );
      },
    );
  }

  void _centerSelectedDay() {
    final index = widget.days.indexWhere((day) => day.isSelected);
    if (index == -1) return;
    _centerDay(index);
  }

  void _centerDay(int index) {
    if (!widget.controller.hasClients) return;

    final viewportWidth = widget.controller.position.viewportDimension;
    final rawOffset =
        index * (_tileWidth + _tileGap) - (viewportWidth - _tileWidth) / 2;
    final targetOffset = rawOffset.clamp(
      widget.controller.position.minScrollExtent,
      widget.controller.position.maxScrollExtent,
    );

    widget.controller.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }
}
