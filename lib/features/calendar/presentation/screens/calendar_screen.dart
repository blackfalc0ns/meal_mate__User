import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/data/calendar_fake_data_source.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_pick_card.dart';
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
  int _selectedDay = 20;

  bool get _hasRestaurant => _state != CalendarFigmaState.pickRestaurant;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
    _isCalendarExpanded =
        widget.initialState != CalendarFigmaState.pickRestaurant;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final restaurant = _dataSource.getRestaurant();
    final meals = _dataSource.getMeals(_selectedDay);

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
                      monthTitle: _dataSource.monthTitle,
                      days: _isCalendarExpanded
                          ? _dataSource.getMonthDays(selectedDay: _selectedDay)
                          : _dataSource.getWeekDays(selectedDay: _selectedDay),
                      isExpanded: _isCalendarExpanded,
                      onToggleExpanded: _toggleCalendarMode,
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
                                  restaurant: restaurant,
                                  onMorePressed: _showMeals,
                                )
                              : CalendarRestaurantPickCard(
                                  key: const ValueKey('pick-restaurant'),
                                  onTap: _selectRestaurant,
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

  void _selectRestaurant() {
    setState(() {
      _state = CalendarFigmaState.mealsList;
      _isCalendarExpanded = true;
    });
  }

  void _showMeals() {
    setState(() => _state = CalendarFigmaState.mealsList);
  }

  void _toggleCalendarMode() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
      _selectedDay = _isCalendarExpanded ? 20 : 25;
    });
  }

  void _selectDay(CalendarDayEntity day) {
    if (!day.hasMeals && _hasRestaurant) return;
    setState(() {
      _selectedDay = day.dayNumber;
      if (_hasRestaurant) {
        _state = CalendarFigmaState.mealsList;
      }
    });
  }
}
