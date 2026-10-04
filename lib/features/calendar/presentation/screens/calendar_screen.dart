import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_navigation_coordinator.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_screen_body.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_screen_effects.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    this.showBottomSpace = false,
    this.subscriptionId,
    this.overviewCubit,
    this.restaurantPickerCubit,
    this.mealSelectionCubit,
    this.flowCubit,
    this.coordinator,
    this.onBackPressed,
  });

  final bool showBottomSpace;
  final String? subscriptionId;
  final CalendarOverviewViewModel? overviewCubit;
  final RestaurantPickerViewModel? restaurantPickerCubit;
  final MealSelectionViewModel? mealSelectionCubit;
  final CalendarFlowViewModel? flowCubit;
  final CalendarNavigationCoordinator? coordinator;
  final VoidCallback? onBackPressed;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final CalendarOverviewViewModel _overviewCubit;
  late final RestaurantPickerViewModel _restaurantPickerCubit;
  late final MealSelectionViewModel _mealSelectionCubit;
  late final CalendarFlowViewModel _flowCubit;
  late final CalendarNavigationCoordinator _coordinator;

  bool _didLoad = false;

  @override
  void initState() {
    super.initState();
    _overviewCubit = widget.overviewCubit ?? getIt<CalendarOverviewViewModel>();
    _restaurantPickerCubit =
        widget.restaurantPickerCubit ?? getIt<RestaurantPickerViewModel>();
    _mealSelectionCubit =
        widget.mealSelectionCubit ?? getIt<MealSelectionViewModel>();
    _flowCubit =
        widget.flowCubit ??
        CalendarFlowViewModel(
          overviewCubit: _overviewCubit,
          restaurantPickerCubit: _restaurantPickerCubit,
          mealSelectionCubit: _mealSelectionCubit,
        );
    _coordinator = widget.coordinator ?? CalendarNavigationCoordinator();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _didLoad = true;
    unawaited(
      _overviewCubit.loadCalendar(
        subscriptionId: widget.subscriptionId,
        localeName: context.localization.localeName,
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_flowCubit.close());
    unawaited(_mealSelectionCubit.close());
    unawaited(_restaurantPickerCubit.close());
    unawaited(_overviewCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarOverviewViewModel>.value(value: _overviewCubit),
        BlocProvider<RestaurantPickerViewModel>.value(
          value: _restaurantPickerCubit,
        ),
        BlocProvider<MealSelectionViewModel>.value(value: _mealSelectionCubit),
        BlocProvider<CalendarFlowViewModel>.value(value: _flowCubit),
      ],
      child: CalendarScreenEffects(
        coordinator: _coordinator,
        child: CalendarScreenBody(
          showBottomSpace: widget.showBottomSpace,
          coordinator: _coordinator,
          onBackPressed: widget.onBackPressed,
        ),
      ),
    );
  }
}
