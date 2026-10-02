part of 'calendar_mapper.dart';

extension CalendarSetRestaurantRequestMapper on String {
  CalendarSetRestaurantRequestDto toSetRestaurantDto() {
    return CalendarSetRestaurantRequestDto(restaurantId: this);
  }
}

extension CalendarMealRequestMapper on CalendarMealEntity {
  CalendarSaveMealsRequestDto toSaveMealsDto() {
    return CalendarSaveMealsRequestDto(mealId: id, slot: slot.toLowerCase());
  }
}
