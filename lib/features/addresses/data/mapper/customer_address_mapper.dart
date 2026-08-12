import 'package:meal_meat_user/features/addresses/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/locations_catalog_response_dto.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';

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

extension LocationsCatalogResponseDtoMapper on LocationsCatalogResponseDto {
  LocationsCatalogEntity toEntity() {
    return LocationsCatalogEntity(
      countryId: countryId ?? '',
      countryCode: countryCode ?? '',
      governorates:
          governorates?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension LocationGovernorateResponseDtoMapper
    on LocationGovernorateResponseDto {
  LocationGovernorateEntity toEntity() {
    return LocationGovernorateEntity(
      id: id ?? '',
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      areas: areas?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension LocationAreaResponseDtoMapper on LocationAreaResponseDto {
  LocationAreaEntity toEntity() {
    return LocationAreaEntity(
      id: id ?? '',
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      blocks: blocks?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension LocationBlockResponseDtoMapper on LocationBlockResponseDto {
  LocationBlockEntity toEntity() {
    return LocationBlockEntity(
      id: id ?? '',
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
    );
  }
}
