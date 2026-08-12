import 'package:meal_meat_user/features/profile/data/models/request/profile_image_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/update_customer_profile_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_profile_response_dto.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';

extension CustomerProfileResponseDtoMapper on CustomerProfileResponseDto {
  CustomerProfileEntity toEntity() {
    final imageStorageKey = profileImageStorageKey;

    return CustomerProfileEntity(
      userId: userId ?? '',
      fullName: fullName ?? '',
      email: email,
      phoneNumber: phoneNumber,
      preferredLanguage: preferredLanguage ?? 'ar',
      defaultRegionId: defaultRegionId,
      deliveryAddressLine: deliveryAddressLine,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      dateOfBirth: dateOfBirth,
      onboardingCompleted: onboardingCompleted ?? false,
      profileImageStorageKey: imageStorageKey,
      profileImageUrl: imageStorageKey.toUploadContentUrl(),
      accountStatus: accountStatus?.toString() ?? '',
    );
  }
}

extension _UploadContentUrlMapper on String? {
  String? toUploadContentUrl() {
    final storageKey = this;
    if (storageKey == null || storageKey.isEmpty) return null;

    final query = Uri(queryParameters: {'key': storageKey}).query;
    return '${NetworkConstants.baseUrl}${EndPoints.uploadContent}?$query';
  }
}

extension UpdateCustomerProfileRequestEntityMapper
    on UpdateCustomerProfileRequestEntity {
  UpdateCustomerProfileRequestDto toDto() {
    return UpdateCustomerProfileRequestDto(
      fullName: fullName,
      preferredLanguage: preferredLanguage,
      defaultRegionId: defaultRegionId,
      deliveryAddressLine: deliveryAddressLine,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      dateOfBirth: dateOfBirth,
    );
  }
}

extension ProfileImageRequestEntityMapper on ProfileImageRequestEntity {
  ProfileImageRequestDto toDto() {
    return ProfileImageRequestDto(storageKey: storageKey);
  }
}
