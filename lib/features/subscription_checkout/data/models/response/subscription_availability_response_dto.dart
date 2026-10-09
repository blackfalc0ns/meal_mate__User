import 'package:json_annotation/json_annotation.dart';

part 'subscription_availability_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionAvailabilityResponseDto {
  const SubscriptionAvailabilityResponseDto({
    this.status,
    this.coveredRestaurantCount,
    this.eligibleRestaurantCount,
    this.checkedAtUtc,
    this.effectiveStartDate,
    this.messageCode,
  });

  final String? status;
  final int? coveredRestaurantCount;
  final int? eligibleRestaurantCount;
  final String? checkedAtUtc;
  final String? effectiveStartDate;
  final String? messageCode;

  factory SubscriptionAvailabilityResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SubscriptionAvailabilityResponseDtoFromJson(json);
}
