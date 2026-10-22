import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class EligibleStartDateCalendar extends StatefulWidget {
  const EligibleStartDateCalendar({
    super.key,
    required this.dates,
    required this.includeFriday,
    required this.onSelected,
    this.initialDate,
  });

  final List<String> dates;
  final bool includeFriday;
  final String? initialDate;
  final ValueChanged<String> onSelected;

  @override
  State<EligibleStartDateCalendar> createState() =>
      _EligibleStartDateCalendarState();
}

class _EligibleStartDateCalendarState extends State<EligibleStartDateCalendar> {
  late List<DateTime> _dates;
  late Set<String> _eligible;
  late DateTime _month;
  String? _selectedDate;
  List<int> _weekdays = [];
  List<DateTime?> _cells = [];
  int _firstWeekday = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate?.trim();
    _prepareDates();
  }

  void _prepareDates() {
    _dates =
        widget.dates
            .map(DateTime.tryParse)
            .whereType<DateTime>()
            .where((d) => widget.includeFriday || d.weekday != DateTime.friday)
            .toList()
          ..sort();
    _eligible = widget.dates.toSet();
    final rawInitial = widget.initialDate?.trim();
    final selected = DateTime.tryParse(rawInitial ?? '');
    final initial =
        selected != null && _eligible.contains(rawInitial)
            ? selected
            : (_dates.isNotEmpty ? _dates.first : DateTime.now());
    _month = DateTime(initial.year, initial.month);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _firstWeekday = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    _prepareMonth();
  }

  @override
  void didUpdateWidget(covariant EligibleStartDateCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dates != widget.dates ||
        oldWidget.includeFriday != widget.includeFriday ||
        oldWidget.initialDate != widget.initialDate) {
      _selectedDate = widget.initialDate?.trim();
      _prepareDates();
      _prepareMonth();
    }
  }

  void _prepareMonth() {
    _weekdays = List.generate(
      7,
      (i) => (_firstWeekday + i) % 7,
    ).where((d) => widget.includeFriday || d != DateTime.friday).toList();
    var first = DateTime(_month.year, _month.month, 1);
    if (!widget.includeFriday && first.weekday == DateTime.friday) {
      first = DateTime(_month.year, _month.month, 2);
    }
    final leading = _weekdays.indexOf(first.weekday % 7);
    _cells = List.filled(leading, null, growable: true);
    for (
      var day = first;
      day.month == _month.month;
      day = DateTime(day.year, day.month, day.day + 1)
    ) {
      if (widget.includeFriday || day.weekday != DateTime.friday) {
        _cells.add(day);
      }
    }
    while (_cells.length % _weekdays.length != 0) {
      _cells.add(null);
    }
  }

  String _key(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  void _move(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
      _prepareMonth();
    });
  }

  void _selectDate(String date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final material = MaterialLocalizations.of(context);
    final last = _dates.isNotEmpty ? _dates.last : _month;
    final first = _dates.isNotEmpty ? _dates.first : _month;
    final canPrevious = _month.isAfter(DateTime(first.year, first.month));
    final canNext = _month.isBefore(DateTime(last.year, last.month));
    final totalRows = _cells.length ~/ _weekdays.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: material.previousMonthTooltip,
              onPressed: canPrevious ? () => _move(-1) : null,
              icon: Icon(
                Icons.chevron_left_rounded,
                size: Spacing.iconMd,
                color:
                    canPrevious
                        ? color.onSurface
                        : color.onSurfaceVariant.withValues(alpha: 0.38),
              ),
            ),
            Expanded(
              child: Text(
                DateFormat.yMMMM(locale.localeName).format(_month),
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size16,
                  color: color.onSurface,
                ),
              ),
            ),
            IconButton(
              tooltip: material.nextMonthTooltip,
              onPressed: canNext ? () => _move(1) : null,
              icon: Icon(
                Icons.chevron_right_rounded,
                size: Spacing.iconMd,
                color:
                    canNext
                        ? color.onSurface
                        : color.onSurfaceVariant.withValues(alpha: 0.38),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
          decoration: BoxDecoration(
            color: color.surfaceContainerHighest.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
          ),
          child: Row(
            children: [
              for (var col = 0; col < _weekdays.length; col++)
                Expanded(
                  child: Center(
                    child: Text(
                      material.narrowWeekdays[_weekdays[col]],
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.xs),
        for (var row = 0; row < totalRows; row++) ...[
          if (row > 0) const SizedBox(height: Spacing.xs),
          Row(
            children: [
              for (var col = 0; col < _weekdays.length; col++)
                Expanded(
                  child:
                      _cells[row * _weekdays.length + col] == null
                          ? const SizedBox.shrink()
                          : _day(_cells[row * _weekdays.length + col]!),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _day(DateTime day) {
    final color = context.colorScheme;
    final locale = context.localization;
    final date = _key(day);
    final enabled = _eligible.contains(date);
    final isSelected = _selectedDate == date;

    final BoxDecoration? decoration;
    final TextStyle textStyle;

    if (isSelected) {
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        color: color.primary,
        boxShadow: [
          BoxShadow(
            color: color.primary.withValues(alpha: 0.35),
            blurRadius: Spacing.xs,
            offset: const Offset(0, 2),
          ),
        ],
      );
      textStyle = getBoldStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size14,
        color: color.onPrimary,
      );
    } else if (enabled) {
      decoration = null;
      textStyle = getBoldStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size15,
        color: color.primary,
      );
    } else {
      decoration = null;
      textStyle = getRegularStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size13,
        color: color.onSurfaceVariant.withValues(alpha: 0.38),
      ).copyWith(
        decoration: TextDecoration.lineThrough,
        decorationColor: color.onSurfaceVariant.withValues(alpha: 0.38),
      );
    }

    return Center(
      child: Semantics(
        label: DateFormat.yMMMMEEEEd(locale.localeName).format(day),
        button: true,
        selected: isSelected,
        enabled: enabled,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: enabled ? () => _selectDate(date) : null,
            child: Container(
              width: Spacing.avatarSm + Spacing.xs,
              height: Spacing.avatarSm + Spacing.xs,
              decoration: decoration,
              alignment: Alignment.center,
              child: Text(
                MaterialLocalizations.of(context).formatDecimal(day.day),
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
