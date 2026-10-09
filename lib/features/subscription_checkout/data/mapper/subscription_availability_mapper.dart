import 'package:meal_meat_user/core/network/mapper/pagination_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_summary_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_restaurant_availability_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_restaurant_availability_entity.dart';

extension SubscriptionAvailabilityResponseDtoMapper
    on SubscriptionAvailabilityResponseDto {
  SubscriptionAvailabilityEntity toEntity() {
    return SubscriptionAvailabilityEntity(
      status: status ?? '',
      coveredRestaurantCount: coveredRestaurantCount ?? 0,
      eligibleRestaurantCount: eligibleRestaurantCount ?? 0,
      checkedAtUtc: checkedAtUtc != null && checkedAtUtc!.trim().isNotEmpty
          ? DateTime.tryParse(checkedAtUtc!.trim())
          : null,
      effectiveStartDate: effectiveStartDate ?? '',
      messageCode: messageCode ?? '',
    );
  }
}

extension SubscriptionRestaurantAvailabilityResponseDtoMapper
    on SubscriptionRestaurantAvailabilityResponseDto {
  SubscriptionRestaurantAvailabilityEntity toEntity() {
    return SubscriptionRestaurantAvailabilityEntity(
      availability: availability?.toEntity() ??
          const SubscriptionAvailabilityEntity(
            status: '',
            coveredRestaurantCount: 0,
            eligibleRestaurantCount: 0,
            effectiveStartDate: '',
            messageCode: '',
          ),
      totalCount: totalCount ?? 0,
      pagination: pagination?.toEntity(),
      restaurants: (restaurants ?? const [])
          .map((restaurant) => restaurant.toEntity())
          .toList(),
    );
  }
}
