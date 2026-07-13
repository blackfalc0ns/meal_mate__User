import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/data/calendar_fake_data_source.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_picker_sheet.dart';
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
  State<CalendarScreen> createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
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
        widget.initialState == CalendarFigmaState.expandedMonth;
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
                    padding: EdgeInsets.symmetric(horizontal: Spacing.xxl)
                        .copyWith(
                          top: _hasRestaurant ? Spacing.lg : Spacing.xxl,
                          bottom: widget.showBottomSpace
                              ? Spacing.bottomNavHeight + Spacing.xxxl
                              : Spacing.lg,
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
                          const SizedBox(height: Spacing.xl),
                          Column(
                            key: const ValueKey('meals-list'),
                            children: [
                              for (final meal in meals) ...[
                                CalendarMealCard(meal: meal),
                                const SizedBox(height: Spacing.sm),
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
      _selectedRestaurant = _dataSource.getRestaurantFromOption(option);
      _state = CalendarFigmaState.mealsList;
      _isCalendarExpanded = false;
    });
  }

  void _openRestaurantPicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface.withValues(alpha: 0),
      barrierColor: context.colorScheme.scrim,
      builder: (_) {
        return CalendarRestaurantPickerSheet(
          restaurants: _dataSource.getRestaurantOptions(),
          onRestaurantSelected: (restaurant) {
            _selectRestaurant(restaurant);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              _openMealPicker();
            });
          },
        );
      },
    );
  }

  void _openMealPicker() {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const CalendarMealPickerSheet();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation =
              Tween<Offset>(
                begin: Offset(isRtl ? -1 : 1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                  reverseCurve: Curves.easeInCubic,
                ),
              );

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
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
