import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_effect.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_view_model.dart';

@injectable
class CalendarFlowViewModel extends Cubit<CalendarFlowState> {
  final CalendarOverviewViewModel overviewViewModel;
  final RestaurantPickerViewModel restaurantPickerViewModel;
  final MealSelectionViewModel mealSelectionViewModel;

  CalendarOverviewViewModel get overviewCubit => overviewViewModel;
  RestaurantPickerViewModel get restaurantPickerCubit =>
      restaurantPickerViewModel;
  MealSelectionViewModel get mealSelectionCubit => mealSelectionViewModel;

  int _nextEffectId = 1;

  CalendarFlowViewModel({
    CalendarOverviewViewModel? overviewViewModel,
    RestaurantPickerViewModel? restaurantPickerViewModel,
    MealSelectionViewModel? mealSelectionViewModel,
    CalendarOverviewViewModel? overviewCubit,
    RestaurantPickerViewModel? restaurantPickerCubit,
    MealSelectionViewModel? mealSelectionCubit,
  }) : overviewViewModel = (overviewViewModel ?? overviewCubit)!,
       restaurantPickerViewModel =
           (restaurantPickerViewModel ?? restaurantPickerCubit)!,
       mealSelectionViewModel = (mealSelectionViewModel ?? mealSelectionCubit)!,
       super(const CalendarFlowState());

  void doIntent(CalendarFlowEvent event) {
    switch (event) {
      case StartRestaurantPickerFlowEvent():
        openRestaurantPicker(localeName: event.localeName);
      case AcceptRestaurantFlowEvent():
        unawaited(
          selectRestaurant(
            restaurant: event.restaurant,
            localeName: event.localeName,
          ),
        );
      case SaveMealsFlowEvent():
        unawaited(saveMeals(localeName: event.localeName));
      case ConfirmMealsFlowEvent():
        unawaited(confirmMeals(localeName: event.localeName));
    }
  }

  void openRestaurantPicker({
    DateTime? date,
    String? subscriptionId,
    String? localeName,
  }) {
    if (overviewViewModel.state.selectedDay?.isEditable != true) return;
    final targetDate =
        date ??
        overviewViewModel.state.selectedDate ??
        overviewViewModel.state.selectedDay?.date;
    final targetSubId = (subscriptionId != null && subscriptionId.isNotEmpty)
        ? subscriptionId
        : overviewViewModel.state.subscriptionId;

    if (targetDate == null || targetSubId.isEmpty) return;

    unawaited(
      restaurantPickerViewModel.load(
        subscriptionId: targetSubId,
        date: targetDate,
        localeName: localeName ?? 'en',
      ),
    );

    emit(
      CalendarFlowState(
        effect: OpenRestaurantPickerEffect(
          id: _nextEffectId++,
          date: targetDate,
          subscriptionId: targetSubId,
        ),
      ),
    );
  }

  Future<void> selectRestaurant({
    required CalendarRestaurantOptionEntity restaurant,
    DateTime? date,
    String? subscriptionId,
    String? localeName,
  }) async {
    if (overviewViewModel.state.selectedDay?.isEditable != true) return;
    final targetDate =
        date ??
        overviewViewModel.state.selectedDate ??
        overviewViewModel.state.selectedDay?.date;
    final targetSubId = (subscriptionId != null && subscriptionId.isNotEmpty)
        ? subscriptionId
        : overviewViewModel.state.subscriptionId;

    if (targetDate == null || targetSubId.isEmpty) return;

    final effectiveLocale = localeName ?? 'en';

    unawaited(
      mealSelectionViewModel.load(
        subscriptionId: targetSubId,
        date: targetDate,
        restaurantId: restaurant.id,
        localeName: effectiveLocale,
        selectedRestaurant: restaurant,
      ),
    );

    emit(
      CalendarFlowState(
        effect: OpenMealPickerEffect(
          id: _nextEffectId++,
          date: targetDate,
          subscriptionId: targetSubId,
          restaurantId: restaurant.id,
          restaurant: restaurant,
        ),
      ),
    );

    final result = await restaurantPickerViewModel.selectRestaurant(
      subscriptionId: targetSubId,
      date: targetDate,
      restaurant: restaurant,
      localeName: effectiveLocale,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        overviewViewModel.replaceDay(data);
        unawaited(
          overviewViewModel.refreshDay(targetDate, localeName: effectiveLocale),
        );
        unawaited(
          overviewViewModel.loadCalendar(
            subscriptionId: targetSubId,
            localeName: effectiveLocale,
          ),
        );
      case ApiErrorResult(:final failure):
        _handleFailure(failure, targetDate, targetSubId, effectiveLocale);
    }
  }

