import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';

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
  State<CalendarPickerPanel> createState() => _CalendarPickerPanelState();
}

class _CalendarPickerPanelState extends State<CalendarPickerPanel> {
  static const _weekScrollStep = 64.75;

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
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.surfaceContainerHighest,
                border: const Border(
                  bottom: BorderSide(color: Color(0xFFBBBBBB)),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(31, 14, 31, 0),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            _MonthArrowButton(
                              icon: Icons.chevron_left_rounded,
                              onPressed: () => _handleMonthArrow(-1),
                            ),
                            const Spacer(),
                            _MonthTitle(monthTitle: widget.monthTitle),
                            const Spacer(),
                            _MonthArrowButton(
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
                    height: widget.isExpanded ? 8 : 4,
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
                              return ClipRect(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  heightFactor: animation.value,
                                  child: child,
                                ),
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
                          ? _MonthGrid(
                              days: widget.days,
                              onDaySelected: widget.onDaySelected,
                            )
                          : _WeekStrip(
                              controller: _weekController,
                              days: widget.days,
                              onDaySelected: widget.onDaySelected,
                            ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 520),
                    curve: Curves.easeInOutCubic,
                    height: widget.isExpanded ? 28 : 30,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -22,
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
                  width: 64,
                  height: 44,
                  child: Center(
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2EA45D),
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
                          color: AppColors.white,
                          size: 22,
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

class _MonthTitle extends StatelessWidget {
  const _MonthTitle({required this.monthTitle});

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
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: 33,
          color: color.onSurface,
        ).copyWith(height: 1),
        children: [
          TextSpan(
            text: month,
            style: const TextStyle(color: AppColors.brandDeepGreen),
          ),
          if (year.isNotEmpty) TextSpan(text: ' $year'),
        ],
      ),
    );
  }
}

class _MonthArrowButton extends StatelessWidget {
  const _MonthArrowButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 18, height: 18),
      icon: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.brandDeepGreen,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color.onPrimary, size: 17),
      ),
    );
  }
}

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

class _ScrollableDayStrip extends StatefulWidget {
  const _ScrollableDayStrip({
    required this.controller,
    required this.days,
    required this.onDaySelected,
  });

  final ScrollController controller;
  final List<CalendarDayEntity> days;
  final ValueChanged<CalendarDayEntity> onDaySelected;

  @override
  State<_ScrollableDayStrip> createState() => _ScrollableDayStripState();
}

class _ScrollableDayStripState extends State<_ScrollableDayStrip> {
  static const _tileWidth = 54.5;
  static const _tileGap = 10.25;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelectedDay());
  }

  @override
  void didUpdateWidget(covariant _ScrollableDayStrip oldWidget) {
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

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({required this.days, required this.onDaySelected});

  final List<CalendarDayEntity> days;
  final ValueChanged<CalendarDayEntity> onDaySelected;

  @override
  Widget build(BuildContext context) {
    const weekdays = [
      'سبت',
      'احد',
      'اثنين',
      'ثلاثاء',
      'اربعاء',
      'خميس',
      'جمعة',
    ];

    return SizedBox(
      key: const ValueKey('month-grid'),
      width: 354,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weekdays.length + days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < weekdays.length) {
              return _MonthWeekdayLabel(label: weekdays[index]);
            }

            final day = days[index - weekdays.length];
            return CalendarDayTile(
              day: day,
              compact: true,
              onPressed: () => onDaySelected(day),
            );
          },
        ),
      ),
    );
  }
}

class _MonthWeekdayLabel extends StatelessWidget {
  const _MonthWeekdayLabel({required this.label});

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

class CalendarDayTile extends StatelessWidget {
  const CalendarDayTile({
    super.key,
    required this.day,
    required this.onPressed,
    this.width,
    this.height,
    this.compact = false,
  });

  final CalendarDayEntity day;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final selected = day.isSelected;
    final textColor = selected
        ? color.onPrimary
        : day.isMuted
        ? color.onSurface.withValues(alpha: 0.25)
        : color.onSurface;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: selected
            ? AppColors.brandDeepGreen
            : compact
            ? Colors.transparent
            : color.surface,
        borderRadius: BorderRadius.circular(compact ? 14 : 12),
        elevation: compact || selected ? 0 : 2,
        shadowColor: Colors.black.withValues(alpha: 0.04),
        child: InkWell(
          borderRadius: BorderRadius.circular(compact ? 14 : 12),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: compact ? 4 : 7,
              horizontal: 4,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.dayNumber}',
                  style:
                      getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: compact ? 16 : (selected ? 20.4 : 16.2),
                        color: textColor,
                      ).copyWith(
                        height: 1,
                        fontWeight: compact && selected
                            ? FontWeight.w600
                            : FontWeight.w700,
                      ),
                ),
                if (!compact) ...[
                  SizedBox(height: selected ? 8 : 9),
                  Text(
                    day.weekday,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (selected
                                ? getMediumStyle(
                                    fontFamily: FontConstant.ibmPlexSansArabic,
                                    fontSize: 11.9,
                                    color: textColor,
                                  )
                                : getRegularStyle(
                                    fontFamily: FontConstant.ibmPlexSansArabic,
                                    fontSize: 9.36,
                                    color: textColor,
                                  ))
                            .copyWith(height: 1),
                  ),
                ],
                SizedBox(height: compact ? 4 : (selected ? 7 : 6)),
                if (!compact)
                  _DayMealIndicator(
                    selected: selected,
                    muted: day.isMuted,
                    compact: compact,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayMealIndicator extends StatelessWidget {
  const _DayMealIndicator({
    required this.selected,
    required this.muted,
    required this.compact,
  });

  final bool selected;
  final bool muted;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 6.0 : 9.5;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: muted ? AppColors.brandDeepGreen : null,
        border: muted
            ? null
            : Border.all(
                color: selected ? AppColors.white : AppColors.appText,
                width: 0.95,
              ),
      ),
    );
  }
}
