part of 'calendar_picker_panel.dart';

class CalendarScrollableDayStrip extends StatefulWidget {
  const CalendarScrollableDayStrip({
    super.key,
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

class CalendarScrollableDayStripState extends State<CalendarScrollableDayStrip>
    with SingleTickerProviderStateMixin {
  static const _tileWidth = 46.0;
  static const _tileGap = 8.0;

  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    unawaited(_staggerController.forward());
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelectedDay());
  }

  @override
  void didUpdateWidget(covariant CalendarScrollableDayStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isStructuralChange =
        oldWidget.days.length != widget.days.length ||
        (oldWidget.days.isNotEmpty &&
            widget.days.isNotEmpty &&
            oldWidget.days.first.date != widget.days.first.date);
    if (isStructuralChange) {
      unawaited(_staggerController.forward(from: 0.0));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelectedDay());
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.days.length;

    return ListView.separated(
      controller: widget.controller,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: widget.days.length,
      separatorBuilder: (_, _) => const SizedBox(width: _tileGap),
      itemBuilder: (context, index) {
        final day = widget.days[index];
        final start = (index / (total > 0 ? total : 1) * 0.45).clamp(0.0, 0.6);
        final end = (start + 0.4).clamp(0.0, 1.0);
        final tileAnimation = CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        );

        return FadeScaleTransition(
          animation: tileAnimation,
          child: CalendarDayTile(
            day: day,
            width: _tileWidth,
            height: 59.0,
            onPressed: () {
              widget.onDaySelected(day);
              _centerDay(index);
            },
          ),
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

    unawaited(
      widget.controller.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      ),
    );
  }
}
