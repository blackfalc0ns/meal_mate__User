import 'package:dio/dio.dart';
import 'package:meal_meat_user/features/profile/data/models/request/change_customer_password_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/food_preferences_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/profile_image_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/update_customer_profile_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/upload_file_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_profile_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/food_preferences_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/upload_file_response_dto.dart';
import 'package:meal_meat_user/features/profile/domain/entities/change_customer_password_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_request_entity.dart';

extension CustomerProfileResponseDtoMapper on CustomerProfileResponseDto {
  CustomerProfileEntity toEntity() {
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
      profileImageStorageKey: profileImageStorageKey,
      accountStatus: accountStatus?.toString() ?? '',
    );
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

extension UploadFileRequestEntityMapper on UploadFileRequestEntity {
  Future<UploadFileRequestDto> toDto() async {
    return UploadFileRequestDto(
      file: await MultipartFile.fromFile(filePath, filename: _fileName),
      scope: scope,
      folder: folder,
    );
  }

  String get _fileName {
    final normalized = filePath.replaceAll('\\', '/');
    return normalized.split('/').last;
  }
}

extension UploadFileResponseDtoMapper on UploadFileResponseDto {
  UploadFileEntity toEntity() {
    return UploadFileEntity(
      storageKey: storageKey ?? '',
      fileName: fileName ?? '',
      contentType: contentType ?? '',
      sizeBytes: sizeBytes ?? 0,
      readUrl: readUrl ?? '',
      folder: folder ?? '',
      scope: scope ?? '',
    );
  }
}

extension CustomerAddressResponseDtoMapper on CustomerAddressResponseDto {
  CustomerAddressEntity toEntity() {
    return CustomerAddressEntity(
      addressId: addressId ?? id ?? '',
      label: label ?? '',
      addressLine: addressLine ?? '',
      regionId: regionId,
      governorate: governorate,
      area: area,
      block: block,
      street: street,
      building: building,
      unit: unit,
      floor: floor,
      latitude: latitude,
      longitude: longitude,
      notes: notes,
      isDefault: isDefault ?? false,
      notifyOnDelivery: notifyOnDelivery ?? false,
    );
  }
}

extension CustomerAddressRequestEntityMapper on CustomerAddressRequestEntity {
  CustomerAddressRequestDto toDto() {
    return CustomerAddressRequestDto(
      label: label,
      addressLine: addressLine,
      regionId: regionId,
      governorate: governorate,
      area: area,
      block: block,
      street: street,
      building: building,
      unit: unit,
      floor: floor,
      latitude: latitude,
      longitude: longitude,
      notes: notes,
      isDefault: isDefault,
      notifyOnDelivery: notifyOnDelivery,
    );
  }
}

extension ChangeCustomerPasswordRequestEntityMapper
    on ChangeCustomerPasswordRequestEntity {
  ChangeCustomerPasswordRequestDto toDto() {
    return ChangeCustomerPasswordRequestDto(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}

extension FoodPreferencesResponseDtoMapper on FoodPreferencesResponseDto {
  FoodPreferencesEntity toEntity() {
    return FoodPreferencesEntity(
      dietaryPattern: dietaryPattern,
      allergies: allergies?.map((item) => item.toEntity()).toList() ?? const [],
      dislikedFoods:
          dislikedFoods?.map((item) => item.toEntity()).toList() ?? const [],
      notes: notes,
    );
  }
}

extension FoodPreferenceItemResponseDtoMapper on FoodPreferenceItemResponseDto {
  FoodPreferenceItemEntity toEntity() {
    return FoodPreferenceItemEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      severity: severity,
    );
  }
}

extension FoodPreferencesEntityMapper on FoodPreferencesEntity {
  FoodPreferencesRequestDto toDto() {
    return FoodPreferencesRequestDto(
      dietaryPattern: dietaryPattern,
      allergies: allergies.map((item) => item.toDto()).toList(),
      dislikedFoods: dislikedFoods.map((item) => item.toDto()).toList(),
      notes: notes,
    );
  }
}

extension FoodPreferenceItemEntityMapper on FoodPreferenceItemEntity {
  FoodPreferenceItemRequestDto toDto() {
    return FoodPreferenceItemRequestDto(
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      severity: severity,
    );
  }
}
