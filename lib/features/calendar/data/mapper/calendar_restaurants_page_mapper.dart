import 'package:meal_meat_user/features/calendar/data/mapper/calendar_mapper.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurants_page_entity.dart';

extension CalendarRestaurantsPageMapper on CalendarRestaurantsResponseDto {
  CalendarRestaurantsPageEntity toEntity({required String localeName}) {
    final rawRestaurants =
        restaurants ?? const <CalendarRestaurantResponseDto>[];
    final mappedOptions = rawRestaurants
        .map((r) => r.toOptionEntity(localeName))
        .where((r) => r.id.isNotEmpty)
        .toList(growable: false);

    final resolvedPage = page ?? 1;
    final resolvedPageSize =
        pageSize ?? (rawRestaurants.isNotEmpty ? rawRestaurants.length : 1);
    final resolvedTotalCount = totalCount ?? rawRestaurants.length;
    final resolvedTotalPages = totalPages ?? (rawRestaurants.isEmpty ? 0 : 1);
    final resolvedHasNextPage = hasNextPage ?? false;
    final resolvedHasPreviousPage = hasPreviousPage ?? false;

    return CalendarRestaurantsPageEntity(
      restaurants: mappedOptions,
      page: resolvedPage,
      pageSize: resolvedPageSize,
      totalCount: resolvedTotalCount,
      totalPages: resolvedTotalPages,
      hasNextPage: resolvedHasNextPage,
      hasPreviousPage: resolvedHasPreviousPage,
    );
  }
}
