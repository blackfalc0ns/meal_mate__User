import 'package:meal_meat_user/core/errors/failures.dart';
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
    this.page = 0,
    this.pageSize = 20,
    this.totalCount = 0,
    this.totalPages = 0,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  final List<CalendarRestaurantOptionEntity> restaurants;
  final String? query;
  final bool isLoading;
  final bool isSelecting;
  final String? selectingRestaurantId;
  final Failure? failure;
  final Failure? selectFailure;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;

  bool get hasRestaurants => restaurants.isNotEmpty;

  List<CalendarRestaurantOptionEntity> restaurantsWithUsageLimits() =>
      restaurants;

  RestaurantPickerState copyWith({
    List<CalendarRestaurantOptionEntity>? restaurants,
    String? query,
    bool? isLoading,
    bool? isSelecting,
    String? selectingRestaurantId,
    Failure? failure,
    Failure? selectFailure,
    int? page,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    bool? isLoadingMore,
    Failure? loadMoreFailure,
    bool clearRestaurants = false,
    bool clearQuery = false,
    bool clearFailure = false,
    bool clearSelectFailure = false,
    bool clearSelectingRestaurantId = false,
    bool clearLoadMoreFailure = false,
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
      selectFailure: clearSelectFailure
          ? null
          : selectFailure ?? this.selectFailure,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailure: clearLoadMoreFailure
          ? null
          : loadMoreFailure ?? this.loadMoreFailure,
    );
  }
}
