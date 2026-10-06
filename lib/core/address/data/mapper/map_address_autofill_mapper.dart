import 'package:meal_meat_user/core/address/data/models/response/map_address_autofill_response_dto.dart';
import 'package:meal_meat_user/core/address/domain/entities/map_address_autofill_entity.dart';

extension MapAddressAutofillResponseDtoMapper on MapAddressAutofillResponseDto {
  MapAddressAutofillEntity toEntity() {
    return MapAddressAutofillEntity(
      formattedAddress: formattedAddress ?? '',
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
      governorate: governorate,
      area: area,
      block: block,
      street: street,
      avenue: avenue,
      building: building,
      suggestedRegionId: suggestedRegionId,
      suggestedRegionNameAr: suggestedRegionNameAr,
      suggestedGovernorateId: suggestedGovernorateId,
      suggestedGovernorateNameAr: suggestedGovernorateNameAr,
      suggestedBlockId: suggestedBlockId,
      suggestedBlockNameAr: suggestedBlockNameAr,
      suggestedRegionName: suggestedRegionName,
      suggestedGovernorateName: suggestedGovernorateName,
      suggestedBlockName: suggestedBlockName,
    );
  }
}
