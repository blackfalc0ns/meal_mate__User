import 'package:json_annotation/json_annotation.dart';

part 'subscription_duration_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionDurationResponseDto {
  const SubscriptionDurationResponseDto({
    this.durationDays,
    this.nameAr,
    this.nameEn,
    this.selectionCount,
    this.isPopular,
    this.isCustom,
    this.minDays,
    this.maxDays,
    this.badge,
    this.supportsFriday,
    this.includeFriday,
    this.fridayDays,
    this.totalServiceDays,
    this.fridayOption,
    this.fridayAvailability,
  });

  final int? durationDays;
  final String? nameAr;
  final String? nameEn;
  final int? selectionCount;
  final bool? isPopular;
  final bool? isCustom;
  final int? minDays;
  final int? maxDays;
  final SubscriptionPlanBadgeResponseDto? badge;
  final bool? supportsFriday;
  final bool? includeFriday;
  final int? fridayDays;
  final int? totalServiceDays;
  final SubscriptionFridayOptionResponseDto? fridayOption;
  final SubscriptionFridayAvailabilityResponseDto? fridayAvailability;

  factory SubscriptionDurationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDurationResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionPlanBadgeResponseDto {
  const SubscriptionPlanBadgeResponseDto({this.code, this.nameAr, this.nameEn});

  final String? code;
  final String? nameAr;
  final String? nameEn;

  factory SubscriptionPlanBadgeResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionPlanBadgeResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionFridayOptionResponseDto {
  const SubscriptionFridayOptionResponseDto({
    this.code,
    this.nameAr,
    this.nameEn,
    this.defaultSelected,
    this.isEnabled,
  });

  final String? code;
  final String? nameAr;
  final String? nameEn;
  final bool? defaultSelected;
  final bool? isEnabled;

  factory SubscriptionFridayOptionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionFridayOptionResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionFridayAvailabilityResponseDto {
  const SubscriptionFridayAvailabilityResponseDto({
    this.isAvailable,
    this.restaurantCount,
    this.code,
    this.messageAr,
    this.messageEn,
    this.displayType,
  });

  final bool? isAvailable;
  final int? restaurantCount;
  final String? code;
  final String? messageAr;
  final String? messageEn;
  final String? displayType;

  factory SubscriptionFridayAvailabilityResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionFridayAvailabilityResponseDtoFromJson(json);
}
