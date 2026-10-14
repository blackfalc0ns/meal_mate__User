import 'package:meal_meat_user/features/family_addresses/data/models/request/family_delivery_address_request_dto.dart';
import 'package:meal_meat_user/features/family_addresses/data/models/response/family_delivery_address_response_dto.dart';
import 'package:meal_meat_user/features/family_addresses/domain/entities/family_delivery_address_entity.dart';

extension FamilyDeliveryAddressRequestEntityMapper
    on FamilyDeliveryAddressRequestEntity {
  FamilyDeliveryAddressRequestDto toDto() => FamilyDeliveryAddressRequestDto(
        addressId: addressId,
        effectiveFromDate: effectiveFromDate,
        expectedVersion: expectedVersion,
      );
}

extension CustomerActiveDeliveryAddressDtoMapper
    on CustomerActiveDeliveryAddressDto {
  CustomerActiveDeliveryAddressEntity toEntity() =>
      CustomerActiveDeliveryAddressEntity(
        id: id ?? '',
        label: label,
        addressLine: addressLine ?? '',
      );
}

extension FamilyDeliveryAddressChoiceDtoMapper
    on FamilyDeliveryAddressChoiceDto {
  FamilyDeliveryAddressChoiceEntity toEntity() =>
      FamilyDeliveryAddressChoiceEntity(
        id: id ?? '',
        label: label,
        addressLine: addressLine ?? '',
        regionId: regionId,
      );
}

extension FamilyDeliveryAddressSnapshotResponseDtoMapper
    on FamilyDeliveryAddressSnapshotResponseDto {
  FamilyDeliveryAddressSnapshotEntity toEntity() =>
      FamilyDeliveryAddressSnapshotEntity(
        subscriptionId: subscriptionId ?? '',
        currentVersion: currentVersion ?? 0,
        acceptedAddress: acceptedAddress?.toEntity(),
        eligibleAddresses: eligibleAddresses?.map((e) => e.toEntity()).toList() ??
            const [],
      );
}

extension FamilyDeliveryAddressResultResponseDtoMapper
    on FamilyDeliveryAddressResultResponseDto {
  FamilyDeliveryAddressResultEntity toEntity() =>
      FamilyDeliveryAddressResultEntity(
        subscriptionId: subscriptionId ?? '',
        version: version ?? 0,
        amendmentId: amendmentId ?? '',
        effectiveFromDate: effectiveFromDate ?? '',
        affectedDayIds: affectedDayIds ?? const [],
        skippedDayIds: skippedDayIds ?? const [],
      );
}
