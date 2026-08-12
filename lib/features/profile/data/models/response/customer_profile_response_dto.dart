import 'package:json_annotation/json_annotation.dart';

part 'customer_profile_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class CustomerProfileResponseDto {
  const CustomerProfileResponseDto({
    this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.preferredLanguage,
    this.defaultRegionId,
    this.deliveryAddressLine,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.dateOfBirth,
    this.onboardingCompleted,
    this.profileImageStorageKey,
    this.accountStatus,
  });

  final String? userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? preferredLanguage;
  final String? defaultRegionId;
  final String? deliveryAddressLine;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? dateOfBirth;
  final bool? onboardingCompleted;
  final String? profileImageStorageKey;
  final Object? accountStatus;

  factory CustomerProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerProfileResponseDtoFromJson(json);
}
