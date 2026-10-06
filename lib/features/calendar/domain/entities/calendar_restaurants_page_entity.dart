import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';

class CalendarRestaurantsPageEntity {
  const CalendarRestaurantsPageEntity({
    required this.restaurants,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  final List<CalendarRestaurantOptionEntity> restaurants;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
}
