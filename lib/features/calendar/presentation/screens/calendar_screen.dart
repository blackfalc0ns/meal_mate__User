import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_cubit.dart';
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
  final CalendarOverviewCubit? overviewCubit;
  final RestaurantPickerCubit? restaurantPickerCubit;
  final MealSelectionCubit? mealSelectionCubit;
  final CalendarFlowCubit? flowCubit;
  final CalendarNavigationCoordinator? coordinator;
  final VoidCallback? onBackPressed;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final CalendarOverviewCubit _overviewCubit;
  late final RestaurantPickerCubit _restaurantPickerCubit;
  late final MealSelectionCubit _mealSelectionCubit;
  late final CalendarFlowCubit _flowCubit;
  late final CalendarNavigationCoordinator _coordinator;

  bool _didLoad = false;

  @override
  void initState() {
    super.initState();
    _overviewCubit = widget.overviewCubit ?? getIt<CalendarOverviewCubit>();
    _restaurantPickerCubit =
        widget.restaurantPickerCubit ?? getIt<RestaurantPickerCubit>();
    _mealSelectionCubit =
        widget.mealSelectionCubit ?? getIt<MealSelectionCubit>();
    _flowCubit =
        widget.flowCubit ??
        CalendarFlowCubit(
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
        BlocProvider<CalendarOverviewCubit>.value(value: _overviewCubit),
        BlocProvider<RestaurantPickerCubit>.value(
          value: _restaurantPickerCubit,
        ),
        BlocProvider<MealSelectionCubit>.value(value: _mealSelectionCubit),
        BlocProvider<CalendarFlowCubit>.value(value: _flowCubit),
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
