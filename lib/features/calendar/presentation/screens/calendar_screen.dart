import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/data/calendar_fake_data_source.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_picker_sheet.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_pick_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_summary_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, this.showBottomSpace = false});

  final bool showBottomSpace;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const _dataSource = CalendarFakeDataSource();

  DateTime _focusedMonth = DateTime(2026, 9);
  DateTime _selectedDate = DateTime(2026, 9, 25);
  CalendarRestaurantEntity? _restaurant = _dataSource.getRestaurant();
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final days = _isExpanded
        ? _dataSource.getMonthDays(
            focusedMonth: _focusedMonth,
            selectedDate: _selectedDate,
          )
        : _dataSource.getWeekDays(
            selectedDate: _selectedDate,
            focusedMonth: _focusedMonth,
          );
    final restaurant = _restaurant;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: color.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: color.surface,
        body: Column(
          children: [
            SizedBox(
              height: Spacing.calendarHeaderHeight,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.primary,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(Spacing.calendarHeaderRadius),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      PositionedDirectional(
                        top: Spacing.lg,
                        start: Spacing.calendarHeaderHorizontalInset,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.notifications_rounded,
                              color: color.onPrimary,
                              size: Spacing.iconLg,
                            ),
                            PositionedDirectional(
                              top: Spacing.xs,
                              start: Spacing.calendarHeaderNotificationDotStart,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: color.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: const SizedBox(
                                  width: Spacing.sm,
                                  height: Spacing.sm,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PositionedDirectional(
                        top: Spacing.lg,
                        end: Spacing.calendarHeaderHorizontalInset,
                        child: Icon(
                          Icons.volume_mute_rounded,
                          color: color.onPrimary,
                          size: Spacing.iconLg,
                        ),
                      ),
                      PositionedDirectional(
                        top: Spacing.xxxl,
                        start: 0,
                        end: 0,
                        child: Text(
                          locale.calendar_title,
                          textAlign: TextAlign.center,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size22,
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CalendarPickerPanel(
              monthTitle: _dataSource.getMonthTitle(_focusedMonth),
              days: days,
              isExpanded: _isExpanded,
              onToggleExpanded: () {
                setState(() => _isExpanded = !_isExpanded);
              },
              onMonthChanged: _changeMonth,
              onDaySelected: _selectDay,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsetsDirectional.only(
                  start: Spacing.screenH,
                  end: Spacing.screenH,
                  top: Spacing.xxxl,
                  bottom: widget.showBottomSpace
                      ? Spacing.bottomNavHeight + Spacing.xxxl
                      : Spacing.xl,
                ),
                child: Column(
                  children: [
                    if (restaurant == null)
                      CalendarRestaurantPickCard(onTap: _openRestaurantPicker)
                    else
                      CalendarRestaurantSummaryCard(
                        restaurant: restaurant,
                        onMorePressed: _openRestaurantPicker,
                      ),
                    const SizedBox(height: Spacing.xl),
                    for (final meal in _dataSource.getMeals(
                      _selectedDate.day,
                    )) ...[
                      CalendarMealCard(meal: meal),
                      const SizedBox(height: Spacing.md),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeMonth(int direction) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + direction,
      );
      _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 25);
    });
  }

  void _selectDay(CalendarDayEntity day) {
    final date = day.date;
    if (date == null) {
      return;
    }

    setState(() {
      _selectedDate = date;
      _focusedMonth = DateTime(date.year, date.month);
    });
  }

  Future<void> _openRestaurantPicker() async {
    final selectedRestaurant =
        await showModalBottomSheet<CalendarRestaurantOptionEntity>(
          context: context,
          isScrollControlled: true,
          backgroundColor: context.colorScheme.surface,
          builder: (sheetContext) {
            return CalendarRestaurantPickerSheet(
              restaurants: _dataSource.getRestaurantOptions(),
              onRestaurantSelected: (restaurant) {
                Navigator.pop(sheetContext, restaurant);
              },
            );
          },
        );

    if (selectedRestaurant == null || !mounted) {
      return;
    }

    setState(() {
      _restaurant = _dataSource.getRestaurantFromOption(selectedRestaurant);
    });
  }
}
