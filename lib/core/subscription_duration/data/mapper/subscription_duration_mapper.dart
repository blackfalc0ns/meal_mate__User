import 'package:meal_meat_user/core/subscription_duration/data/models/response/subscription_duration_response_dto.dart';
import 'package:meal_meat_user/core/subscription_duration/domain/entities/subscription_duration_entity.dart';

extension SubscriptionDurationResponseDtoMapper
    on SubscriptionDurationResponseDto {
  SubscriptionDurationEntity toEntity() {
    return SubscriptionDurationEntity(
      durationDays: durationDays,
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      selectionCount: selectionCount ?? 0,
      isPopular: isPopular ?? false,
      isCustom: isCustom ?? false,
      minDays: minDays,
      maxDays: maxDays,
      badge: badge?.toEntity(),
      supportsFriday: supportsFriday ?? false,
      includeFriday: includeFriday ?? false,
      fridayDays: fridayDays ?? 0,
      totalServiceDays: totalServiceDays ?? durationDays ?? 0,
      fridayOption:
          fridayOption?.toEntity() ??
          const SubscriptionFridayOptionEntity(
            code: '',
            nameAr: '',
            nameEn: '',
            defaultSelected: false,
            isEnabled: false,
          ),
      fridayAvailability:
          fridayAvailability?.toEntity() ??
          const SubscriptionFridayAvailabilityEntity(
            isAvailable: false,
            restaurantCount: 0,
            code: '',
            messageAr: '',
            messageEn: '',
            displayType: '',
          ),
    );
  }
}

extension SubscriptionPlanBadgeResponseDtoMapper
    on SubscriptionPlanBadgeResponseDto {
  SubscriptionPlanBadgeEntity toEntity() {
    return SubscriptionPlanBadgeEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
    );
  }
}

extension SubscriptionFridayOptionResponseDtoMapper
    on SubscriptionFridayOptionResponseDto {
  SubscriptionFridayOptionEntity toEntity() {
    return SubscriptionFridayOptionEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      defaultSelected: defaultSelected ?? false,
      isEnabled: isEnabled ?? false,
    );
  }
}

extension SubscriptionFridayAvailabilityResponseDtoMapper
    on SubscriptionFridayAvailabilityResponseDto {
  SubscriptionFridayAvailabilityEntity toEntity() {
    return SubscriptionFridayAvailabilityEntity(
      isAvailable: isAvailable ?? false,
      restaurantCount: restaurantCount ?? 0,
      code: code ?? '',
      messageAr: messageAr ?? '',
      messageEn: messageEn ?? '',
      displayType: displayType ?? '',
    );
  }
}
