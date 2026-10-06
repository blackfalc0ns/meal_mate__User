import 'package:meal_meat_user/core/address/data/models/request/address_coverage_preview_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/address_coverage_pagination_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/address_coverage_preview_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/locations_catalog_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/region_catalog_response_dto.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_pagination_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';

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
      blockRegionId: blockRegionId,
      street: street,
      avenue: avenue,
      building: building,
      unit: unit,
      floor: floor,
      latitude: latitude,
      longitude: longitude,
      notes: notes,
      isDefault: isDefault ?? false,
      isDeliveryActive: isDeliveryActive ?? false,
      deliveryEffectiveFromUtc: deliveryEffectiveFromUtc,
      deliveryChangeNotice: deliveryChangeNotice,
      notifyOnDelivery: notifyOnDelivery ?? false,
      restaurantCoverageNotice: restaurantCoverageNotice?.toEntity(),
      servingRestaurants:
          servingRestaurants?.map((item) => item.toEntity()).toList() ??
          const [],
    );
  }
}

extension CustomerAddressCoverageNoticeDtoMapper
    on CustomerAddressCoverageNoticeDto {
  CustomerAddressCoverageNoticeEntity toEntity() {
    return CustomerAddressCoverageNoticeEntity(ar: ar ?? '', en: en ?? '');
  }
}

extension ServingRestaurantDtoMapper on ServingRestaurantDto {
  ServingRestaurantEntity toEntity() {
    return ServingRestaurantEntity(
      id: id ?? '',
      nameAr: nameAr ?? name ?? '',
      nameEn: nameEn ?? name ?? '',
      logoUrl: logoUrl,
      rating: rating,
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
      blockRegionId: blockRegionId,
      street: street,
      avenue: avenue,
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

extension RegionCatalogResponseDtoMapper on RegionCatalogResponseDto {
  LocationsCatalogEntity toEntity() {
    final activeRegions =
        regions
            ?.where((region) => region.isActive ?? true)
            .where((region) => region.id != null && region.id!.isNotEmpty)
            .toList() ??
        const <LocationRegionResponseDto>[];

    final blocksByAreaId = <String, List<LocationBlockEntity>>{};
    for (final region in activeRegions.where((region) => region.type == 3)) {
      final parentId = region.parentId;
      if (parentId == null || parentId.isEmpty) continue;
      blocksByAreaId
          .putIfAbsent(parentId, () => [])
          .add(region.toBlockEntity());
    }

    final areasByGovernorateId = <String, List<LocationAreaEntity>>{};
    for (final region in activeRegions.where((region) => region.type == 2)) {
      final parentId = region.parentId;
      if (parentId == null || parentId.isEmpty) continue;
      areasByGovernorateId
          .putIfAbsent(parentId, () => [])
          .add(region.toAreaEntity(blocksByAreaId[region.id] ?? const []));
    }

    final governorates = activeRegions
        .where((region) => region.type == 1)
        .map(
          (region) => region.toGovernorateEntity(
            areasByGovernorateId[region.id] ?? const [],
          ),
        )
        .toList();

    return LocationsCatalogEntity(
      countryId: id ?? '',
      countryCode: code ?? '',
      governorates: governorates,
    );
  }
}

extension LocationRegionResponseDtoMapper on LocationRegionResponseDto {
  LocationGovernorateEntity toGovernorateEntity(
    List<LocationAreaEntity> areas,
  ) {
    return LocationGovernorateEntity(
      id: id ?? '',
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      areas: areas,
    );
  }

  LocationAreaEntity toAreaEntity(List<LocationBlockEntity> blocks) {
    return LocationAreaEntity(
      id: id ?? '',
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      blocks: blocks,
    );
  }

  LocationBlockEntity toBlockEntity() {
    return LocationBlockEntity(
      id: id ?? '',
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
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

extension AddressCoveragePaginationResponseDtoMapper
    on AddressCoveragePaginationResponseDto {
  AddressCoveragePaginationEntity toEntity() {
    return AddressCoveragePaginationEntity(
      totalCount: totalCount,
      page: page,
      pageSize: pageSize,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
    );
  }
}

extension AddressCoveragePreviewResponseDtoMapper
    on AddressCoveragePreviewResponseDto {
  AddressCoveragePreviewEntity toEntity() {
    return AddressCoveragePreviewEntity(
      canSetAsDefault: canSetAsDefault,
      isCurrentSubscriptionRestaurantCovered:
          isCurrentSubscriptionRestaurantCovered,
      uncoveredRestaurantNameAr: uncoveredRestaurantNameAr,
      uncoveredRestaurantNameEn: uncoveredRestaurantNameEn,
      conflictMessage: conflictMessage,
      resolvedRegionId: resolvedRegionId,
      resolvedRegionNameAr: resolvedRegionNameAr,
      resolvedRegionNameEn: resolvedRegionNameEn,
      governorate: governorate,
      area: area,
      block: block,
      latitude: latitude,
      longitude: longitude,
      hasActiveSubscription: hasActiveSubscription,
      restaurantCoverageNotice: restaurantCoverageNotice?.toEntity(),
      servingRestaurants: servingRestaurants
          .map((item) => item.toEntity())
          .toList(),
      pagination: pagination?.toEntity(),
    );
  }
}

extension AddressCoveragePreviewRequestEntityMapper
    on CustomerAddressRequestEntity {
  AddressCoveragePreviewRequestDto toPreviewDto({int? page, int? pageSize}) {
    return AddressCoveragePreviewRequestDto(
      regionId: regionId,
      blockRegionId: blockRegionId,
      latitude: latitude,
      longitude: longitude,
      governorate: governorate,
      area: area,
      block: block,
      isDefault: isDefault,
      page: page,
      pageSize: pageSize,
    );
  }
}
