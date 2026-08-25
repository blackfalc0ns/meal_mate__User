import 'package:json_annotation/json_annotation.dart';

part 'calendar_set_restaurant_request_dto.g.dart';

@JsonSerializable()
class CalendarSetRestaurantRequestDto {
  const CalendarSetRestaurantRequestDto({required this.restaurantId});

  final String restaurantId;

  factory CalendarSetRestaurantRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarSetRestaurantRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CalendarSetRestaurantRequestDtoToJson(this);
}
