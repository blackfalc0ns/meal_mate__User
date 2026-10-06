import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';

abstract interface class AddressLocationRepository {
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode,
    String? areaId,
  );

  Future<ApiResult<MapAddressAutofillEntity>> geocode(
    String address, {
    String countryCode = 'KW',
  });

  Future<ApiResult<MapAddressAutofillEntity>> reverseGeocode(
    double latitude,
    double longitude,
  );
}
