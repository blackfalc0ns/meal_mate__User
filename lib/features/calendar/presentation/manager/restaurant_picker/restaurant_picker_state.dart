import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';

class RestaurantPickerState {
  const RestaurantPickerState({
    this.restaurants = const [],
    this.query,
    this.isLoading = false,
    this.isSelecting = false,
    this.selectingRestaurantId,
    this.failure,
    this.selectFailure,
  });

  final List<CalendarRestaurantOptionEntity> restaurants;
  final String? query;
  final bool isLoading;
  final bool isSelecting;
  final String? selectingRestaurantId;
  final Failure? failure;
  final Failure? selectFailure;

  bool get hasRestaurants => restaurants.isNotEmpty;

  RestaurantPickerState copyWith({
    List<CalendarRestaurantOptionEntity>? restaurants,
    String? query,
    bool? isLoading,
    bool? isSelecting,
    String? selectingRestaurantId,
    Failure? failure,
    Failure? selectFailure,
    bool clearRestaurants = false,
    bool clearQuery = false,
    bool clearFailure = false,
    bool clearSelectFailure = false,
    bool clearSelectingRestaurantId = false,
  }) {
    return RestaurantPickerState(
      restaurants: clearRestaurants
          ? const []
          : restaurants ?? this.restaurants,
      query: clearQuery ? null : query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      isSelecting: isSelecting ?? this.isSelecting,
      selectingRestaurantId: clearSelectingRestaurantId
          ? null
          : selectingRestaurantId ?? this.selectingRestaurantId,
      failure: clearFailure ? null : failure ?? this.failure,
      selectFailure:
          clearSelectFailure ? null : selectFailure ?? this.selectFailure,
    );
  }
}
