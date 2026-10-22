import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';

class CalendarDeadlineBuilder extends StatefulWidget {
  const CalendarDeadlineBuilder({
    required this.day,
    required this.builder,
    super.key,
  });
  final CalendarDayEntity? day;
  final WidgetBuilder builder;

  @override
  State<CalendarDeadlineBuilder> createState() =>
      _CalendarDeadlineBuilderState();
}

class _CalendarDeadlineBuilderState extends State<CalendarDeadlineBuilder> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(CalendarDeadlineBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day != widget.day) _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    final now = widget.day?.operationalClock?.now;
    if (now == null) return;
    final deadlines =
        [
              widget.day?.mealSelectionClosesAt,
              widget.day?.addressEditClosesAt,
              widget.day?.freezeClosesAt,
            ]
            .whereType<DateTime>()
            .where((deadline) => deadline.isAfter(now))
            .toList()
          ..sort();
    if (deadlines.isEmpty) return;
    _timer = Timer(deadlines.first.difference(now), () {
      if (!mounted) return;
      setState(() {});
      _schedule();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
