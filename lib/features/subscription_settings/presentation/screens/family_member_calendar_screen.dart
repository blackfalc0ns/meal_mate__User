import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_member_calendar_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_review_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_day_summary_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_selected_meals_card.dart';

class FamilyMemberCalendarScreen extends StatefulWidget {
  const FamilyMemberCalendarScreen({super.key});

  @override
  State<FamilyMemberCalendarScreen> createState() =>
      _FamilyMemberCalendarScreenState();
}

class _FamilyMemberCalendarScreenState
    extends State<FamilyMemberCalendarScreen> {
  static const _dataSource = FamilyMemberCalendarFakeDataSource();

  late DateTime _visibleMonth;
  int _selectedMemberIndex = 3;
  int _selectedDay = 20;
  bool _isCalendarExpanded = false;

  @override
  void initState() {
    super.initState();
    _visibleMonth = _dataSource.getCalendar().month;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final calendar = _dataSource.getCalendar();
    final safeSelectedMemberIndex = calendar.members.isEmpty
        ? 0
        : _selectedMemberIndex.clamp(0, calendar.members.length - 1).toInt();
    final selectedDate = DateTime(
      _visibleMonth.year,
      _visibleMonth.month,
      _selectedDay,
    );
    final calendarDays = _isCalendarExpanded
        ? _monthDays(focusedMonth: _visibleMonth, selectedDate: selectedDate)
        : _serviceDays(selectedDate: selectedDate);

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        titleWidget: Text(
          calendar.title,
          locale: Locale(locale.localeName),
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size18,
            color: color.onSurface,
          ),
        ),
        onBackPressed: () => Navigator.maybePop(context),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.familyMemberCalendarHorizontalPadding,
            end: Spacing.familyMemberCalendarHorizontalPadding,
            top: Spacing.familyMemberCalendarTopGap,
            bottom: Spacing.xl,
          ),
          child: Column(
            children: [
              FamilyDayMemberSelector(
                members: calendar.members,
                selectedIndex: safeSelectedMemberIndex,
                onMemberSelected: (index) {
                  setState(() => _selectedMemberIndex = index);
                },
              ),
              const SizedBox(height: Spacing.familyMemberCalendarMonthTopGap),
              CalendarPickerPanel(
                monthTitle: intl.DateFormat.yMMMM(
                  locale.localeName,
                ).format(_visibleMonth),
                days: calendarDays,
                isExpanded: _isCalendarExpanded,
                onToggleExpanded: () {
                  setState(() => _isCalendarExpanded = !_isCalendarExpanded);
                },
                onMonthChanged: _changeMonth,
                onDaySelected: (day) {
                  setState(() {
                    _selectedDay = day.dayNumber;
                    final date = day.date;
                    if (date != null &&
                        (_visibleMonth.year != date.year ||
                            _visibleMonth.month != date.month)) {
                      _visibleMonth = DateTime(date.year, date.month);
                    }
                  });
                },
              ),
              const SizedBox(
                height: Spacing.familyMemberCalendarSelectedMealsTopGap,
              ),
              FamilyMemberSelectedMealsCard(
                title: calendar.selectedMealsTitle,
                subtitle: calendar.selectedMealsSubtitle,
                countLabel: calendar.selectedMealsCountLabel,
                meals: calendar.selectedMeals,
              ),
              const SizedBox(
                height: Spacing.familyMemberCalendarDaySummaryTopGap,
              ),
              FamilyMemberCalendarDaySummaryCard(summary: calendar.daySummary),
              const SizedBox(height: Spacing.familyMemberCalendarButtonTopGap),
              FamilyDayReviewButton(
                label: calendar.detailsButtonLabel,
                onPressed: () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.familyMemberDayDetails),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeMonth(int months) {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + months,
      );
    });
  }

  List<CalendarDayEntity> _serviceDays({required DateTime selectedDate}) {
    final firstDay = selectedDate.subtract(const Duration(days: 4));

    return List.generate(7, (index) {
      final date = firstDay.add(Duration(days: index));
      return _calendarDay(date, selectedDate: selectedDate);
    });
  }

  List<CalendarDayEntity> _monthDays({
    required DateTime focusedMonth,
    required DateTime selectedDate,
  }) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month);
    final leadingDays = (firstDay.weekday + 1) % 7;
    final gridStart = firstDay.subtract(Duration(days: leadingDays));
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;
    final totalCells = ((leadingDays + daysInMonth + 6) ~/ 7) * 7;

    return List.generate(totalCells, (index) {
      final date = DateTime(
        gridStart.year,
        gridStart.month,
        gridStart.day + index,
      );

      return _calendarDay(
        date,
        selectedDate: selectedDate,
        isMuted: date.month != focusedMonth.month,
      );
    });
  }

  CalendarDayEntity _calendarDay(
    DateTime date, {
    required DateTime selectedDate,
    bool isMuted = false,
  }) {
    return CalendarDayEntity(
      dayNumber: date.day,
      weekday: intl.DateFormat.E(context.localization.localeName).format(date),
      date: date,
      isSelected:
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
      isMuted: isMuted,
      hasMeals: date.day % 5 == 0 || date.day == selectedDate.day,
    );
  }
}
