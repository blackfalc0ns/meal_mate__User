import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/core/network/models/response/pagination_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';

part 'subscription_restaurant_availability_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionRestaurantAvailabilityResponseDto {
  const SubscriptionRestaurantAvailabilityResponseDto({
    this.availability,
    this.totalCount,
    this.pagination,
    this.restaurants,
  });

  final SubscriptionAvailabilityResponseDto? availability;
  final int? totalCount;
  final PaginationResponseDto? pagination;
  final List<SubscriptionSummaryRestaurantResponseDto>? restaurants;

  factory SubscriptionRestaurantAvailabilityResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SubscriptionRestaurantAvailabilityResponseDtoFromJson(json);
}
