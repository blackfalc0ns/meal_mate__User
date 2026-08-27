import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
part 'calendar_month_title.dart';
part 'calendar_month_arrow_button.dart';
part 'calendar_week_strip.dart';
part 'calendar_scrollable_day_strip.dart';
part 'calendar_month_grid.dart';
part 'calendar_month_weekday_label.dart';
part 'calendar_day_tile.dart';
part 'calendar_day_meal_indicator.dart';

class CalendarPickerPanel extends StatefulWidget {
  const CalendarPickerPanel({
    super.key,
    required this.monthTitle,
    required this.days,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onMonthChanged,
    required this.onDaySelected,
  });

  final String monthTitle;
  final List<CalendarDayEntity> days;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<CalendarDayEntity> onDaySelected;

  @override
  State<CalendarPickerPanel> createState() => CalendarPickerPanelState();
}

class CalendarPickerPanelState extends State<CalendarPickerPanel> {
  static const _weekScrollStep = 54.0;

  late final ScrollController _weekController;
  bool _calendarGripDragHandled = false;
  double _calendarGripDragDistance = 0;

  @override
  void initState() {
    super.initState();
    _weekController = ScrollController();
  }

  @override
  void dispose() {
    _weekController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: AnimatedSize(
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 620),
        reverseDuration: const Duration(milliseconds: 560),
        curve: Curves.easeInOutCubic,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.lg),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest,
                  border: Border(
                    bottom: BorderSide(color: color.outlineVariant),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Spacing.sm,
                        horizontal: Spacing.screenH,
                      ),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: SizedBox(
                          height: 42,
                          child: Row(
                            children: [
                              CalendarMonthArrowButton(
                                icon: Icons.chevron_left_rounded,
                                onPressed: () => _handleMonthArrow(-1),
                              ),
                              const Spacer(),
                              CalendarMonthTitle(monthTitle: widget.monthTitle),
                              const Spacer(),
                              CalendarMonthArrowButton(
                                icon: Icons.chevron_right_rounded,
                                onPressed: () => _handleMonthArrow(1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 520),
                      curve: Curves.easeInOutCubic,
                      height: widget.isExpanded ? 6 : 1,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 520),
                      reverseDuration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInOutCubic,
                      transitionBuilder: (child, animation) {
                        final slide = Tween<Offset>(
                          begin: const Offset(0, -0.035),
                          end: Offset.zero,
                        ).animate(animation);

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: slide,
                            child: AnimatedBuilder(
                              animation: animation,
                              child: child,
                              builder: (context, child) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  heightFactor: animation.value,
                                  child: child,
                                );
                              },
                            ),
                          ),
                        );
                      },
                      layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                          alignment: Alignment.topCenter,
                          children: [...previousChildren, ?currentChild],
                        );
                      },
                      child: AnimatedPadding(
                        key: ValueKey(widget.isExpanded),
                        duration: const Duration(milliseconds: 520),
                        curve: Curves.easeInOutCubic,
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.isExpanded ? 18 : 31,
                        ),
                        child: widget.isExpanded
                            ? CalendarMonthGrid(
                                days: widget.days,
                                onDaySelected: widget.onDaySelected,
                              )
                            : CalendarWeekStrip(
                                controller: _weekController,
                                days: widget.days,
                                onDaySelected: widget.onDaySelected,
                              ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 520),
                      curve: Curves.easeInOutCubic,
                      height: widget.isExpanded ? 22 : 24,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: Spacing.zero,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget.onToggleExpanded,
                onVerticalDragStart: (_) {
                  _calendarGripDragHandled = false;
                  _calendarGripDragDistance = 0;
                },
                onVerticalDragUpdate: _handleCalendarGripDragUpdate,
                onVerticalDragEnd: (_) {
                  _calendarGripDragHandled = false;
                  _calendarGripDragDistance = 0;
                },
                onVerticalDragCancel: () {
                  _calendarGripDragHandled = false;
                  _calendarGripDragDistance = 0;
                },
                child: SizedBox(
                  width: 52,
                  height: 36,
                  child: Center(
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: color.primary,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween<double>(
                                begin: 0.82,
                                end: 1,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          widget.isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          key: ValueKey(widget.isExpanded),
                          color: color.onPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollWeek(int direction) {
    if (!_weekController.hasClients) return;

    final position = _weekController.position;
    final targetOffset = (_weekController.offset + direction * _weekScrollStep)
        .clamp(position.minScrollExtent, position.maxScrollExtent);

    _weekController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _handleMonthArrow(int direction) {
    if (widget.isExpanded) {
      widget.onMonthChanged(direction);
      return;
    }

    _scrollWeek(direction);
  }

  void _handleCalendarGripDragUpdate(DragUpdateDetails details) {
    if (_calendarGripDragHandled) return;
    final delta = details.primaryDelta;
    if (delta == null) {
      return;
    }

    _calendarGripDragDistance += delta;
    if (_calendarGripDragDistance.abs() < 10) return;

    final shouldExpand = _calendarGripDragDistance > 0;
    if (shouldExpand != widget.isExpanded) {
      _calendarGripDragHandled = true;
      widget.onToggleExpanded();
    }
  }
}
