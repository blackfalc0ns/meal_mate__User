import 'package:meal_meat_user/core/address/data/models/request/map_geocode_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/map_reverse_geocode_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/locations_catalog_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/map_address_autofill_response_dto.dart';

abstract interface class AddressLocationRemoteDataSource {
  Future<LocationsCatalogResponseDto> getLocationsCatalog(
    String countryCode,
    String? areaId,
  );

  Future<MapAddressAutofillResponseDto> geocode(MapGeocodeRequestDto request);

  Future<MapAddressAutofillResponseDto> reverseGeocode(
    MapReverseGeocodeRequestDto request,
  );
}
