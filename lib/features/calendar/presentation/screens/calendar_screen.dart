import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_cubit.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/mapper/calendar_failure_message_mapper.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_meal_selection_screen.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_content.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_header.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meals_confirmation_sheet.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_selection_sheet.dart';
import 'package:meal_meat_user/features/meal_details/presentation/mapper/calendar_meal_details_mapper.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    this.showBottomSpace = false,
    this.subscriptionId,
    this.overviewCubit,
    this.restaurantPickerCubit,
    this.mealSelectionCubit,
    this.flowCubit,
    this.viewModel,
  });

  final bool showBottomSpace;
  final String? subscriptionId;
  final CalendarOverviewCubit? overviewCubit;
  final RestaurantPickerCubit? restaurantPickerCubit;
  final MealSelectionCubit? mealSelectionCubit;
  final CalendarFlowCubit? flowCubit;
  final CalendarViewModel? viewModel;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final CalendarOverviewCubit _overviewCubit;
  late final RestaurantPickerCubit _restaurantPickerCubit;
  late final MealSelectionCubit _mealSelectionCubit;
  late final CalendarFlowCubit _flowCubit;
  late final CalendarViewModel _viewModel;

  bool _restaurantSheetOpen = false;
  bool _mealSheetOpen = false;
  bool _suppressMealSheetAutoOpen = false;
  bool _didLoad = false;
  int _handledSaveSuccessCount = 0;
  int _handledConfirmSuccessCount = 0;
  Failure? _lastHandledConfirmFailure;
  Route<void>? _mealPickerRoute;
  final RoundedLoadingButtonController _mealSaveButtonController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _overviewCubit = widget.overviewCubit ?? getIt<CalendarOverviewCubit>();
    _restaurantPickerCubit =
        widget.restaurantPickerCubit ?? getIt<RestaurantPickerCubit>();
    _mealSelectionCubit =
        widget.mealSelectionCubit ?? getIt<MealSelectionCubit>();
    _flowCubit = widget.flowCubit ??
        CalendarFlowCubit(
          overviewCubit: _overviewCubit,
          restaurantPickerCubit: _restaurantPickerCubit,
          mealSelectionCubit: _mealSelectionCubit,
        );
    _viewModel = widget.viewModel ?? getIt<CalendarViewModel>();
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
    _viewModel.doIntent(
      LoadCalendarEvent(
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
    unawaited(_viewModel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarOverviewCubit>.value(value: _overviewCubit),
        BlocProvider<RestaurantPickerCubit>.value(
          value: _restaurantPickerCubit,
        ),
        BlocProvider<MealSelectionCubit>.value(value: _mealSelectionCubit),
        BlocProvider<CalendarFlowCubit>.value(value: _flowCubit),
        BlocProvider<CalendarViewModel>.value(value: _viewModel),
      ],
      child: BlocListener<CalendarViewModel, CalendarState>(
        listenWhen: (previous, current) =>
            previous.availableMeals != current.availableMeals ||
            previous.isAvailableMealsLoading !=
                current.isAvailableMealsLoading ||
            previous.isSaving != current.isSaving ||
            previous.saveSuccessCount != current.saveSuccessCount ||
            previous.isConfirming != current.isConfirming ||
            previous.confirmSuccessCount != current.confirmSuccessCount ||
            previous.confirmFailure != current.confirmFailure,
        listener: _handleStateSideEffects,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: color.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: color.surface,
            body: Column(
              children: [
                CalendarHeader(
                  title: locale.calendar_title,
                  onBackPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      try {
                        context.read<HomeCubit>().selectTab(0);
                      } catch (_) {}
                    }
                  },
                ),
                Expanded(
                  child: CalendarContent(
                    showBottomSpace: widget.showBottomSpace,
                    onSelectRestaurant: () => _openRestaurantPicker(context),
                    onMealTap: (meal, restaurant) =>
                        _openMealDetails(context, meal, restaurant),
                    onChangeMeal: () {
                      _suppressMealSheetAutoOpen = false;
                      // ignore: discarded_futures
                      _openMealPicker(context);
                      _viewModel.doIntent(
                        LoadCalendarAvailableMealsEvent(
                          localeName: locale.localeName,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleStateSideEffects(BuildContext context, CalendarState state) {
    if (state.availableMeals != null &&
        !_mealSheetOpen &&
        !_suppressMealSheetAutoOpen) {
      unawaited(_openMealPicker(context));
    }

    if (_mealSheetOpen &&
        state.saveSuccessCount != _handledSaveSuccessCount &&
        !state.isSaving &&
        state.saveFailure == null &&
        state.availableMeals == null) {
      _handledSaveSuccessCount = state.saveSuccessCount;
      CustomSnackbar.showSuccess(
        context: context,
        message: context.localization.calendar_meals_save_success,
      );
      _closeMealPickerRoute();
      _mealSaveButtonController.reset();
      return;
    }

    if (state.confirmSuccessCount != _handledConfirmSuccessCount &&
        !state.isConfirming &&
        state.confirmFailure == null) {
      _handledConfirmSuccessCount = state.confirmSuccessCount;
      if (_mealSheetOpen) {
        _closeMealPickerRoute();
        _mealSaveButtonController.reset();
      }
      CustomSnackbar.showSuccess(
        context: context,
        message: context.localization.calendar_confirm_meals_success,
      );
      unawaited(
        CalendarMealsConfirmationSheet.show(
          context,
          statusText: context.localization.calendar_status_awaiting_restaurant,
        ),
      );
      return;
    }

    if (state.confirmFailure != null &&
        !state.isConfirming &&
        state.confirmFailure != _lastHandledConfirmFailure) {
      _lastHandledConfirmFailure = state.confirmFailure;
      _mealSaveButtonController.stop();
      final message = _mapConfirmErrorMessage(context, state.confirmFailure);
      CustomSnackbar.showError(context: context, message: message);
    }

    if (_mealSheetOpen) {
      if (state.isSaving || state.isConfirming) {
        _mealSaveButtonController.start();
      } else {
        _mealSaveButtonController.stop();
      }
    }
  }

  String _mapConfirmErrorMessage(BuildContext context, Failure? failure) {
    return CalendarFailureMessageMapper.map(
      failure: failure,
      locale: context.localization,
    );
  }

  Future<void> _openRestaurantPicker(BuildContext context) async {
    if (_restaurantSheetOpen) return;
    _restaurantSheetOpen = true;
    final locale = context.localization;
    _viewModel.doIntent(
      LoadCalendarRestaurantsEvent(localeName: locale.localeName),
    );

    final selectedRestaurant =
        await showModalBottomSheet<CalendarRestaurantOptionEntity>(
          context: context,
          isScrollControlled: true,
          backgroundColor: context.colorScheme.surface,
          builder: (sheetContext) {
            return BlocProvider<CalendarViewModel>.value(
              value: _viewModel,
              child: const CalendarRestaurantSelectionSheet(),
            );
          },
        );

    _restaurantSheetOpen = false;

    if (selectedRestaurant == null || !mounted || !context.mounted) return;

    _suppressMealSheetAutoOpen = false;
    _viewModel.doIntent(
      SelectCalendarRestaurantEvent(
        restaurant: selectedRestaurant,
        localeName: locale.localeName,
      ),
    );
    await _openMealPicker(context, initialRestaurant: selectedRestaurant);
  }

  Future<void> _openMealPicker(
    BuildContext context, {
    CalendarRestaurantOptionEntity? initialRestaurant,
  }) async {
    if (_mealSheetOpen) return;
    _mealSheetOpen = true;
    final route = MaterialPageRoute<void>(
      builder: (_) {
        return BlocProvider<CalendarViewModel>.value(
          value: _viewModel,
          child: CalendarMealSelectionScreen(
            saveButtonController: _mealSaveButtonController,
            initialRestaurant: initialRestaurant,
          ),
        );
      },
    );
    _mealPickerRoute = route;
    await Navigator.of(context).push<void>(route);
    if (identical(_mealPickerRoute, route)) {
      _mealPickerRoute = null;
    }
    _mealSheetOpen = false;
    if (_viewModel.state.isAvailableMealsLoading ||
        _viewModel.state.availableMeals != null) {
      _suppressMealSheetAutoOpen = true;
    }
  }

  void _closeMealPickerRoute() {
    final route = _mealPickerRoute;
    final navigator = route?.navigator;
    _mealSheetOpen = false;
    _mealPickerRoute = null;

    if (route == null || navigator == null) return;
    if (route.isCurrent) {
      navigator.pop();
      return;
    }
    if (route.isActive) {
      navigator.removeRoute(route);
    }
  }

  void _openMealDetails(
    BuildContext context,
    CalendarMealEntity meal,
    CalendarRestaurantEntity? restaurant,
  ) {
    final locale = context.localization;
    unawaited(
      Navigator.of(context).pushNamed(
        AppRoutes.mealDetails,
        arguments: CalendarMealDetailsMapper.map(
          meal: meal,
          locale: locale,
          restaurantName: restaurant?.name.isNotEmpty == true
              ? restaurant!.name
              : locale.calendar_restaurant_name,
          restaurantLogoUrl: restaurant?.logoUrl,
          ratingValue: restaurant?.rating ?? '',
          deliveryWindow: restaurant?.deliveryWindow ?? '',
        ),
      ),
    );
  }
}
