import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';

part 'calendar_available_meals_response_dto.g.dart';

@JsonSerializable()
class CalendarAvailableMealsResponseDto {
  const CalendarAvailableMealsResponseDto({
    this.restaurant,
    this.meals,
    this.slotRequirements,
  });

  final CalendarRestaurantResponseDto? restaurant;
  final List<CalendarMealResponseDto>? meals;
  final List<CalendarSlotRequirementResponseDto>? slotRequirements;

  factory CalendarAvailableMealsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CalendarAvailableMealsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CalendarAvailableMealsResponseDtoToJson(this);
}