  void openMealPicker({
    DateTime? date,
    String? subscriptionId,
    String? restaurantId,
    CalendarRestaurantOptionEntity? restaurant,
    String? localeName,
  }) {
    final day = overviewViewModel.state.selectedDay;
    if (overviewViewModel.state.selectedDay?.isEditable != true) return;
    final targetDate =
        date ?? overviewViewModel.state.selectedDate ?? day?.date;
    final targetSubId = (subscriptionId != null && subscriptionId.isNotEmpty)
        ? subscriptionId
        : overviewViewModel.state.subscriptionId;
    final targetRestId = restaurantId ?? restaurant?.id ?? day?.restaurant?.id;

    if (targetDate == null ||
        targetSubId.isEmpty ||
        targetRestId == null ||
        targetRestId.isEmpty) {
      return;
    }

    final effectiveLocale = localeName ?? 'en';
    unawaited(
      mealSelectionViewModel.load(
        subscriptionId: targetSubId,
        date: targetDate,
        restaurantId: targetRestId,
        localeName: effectiveLocale,
        selectedRestaurant: restaurant,
        initialSelectedMealIds:
            day?.meals.map((m) => m.id).toList() ?? const [],
      ),
    );

    emit(
      CalendarFlowState(
        effect: OpenMealPickerEffect(
          id: _nextEffectId++,
          date: targetDate,
          subscriptionId: targetSubId,
          restaurantId: targetRestId,
          restaurant: restaurant,
        ),
      ),
    );
  }

  Future<void> saveMeals({String? localeName}) async {
    if (overviewViewModel.state.selectedDay?.isEditable != true) return;
    final effectiveLocale = localeName ?? 'en';
    final result = await mealSelectionViewModel.save(
      localeName: effectiveLocale,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        overviewViewModel.replaceDay(data);
        mealSelectionViewModel.clear();
        final targetDate =
            data.date ?? overviewViewModel.state.selectedDate ?? DateTime.now();
        final subId = mealSelectionViewModel.state.subscriptionId.isNotEmpty
            ? mealSelectionViewModel.state.subscriptionId
            : overviewViewModel.state.subscriptionId;
        unawaited(
          overviewViewModel.refreshDay(targetDate, localeName: effectiveLocale),
        );
        unawaited(
          overviewViewModel.loadCalendar(
            subscriptionId: subId,
            localeName: effectiveLocale,
          ),
        );
        emit(
          CalendarFlowState(
            effect: MealsSavedEffect(id: _nextEffectId++, day: data),
          ),
        );
      case ApiErrorResult(:final failure):
        final date =
            mealSelectionViewModel.state.date ??
            overviewViewModel.state.selectedDate ??
            DateTime.now();
        final subId = mealSelectionViewModel.state.subscriptionId.isNotEmpty
            ? mealSelectionViewModel.state.subscriptionId
            : overviewViewModel.state.subscriptionId;
        _handleFailure(failure, date, subId, effectiveLocale);
    }
  }

  Future<void> confirmMeals({
    String? localeName,
    DateTime? date,
    String? subscriptionId,
  }) async {
    final day = overviewViewModel.state.selectedDay;
    if (overviewViewModel.state.selectedDay?.isEditable != true) return;
    final targetDate =
        date ?? overviewViewModel.state.selectedDate ?? day?.date;
    final targetSubscriptionId =
        subscriptionId ?? overviewViewModel.state.subscriptionId;
    final effectiveLocale = localeName ?? 'en';

    if (targetDate == null || targetSubscriptionId.isEmpty) return;

    final result = await mealSelectionViewModel.confirm(
      localeName: effectiveLocale,
      date: targetDate,
      subscriptionId: targetSubscriptionId,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        final currentMeals = day?.meals ?? const [];
        final confirmedDay = data.copyWith(
          meals: data.meals.isNotEmpty ? data.meals : currentMeals,
        );
        overviewViewModel.replaceDay(confirmedDay);
        unawaited(
          overviewViewModel.refreshDay(targetDate, localeName: effectiveLocale),
        );
        unawaited(
          overviewViewModel.loadCalendar(
            subscriptionId: targetSubscriptionId,
            localeName: effectiveLocale,
          ),
        );
        emit(
          CalendarFlowState(
            effect: MealsConfirmedEffect(
              id: _nextEffectId++,
              day: confirmedDay,
            ),
          ),
        );
      case ApiErrorResult(:final failure):
        _handleFailure(
          failure,
          targetDate,
          targetSubscriptionId,
          effectiveLocale,
        );
    }
  }

