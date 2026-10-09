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
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_state.dart';

@injectable
class RestaurantPickerViewModel extends Cubit<RestaurantPickerState> {
  RestaurantPickerViewModel(
    this._getRestaurantsUseCase,
    this._setDayRestaurantUseCase,
  ) : super(const RestaurantPickerState());

  final GetCalendarRestaurantsUseCase _getRestaurantsUseCase;
  final SetCalendarDayRestaurantUseCase _setDayRestaurantUseCase;

  int _restaurantRequestGeneration = 0;
  int _setRestaurantRequestGeneration = 0;

  String? _activeSubscriptionId;
  DateTime? _activeDate;
  String? _activeLocaleName;
  String? _activeQuery;

  void doIntent(RestaurantPickerEvent event) {
    switch (event) {
      case LoadRestaurantsEvent():
        unawaited(
          load(
            subscriptionId: event.subscriptionId,
            date: event.date,
            localeName: event.localeName,
            query: event.query,
          ),
        );
      case SelectRestaurantEvent():
        unawaited(
          selectRestaurant(
            subscriptionId: event.subscriptionId,
            date: event.date,
            restaurant: event.restaurant,
            localeName: event.localeName,
          ),
        );
      case ClearRestaurantPickerEvent():
        clear();
      case LoadMoreRestaurantsEvent():
        unawaited(loadMore());
      case RetryRestaurantsPageEvent():
        unawaited(retryLoadMore());
    }
  }

  Future<void> load({
    required String subscriptionId,
    required DateTime date,
    required String localeName,
    String? query,
  }) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    if (subscriptionId.isEmpty || dateStr.isEmpty) return;

    final normalizedQuery = (query != null && query.trim().isNotEmpty)
        ? query.trim()
        : null;
    _activeSubscriptionId = subscriptionId;
    _activeDate = date;
    _activeLocaleName = localeName;
    _activeQuery = normalizedQuery;

    final generation = ++_restaurantRequestGeneration;
    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        clearRestaurants: true,
        query: normalizedQuery,
        clearQuery: normalizedQuery == null,
        clearFailure: true,
        clearLoadMoreFailure: true,
        page: 0,
        totalCount: 0,
        totalPages: 0,
        hasNextPage: false,
        hasPreviousPage: false,
      ),
    );

    final result = await _getRestaurantsUseCase(
      subscriptionId: subscriptionId,
      date: dateStr,
      localeName: localeName,
      query: normalizedQuery,
      page: 1,
      pageSize: 20,
    );
    if (isClosed || generation != _restaurantRequestGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final hasNext =
            result.data.restaurants.isNotEmpty && result.data.hasNextPage;
        emit(
          state.copyWith(
            isLoading: false,
            restaurants: result.data.restaurants,
            page: result.data.page,
            pageSize: result.data.pageSize,
            totalCount: result.data.totalCount,
            totalPages: result.data.totalPages,
            hasNextPage: hasNext,
            hasPreviousPage: result.data.hasPreviousPage,
            clearFailure: true,
            clearLoadMoreFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading ||
        state.isLoadingMore ||
        !state.hasNextPage ||
        _activeSubscriptionId == null ||
        _activeDate == null ||
        _activeLocaleName == null) {
      return;
    }

    final generation = _restaurantRequestGeneration;
    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));

    final nextPage = state.page + 1;
    final dateStr = DateFormat('yyyy-MM-dd').format(_activeDate!);

    final result = await _getRestaurantsUseCase(
      subscriptionId: _activeSubscriptionId!,
      date: dateStr,
      localeName: _activeLocaleName!,
      query: _activeQuery,
      page: nextPage,
      pageSize: 20,
    );

    if (isClosed || generation != _restaurantRequestGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final existingIds = state.restaurants.map((e) => e.id).toSet();
        final newItems = result.data.restaurants
            .where((e) => !existingIds.contains(e.id))
            .toList();
        final merged = [...state.restaurants, ...newItems];
        final hasNext =
            result.data.restaurants.isNotEmpty && result.data.hasNextPage;

        emit(
          state.copyWith(
            isLoadingMore: false,
            restaurants: merged,
            page: result.data.page,
            pageSize: result.data.pageSize,
            totalCount: result.data.totalCount,
            totalPages: result.data.totalPages,
            hasNextPage: hasNext,
            hasPreviousPage: result.data.hasPreviousPage,
            clearLoadMoreFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isLoadingMore: false, loadMoreFailure: result.failure),
        );
    }
  }

  Future<void> retryLoadMore() async {
    if (state.loadMoreFailure != null) {
      await loadMore();
    }
  }

  Future<ApiResult<CalendarDayEntity>> selectRestaurant({
    required String subscriptionId,
    required DateTime date,
    required CalendarRestaurantOptionEntity restaurant,
    required String localeName,
  }) async {
    if (state.isSelecting) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: 'Selection already in progress',
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
    _activeSubscriptionId = null;
    _activeDate = null;
    _activeLocaleName = null;
    _activeQuery = null;
    emit(const RestaurantPickerState());
  }
}
