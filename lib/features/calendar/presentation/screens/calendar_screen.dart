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
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_view_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    this.showBottomSpace = false,
    this.subscriptionId,
    this.overviewViewModel,
    this.restaurantPickerViewModel,
    this.mealSelectionViewModel,
    this.flowViewModel,
    this.overviewCubit,
    this.restaurantPickerCubit,
    this.mealSelectionCubit,
    this.flowCubit,
    this.coordinator,
    this.onBackPressed,
  });

  final bool showBottomSpace;
  final String? subscriptionId;
  final CalendarOverviewViewModel? overviewViewModel;
  final RestaurantPickerViewModel? restaurantPickerViewModel;
  final MealSelectionViewModel? mealSelectionViewModel;
  final CalendarFlowViewModel? flowViewModel;
  final CalendarOverviewViewModel? overviewCubit;
  final RestaurantPickerViewModel? restaurantPickerCubit;
  final MealSelectionViewModel? mealSelectionCubit;
  final CalendarFlowViewModel? flowCubit;
  final CalendarNavigationCoordinator? coordinator;
  final VoidCallback? onBackPressed;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with WidgetsBindingObserver {
  late final CalendarOverviewViewModel _overviewViewModel;
  late final RestaurantPickerViewModel _restaurantPickerViewModel;
  late final MealSelectionViewModel _mealSelectionViewModel;
  late final CalendarFlowViewModel _flowViewModel;
  late final CalendarNavigationCoordinator _coordinator;

  bool _didLoad = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _overviewViewModel =
        widget.overviewViewModel ??
        widget.overviewCubit ??
        getIt<CalendarOverviewViewModel>();
    _restaurantPickerViewModel =
        widget.restaurantPickerViewModel ??
        widget.restaurantPickerCubit ??
        getIt<RestaurantPickerViewModel>();
    _mealSelectionViewModel =
        widget.mealSelectionViewModel ??
        widget.mealSelectionCubit ??
        getIt<MealSelectionViewModel>();
    _flowViewModel =
        widget.flowViewModel ??
        widget.flowCubit ??
        CalendarFlowViewModel(
          overviewViewModel: _overviewViewModel,
          restaurantPickerViewModel: _restaurantPickerViewModel,
          mealSelectionViewModel: _mealSelectionViewModel,
          overviewCubit: _overviewViewModel,
          restaurantPickerCubit: _restaurantPickerViewModel,
          mealSelectionCubit: _mealSelectionViewModel,
        );
    _coordinator = widget.coordinator ?? CalendarNavigationCoordinator();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _didLoad = true;
    unawaited(
      _overviewViewModel.loadCalendar(
        subscriptionId: widget.subscriptionId,
        localeName: context.localization.localeName,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      final subId = _overviewViewModel.state.subscriptionId;
      if (subId.isNotEmpty &&
          getIt.isRegistered<NotificationBadgeViewModel>()) {
        unawaited(
          getIt<NotificationBadgeViewModel>().refreshCount(
            subscriptionId: subId,
            localeName: context.localization.localeName,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_flowViewModel.close());
    unawaited(_mealSelectionViewModel.close());
    unawaited(_restaurantPickerViewModel.close());
    unawaited(_overviewViewModel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarOverviewViewModel>.value(value: _overviewViewModel),
        BlocProvider<RestaurantPickerViewModel>.value(
          value: _restaurantPickerViewModel,
        ),
        BlocProvider<MealSelectionViewModel>.value(
          value: _mealSelectionViewModel,
        ),
        BlocProvider<CalendarFlowViewModel>.value(value: _flowViewModel),
        if (getIt.isRegistered<NotificationBadgeViewModel>())
          BlocProvider<NotificationBadgeViewModel>.value(
            value: getIt<NotificationBadgeViewModel>(),
          ),
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