  Future<void> autoSelectMeals({String? localeName}) async {
    final day = overviewViewModel.state.selectedDay;
    final date = overviewViewModel.state.selectedDate ?? day?.date;
    final subscriptionId = overviewViewModel.state.subscriptionId;
    final effectiveLocale = localeName ?? 'en';

    if (date == null || subscriptionId.isEmpty || day?.isEditable != true) {
      return;
    }

    final result = await mealSelectionViewModel.autoSelect(
      localeName: effectiveLocale,
      date: date,
      subscriptionId: subscriptionId,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        overviewViewModel.replaceDay(data);
        final targetDate = data.date ?? date;
        unawaited(
          overviewViewModel.refreshDay(targetDate, localeName: effectiveLocale),
        );
        unawaited(
          overviewViewModel.loadCalendar(
            subscriptionId: subscriptionId,
            localeName: effectiveLocale,
          ),
        );
        emit(
          CalendarFlowState(
            effect: MealsSavedEffect(id: _nextEffectId++, day: data),
          ),
        );
      case ApiErrorResult(:final failure):
        _handleFailure(failure, date, subscriptionId, effectiveLocale);
    }
  }

  void closeMealPicker() {
    mealSelectionViewModel.clear();
    emit(CalendarFlowState(effect: CloseMealPickerEffect(id: _nextEffectId++)));
  }

  void clearEffect() {
    emit(const CalendarFlowState());
  }

  void _handleFailure(
    Failure failure,
    DateTime date,
    String subscriptionId,
    String localeName,
  ) {
    if (failure.code == SubscriptionErrorCodes.calendarSelectionLocked) {
      final day = overviewViewModel.state.selectedDay;
      if (day != null) {
        overviewViewModel.replaceDay(
          day.copyWith(canEdit: false, isLocked: true),
        );
      }
    } else if (failure.code == SubscriptionErrorCodes.calendarNoSafeBox) {
      if (subscriptionId.isNotEmpty) {
        unawaited(overviewViewModel.refreshDay(date, localeName: localeName));
        unawaited(
          overviewViewModel.loadCalendar(
            subscriptionId: subscriptionId,
            localeName: localeName,
          ),
        );
      }
    } else if (failure.code ==
        SubscriptionErrorCodes.calendarRestaurantCoverageUnavailable) {
      if (subscriptionId.isNotEmpty) {
        unawaited(overviewViewModel.refreshDay(date, localeName: localeName));
        unawaited(
          overviewViewModel.loadCalendar(
            subscriptionId: subscriptionId,
            localeName: localeName,
          ),
        );
        unawaited(
          restaurantPickerViewModel.load(
            subscriptionId: subscriptionId,
            date: date,
            localeName: localeName,
          ),
        );
      }
    } else if (failure.code == SubscriptionErrorCodes.calendarDayUnavailable ||
        failure.code == SubscriptionErrorCodes.freezePreparationFailed ||
        failure.code == SubscriptionErrorCodes.freezePreparationUnavailable ||
        failure.code == SubscriptionErrorCodes.replacementCapacityUnavailable ||
        failure.code ==
            SubscriptionErrorCodes.replacementRestaurantsUnavailable) {
      if (subscriptionId.isNotEmpty) {
        unawaited(
          overviewViewModel.loadCalendar(
            subscriptionId: subscriptionId,
            localeName: localeName,
          ),
        );
      }
    } else {
      if (subscriptionId.isNotEmpty) {
        unawaited(overviewViewModel.refreshDay(date, localeName: localeName));
      }
    }

    emit(
      CalendarFlowState(
        effect: CalendarFailureEffect(id: _nextEffectId++, failure: failure),
      ),
    );
  }

  @override
  Future<void> close() {
    // Never close child cubits; screen owns and closes each cubit instance once.
    return super.close();
  }
}
