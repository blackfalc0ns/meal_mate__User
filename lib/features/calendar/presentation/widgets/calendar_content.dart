import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_days_builder.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_day_content.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_empty_meals_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_loading_skeleton.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_cubit.dart';

enum _CalendarViewMode { loading, noSubscription, error, empty, data }

class CalendarContent extends StatefulWidget {
  const CalendarContent({
    super.key,
    this.state,
    required this.showBottomSpace,
    required this.onSelectRestaurant,
    required this.onChangeMeal,
    required this.onMealTap,
    this.onNavigateToSubscriptions,
  });

  final CalendarState? state;
  final bool showBottomSpace;
  final VoidCallback onSelectRestaurant;
  final VoidCallback onChangeMeal;
  final void Function(CalendarMealEntity, CalendarRestaurantEntity?) onMealTap;
  final VoidCallback? onNavigateToSubscriptions;

  @override
  State<CalendarContent> createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
  bool _isInitialized = false;
  late DateTime _focusedMonth;
  late DateTime _emptySelectedDate;
  List<CalendarDayEntity> _emptyDays = const [];
  String? _emptyDaysLocaleName;
  bool _isExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      final initialDate =
          widget.state?.selectedDate ??
          (widget.state == null
              ? context.read<CalendarViewModel>().state.selectedDate
              : null) ??
          DateTime.now();
      _focusedMonth = DateTime(initialDate.year, initialDate.month);
      _emptySelectedDate = initialDate;
    }
    final localeName = context.localization.localeName;
    if (_emptyDaysLocaleName != localeName) {
      _emptyDaysLocaleName = localeName;
      _updateEmptyDays();
    }
  }

  @override
  void didUpdateWidget(covariant CalendarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != null) {
      final selectedDate = widget.state?.selectedDate;
      if (selectedDate != null &&
          (_focusedMonth.year != selectedDate.year ||
              _focusedMonth.month != selectedDate.month)) {
        _focusedMonth = DateTime(selectedDate.year, selectedDate.month);
      }
    }
  }

  _CalendarViewMode _determineViewMode(CalendarState state) {
    if (state.isCalendarLoading && !state.hasCalendarData) {
      return _CalendarViewMode.loading;
    }
    if (state.hasNoSubscription) {
      return _CalendarViewMode.noSubscription;
    }
    if (state.calendarFailure != null && !state.hasCalendarData) {
      return _CalendarViewMode.error;
    }
    if (!state.hasCalendarData) {
      return _CalendarViewMode.empty;
    }
    return _CalendarViewMode.data;
  }

  @override
  Widget build(BuildContext context) {
    final staticState = widget.state;
    if (staticState != null) {
      return _buildViewForMode(
        context,
        mode: _determineViewMode(staticState),
        dataView: _buildDataLayout(
          days: staticState.days,
          selectedDate: staticState.selectedDate,
          selectedDay: staticState.selectedDay,
          isConfirming: staticState.isConfirming,
          canConfirm: staticState.canConfirmSelectedDayMeals,
          isSelectedDayLoading: staticState.isSelectedDayLoading,
          onDaySelected: (_) {},
          onConfirmSelections: () {},
        ),
      );
    }

    return BlocListener<CalendarViewModel, CalendarState>(
      listenWhen: (previous, current) =>
          previous.selectedDate != current.selectedDate,
      listener: (context, state) {
        final selectedDate = state.selectedDate;
        if (selectedDate != null &&
            (_focusedMonth.year != selectedDate.year ||
                _focusedMonth.month != selectedDate.month)) {
          setState(() {
            _focusedMonth = DateTime(selectedDate.year, selectedDate.month);
          });
        }
      },
      child: BlocSelector<CalendarViewModel, CalendarState, _CalendarViewMode>(
        selector: _determineViewMode,
        builder: (context, viewMode) {
          return _buildViewForMode(
            context,
            mode: viewMode,
            dataView: _buildReactiveDataView(context),
          );
        },
      ),
    );
  }

  Widget _buildViewForMode(
    BuildContext context, {
    required _CalendarViewMode mode,
    required Widget dataView,
  }) {
    switch (mode) {
      case _CalendarViewMode.loading:
        return CalendarLoadingSkeleton(showBottomSpace: widget.showBottomSpace);
      case _CalendarViewMode.noSubscription:
        return _buildNoSubscriptionView(context);
      case _CalendarViewMode.error:
        return _buildErrorView(context);
      case _CalendarViewMode.empty:
        return _buildEmptyView(context);
      case _CalendarViewMode.data:
        return dataView;
    }
  }

  Widget _buildNoSubscriptionView(BuildContext context) {
    final locale = context.localization;
    final days = _isExpanded
        ? CalendarDaysBuilder.monthDays(
            focusedMonth: _focusedMonth,
            selectedDate: _emptySelectedDate,
            serviceDays: _emptyDays,
          )
        : _emptyDays;

    return Column(
      children: [
        CalendarPickerPanel(
          monthTitle: DateFormat.yMMMM(locale.localeName).format(_focusedMonth),
          days: days,
          isExpanded: _isExpanded,
          onToggleExpanded: () => setState(() => _isExpanded = !_isExpanded),
          onMonthChanged: _changeMonth,
          onDaySelected: (day) {
            if (day.date == null) return;
            setState(() {
              _emptySelectedDate = day.date!;
              _updateEmptyDays();
            });
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              start: Spacing.screenH,
              end: Spacing.screenH,
              top: Spacing.xs,
              bottom: widget.showBottomSpace
                  ? Spacing.bottomNavHeight + Spacing.xxxl + Spacing.md
                  : Spacing.xl,
            ),
            child: Center(
              child: CalendarEmptyMealsState(
                isNoSubscription: true,
                onAddMeals: () => _navigateToSubscriptions(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context) {
    final state = widget.state ?? context.read<CalendarViewModel>().state;
    final locale = context.localization;
    final failure = state.calendarFailure;
    if (failure == null) return const SizedBox.shrink();
    return ApiErrorWidget(
      exception: failure.exception,
      onRetry: () {
        if (widget.state == null) {
          context.read<CalendarViewModel>().doIntent(
            LoadCalendarEvent(
              subscriptionId: state.subscriptionId,
              localeName: locale.localeName,
            ),
          );
        }
      },
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    final locale = context.localization;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        bottom: widget.showBottomSpace
            ? Spacing.bottomNavHeight + Spacing.xxxl
            : Spacing.zero,
      ),
      child: EmptyStateWidget(
        title: locale.calendar_title,
        description: locale.billing_no_subscription_description,
        icon: Icons.calendar_month_rounded,
      ),
    );
  }

  Widget _buildReactiveDataView(BuildContext context) {
    final locale = context.localization;

    return BlocSelector<
      CalendarViewModel,
      CalendarState,
      ({
        DateTime? selectedDate,
        List<CalendarDayEntity> days,
        CalendarDayEntity? selectedDay,
        bool isConfirming,
        bool canConfirm,
        bool isSelectedDayLoading,
      })
    >(
      selector: (state) => (
        selectedDate: state.selectedDate,
        days: state.days,
        selectedDay: state.selectedDay,
        isConfirming: state.isConfirming,
        canConfirm: state.canConfirmSelectedDayMeals,
        isSelectedDayLoading: state.isSelectedDayLoading,
      ),
      builder: (context, data) {
        return _buildDataLayout(
          days: data.days,
          selectedDate: data.selectedDate,
          selectedDay: data.selectedDay,
          isConfirming: data.isConfirming,
          canConfirm: data.canConfirm,
          isSelectedDayLoading: data.isSelectedDayLoading,
          onDaySelected: (day) {
            context.read<CalendarViewModel>().doIntent(
              SelectCalendarDayEvent(day: day, localeName: locale.localeName),
            );
          },
          onConfirmSelections: () {
            context.read<CalendarViewModel>().doIntent(
              ConfirmCalendarDayMealsEvent(localeName: locale.localeName),
            );
          },
        );
      },
    );
  }

  Widget _buildDataLayout({
    required List<CalendarDayEntity> days,
    required DateTime? selectedDate,
    required CalendarDayEntity? selectedDay,
    required bool isConfirming,
    required bool canConfirm,
    required bool isSelectedDayLoading,
    required ValueChanged<CalendarDayEntity> onDaySelected,
    required VoidCallback onConfirmSelections,
  }) {
    final locale = context.localization;
    final displayDays = _isExpanded
        ? CalendarDaysBuilder.monthDays(
            focusedMonth: _focusedMonth,
            selectedDate: selectedDate,
            serviceDays: days,
          )
        : CalendarDaysBuilder.serviceDays(days, selectedDate: selectedDate);

    return Column(
      children: [
        CalendarPickerPanel(
          monthTitle: DateFormat.yMMMM(locale.localeName).format(_focusedMonth),
          days: displayDays,
          isExpanded: _isExpanded,
          onToggleExpanded: () {
            setState(() => _isExpanded = !_isExpanded);
          },
          onMonthChanged: _changeMonth,
          onDaySelected: onDaySelected,
        ),
        Expanded(
          child: CalendarDayContent(
            selectedDay: selectedDay,
            showBottomSpace: widget.showBottomSpace,
            onSelectRestaurant: widget.onSelectRestaurant,
            onChangeMeal: widget.onChangeMeal,
            onMealTap: widget.onMealTap,
            onConfirmSelections: onConfirmSelections,
            isConfirming: isConfirming,
            canConfirm: canConfirm,
            isLoading: isSelectedDayLoading,
          ),
        ),
      ],
    );
  }

  void _changeMonth(int direction) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + direction,
      );
      final hasNoSub =
          widget.state?.hasNoSubscription ??
          (widget.state == null &&
              context.read<CalendarViewModel>().state.hasNoSubscription);
      if (hasNoSub) {
        _emptySelectedDate = DateTime(_focusedMonth.year, _focusedMonth.month);
        _updateEmptyDays();
      }
    });
  }

  void _updateEmptyDays() {
    final localeName = _emptyDaysLocaleName;
    if (localeName == null) return;
    final dayCount = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;
    _emptyDays = List.generate(dayCount, (index) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, index + 1);
      return CalendarDayEntity(
        dayNumber: date.day,
        weekday: DateFormat.EEEE(localeName).format(date),
        date: date,
        isSelected:
            date.year == _emptySelectedDate.year &&
            date.month == _emptySelectedDate.month &&
            date.day == _emptySelectedDate.day,
        hasMeals: false,
      );
    });
  }

  void _navigateToSubscriptions(BuildContext context) {
    if (widget.onNavigateToSubscriptions != null) {
      widget.onNavigateToSubscriptions!();
      return;
    }
    try {
      context.read<HomeCubit>().selectTab(3);
    } catch (_) {
      unawaited(context.pushNamed(AppRoutes.subscriptions));
    }
  }
}
