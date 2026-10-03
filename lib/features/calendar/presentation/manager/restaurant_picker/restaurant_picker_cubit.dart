import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_state.dart';

@injectable
class RestaurantPickerCubit extends Cubit<RestaurantPickerState> {
  RestaurantPickerCubit(
    this._getRestaurantsUseCase,
    this._setDayRestaurantUseCase,
  ) : super(const RestaurantPickerState());

  final GetCalendarRestaurantsUseCase _getRestaurantsUseCase;
  final SetCalendarDayRestaurantUseCase _setDayRestaurantUseCase;

  int _restaurantRequestGeneration = 0;
  int _setRestaurantRequestGeneration = 0;

  Future<void> load({
    required String subscriptionId,
    required DateTime date,
    required String localeName,
    String? query,
  }) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    if (subscriptionId.isEmpty || dateStr.isEmpty) return;

    final generation = ++_restaurantRequestGeneration;
    emit(
      state.copyWith(
        isLoading: true,
        query: query,
        clearFailure: true,
      ),
    );

    final result = await _getRestaurantsUseCase(
      subscriptionId: subscriptionId,
      date: dateStr,
      localeName: localeName,
      query: query,
    );
    if (isClosed || generation != _restaurantRequestGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            restaurants: result.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<ApiResult<CalendarDayEntity>> selectRestaurant({
    required String subscriptionId,
    required DateTime date,
    required CalendarRestaurantOptionEntity restaurant,
    required String localeName,
  }) async {
    if (state.isSelecting && state.selectingRestaurantId == restaurant.id) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: 'Selection already in progress for this restaurant',
          code: 'already_selecting',
        ),
      );
    }

    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    if (subscriptionId.isEmpty || dateStr.isEmpty || restaurant.id.isEmpty) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: 'Invalid parameters',
          code: 'invalid_params',
        ),
      );
    }

    final generation = ++_setRestaurantRequestGeneration;
    emit(
      state.copyWith(
        isSelecting: true,
        selectingRestaurantId: restaurant.id,
        clearSelectFailure: true,
      ),
    );

    final result = await _setDayRestaurantUseCase(
      subscriptionId: subscriptionId,
      date: dateStr,
      restaurantId: restaurant.id,
      localeName: localeName,
    );

    if (isClosed || generation != _setRestaurantRequestGeneration) {
      return result;
    }

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSelecting: false,
            clearSelectingRestaurantId: true,
            clearSelectFailure: true,
          ),
        );
        return result;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSelecting: false,
            clearSelectingRestaurantId: true,
            selectFailure: result.failure,
          ),
        );
        return result;
    }
  }

  void clear() {
    _restaurantRequestGeneration++;
    _setRestaurantRequestGeneration++;
    emit(const RestaurantPickerState());
  }
}
