import 'package:json_annotation/json_annotation.dart';

part 'calendar_save_meals_request_dto.g.dart';

@JsonSerializable()
class CalendarSaveMealsRequestDto {
  const CalendarSaveMealsRequestDto({required this.mealId, required this.slot});

  final String mealId;
  final String slot;

  factory CalendarSaveMealsRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarSaveMealsRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarSaveMealsRequestDtoToJson(this);
}
