import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/data/calendar_fake_data_source.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_pick_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_picker_sheet.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_summary_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_screen_header.dart';

enum CalendarFigmaState { pickRestaurant, expandedMonth, mealsList }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    this.initialState = CalendarFigmaState.mealsList,
    this.showBottomSpace = false,
  });

  final CalendarFigmaState initialState;
  final bool showBottomSpace;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const _dataSource = CalendarFakeDataSource();

  late CalendarFigmaState _state;
  late bool _isCalendarExpanded;
  late CalendarRestaurantEntity _selectedRestaurant;
  DateTime _focusedMonth = DateTime(2026, 9);
  DateTime _selectedDate = DateTime(2026, 9, 20);

  bool get _hasRestaurant => _state != CalendarFigmaState.pickRestaurant;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
    _isCalendarExpanded =
        widget.initialState != CalendarFigmaState.pickRestaurant;
    _selectedRestaurant = _dataSource.getRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final meals = _dataSource.getMeals(_selectedDate.day);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: color.surface,
        body: Column(
          children: [
            CalendarScreenHeader(
              title: locale.calendar_title,
              onBack: () => Navigator.maybePop(context),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: CalendarPickerPanel(
                      monthTitle: _dataSource.getMonthTitle(_focusedMonth),
                      days: _isCalendarExpanded
                          ? _dataSource.getMonthDays(
                              focusedMonth: _focusedMonth,
                              selectedDate: _selectedDate,
                            )
                          : _dataSource.getWeekDays(
                              focusedMonth: _focusedMonth,
                              selectedDate: _selectedDate,
                            ),
                      isExpanded: _isCalendarExpanded,
                      onToggleExpanded: _toggleCalendarMode,
                      onMonthChanged: _changeFocusedMonth,
                      onDaySelected: _selectDay,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      30,
                      _hasRestaurant ? 18 : 32,
                      30,
                      widget.showBottomSpace ? 110 : Spacing.lg,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 240),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: _hasRestaurant
                              ? CalendarRestaurantSummaryCard(
                                  key: const ValueKey('restaurant'),
                                  restaurant: _selectedRestaurant,
                                  onMorePressed: _openRestaurantPicker,
                                )
                              : CalendarRestaurantPickCard(
                                  key: const ValueKey('pick-restaurant'),
                                  onTap: _openRestaurantPicker,
                                ),
                        ),
                        if (_hasRestaurant) ...[
                          const SizedBox(height: 25),
                          Column(
                            key: const ValueKey('meals-list'),
                            children: [
                              for (final meal in meals) ...[
                                CalendarMealCard(meal: meal),
                                const SizedBox(height: 10),
                              ],
                            ],
                          ),
                        ],
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectRestaurant(CalendarRestaurantOptionEntity option) {
    setState(() {
      _selectedRestaurant = CalendarRestaurantEntity(
        name: option.name,
        category: 'أكل صحي',
        rating: option.rating,
        deliveryDuration: 'بيزك',
        deliveryWindow: 'وقت التوصيل المعتاد: 6:00 م - 7:00 م',
      );
      _state = CalendarFigmaState.mealsList;
      _isCalendarExpanded = true;
    });
  }

  void _openRestaurantPicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black,
      builder: (sheetContext) {
        return CalendarRestaurantPickerSheet(
          restaurants: _dataSource.getRestaurantOptions(),
          onRestaurantSelected: (restaurant) {
            Navigator.pop(sheetContext);
            _selectRestaurant(restaurant);
          },
        );
      },
    );
  }

  void _toggleCalendarMode() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
      if (_isCalendarExpanded) {
        _focusedMonth = DateTime(_selectedDate.year, _selectedDate.month);
      }
    });
  }

  void _changeFocusedMonth(int direction) {
    setState(() {
      final nextMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + direction,
      );
      final lastDayInMonth = DateTime(
        nextMonth.year,
        nextMonth.month + 1,
        0,
      ).day;

      _focusedMonth = nextMonth;
      _selectedDate = DateTime(
        nextMonth.year,
        nextMonth.month,
        _selectedDate.day.clamp(1, lastDayInMonth),
      );
    });
  }

  void _selectDay(CalendarDayEntity day) {
    if (!day.hasMeals && _hasRestaurant) return;
    final date =
        day.date ??
        DateTime(_focusedMonth.year, _focusedMonth.month, day.dayNumber);
    setState(() {
      _selectedDate = date;
      _focusedMonth = DateTime(date.year, date.month);
      if (_hasRestaurant) {
        _state = CalendarFigmaState.mealsList;
      }
    });
  }
}
