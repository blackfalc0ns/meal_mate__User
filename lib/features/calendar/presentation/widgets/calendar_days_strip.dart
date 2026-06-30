import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class CalendarDaysStrip extends StatefulWidget {
  const CalendarDaysStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.daysBefore = 180,
    this.daysAfter = 365,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final int daysBefore;
  final int daysAfter;

  @override
  State<CalendarDaysStrip> createState() => _CalendarDaysStripState();
}

class _CalendarDaysStripState extends State<CalendarDaysStrip> {
  final ScrollController _controller = ScrollController();
  double? _itemExtent;
  bool _positionedInitially = false;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _firstDate => _today.subtract(Duration(days: widget.daysBefore));

  int get _itemCount => widget.daysBefore + widget.daysAfter + 1;

  @override
  void didUpdateWidget(CalendarDaysStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameDay(oldWidget.selectedDate, widget.selectedDate)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showSelectedDate());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _itemExtent = (constraints.maxWidth - 44) / 5;
          if (!_positionedInitially) {
            _positionedInitially = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSelectedDate(jump: true);
            });
          }

          return Row(
            children: [
              _DayArrow(
                icon: Icons.chevron_left_rounded,
                onTap: () => _scrollBy(-5),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemExtent: _itemExtent,
                  itemCount: _itemCount,
                  itemBuilder: (context, index) {
                    final date = _firstDate.add(Duration(days: index));
                    return _DayCard(
                      date: date,
                      selected: _sameDay(date, widget.selectedDate),
                      onTap: () => widget.onDateSelected(date),
                    );
                  },
                ),
              ),
              _DayArrow(
                icon: Icons.chevron_right_rounded,
                onTap: () => _scrollBy(5),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSelectedDate({bool jump = false}) {
    if (!mounted || !_controller.hasClients || _itemExtent == null) return;
    final index = widget.selectedDate.difference(_firstDate).inDays;
    if (index < 0 || index >= _itemCount) return;
    final target =
        (index * _itemExtent!) -
        (_controller.position.viewportDimension - _itemExtent!) / 2;
    final offset = target.clamp(0.0, _controller.position.maxScrollExtent);
    if (jump) {
      _controller.jumpTo(offset);
    } else {
      _controller.animateTo(
        offset,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _scrollBy(int itemCount) {
    if (!_controller.hasClients || _itemExtent == null) return;
    final target = (_controller.offset + itemCount * _itemExtent!).clamp(
      0.0,
      _controller.position.maxScrollExtent,
    );
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  bool _sameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

class _DayArrow extends StatelessWidget {
  const _DayArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      constraints: const BoxConstraints.tightFor(width: 22),
      onPressed: onTap,
      icon: CircleAvatar(
        radius: 9,
        backgroundColor: AppColors.calendarAccent,
        child: Icon(icon, size: 16, color: AppColors.white),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.date,
    required this.selected,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dayName = DateFormat.EEEE(locale).format(date);

    return Semantics(
      button: true,
      selected: selected,
      label: DateFormat.yMMMMEEEEd(locale).format(date),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Material(
          color: selected ? AppColors.calendarAccent : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          elevation: selected ? 2 : 4,
          shadowColor: AppColors.shadow,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.day}',
                  style: getBoldStyle(
                    fontSize: 20,
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    color: selected
                        ? AppColors.white
                        : AppColors.calendarDayText,
                  ),
                ),
                Text(
                  dayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontSize: FontSize.size10,
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    color: selected
                        ? AppColors.white
                        : AppColors.calendarDateText,
                  ),
                ),
                if (selected)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: CircleAvatar(
                      radius: 2.5,
                      backgroundColor: AppColors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
