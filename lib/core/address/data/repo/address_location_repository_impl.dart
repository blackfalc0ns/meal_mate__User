import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/address/data/data_source/address_location_cache.dart';
import 'package:meal_meat_user/core/address/data/data_source/address_location_remote_data_source.dart';
import 'package:meal_meat_user/core/address/data/mapper/customer_address_mapper.dart';
import 'package:meal_meat_user/core/address/data/mapper/map_address_autofill_mapper.dart';
import 'package:meal_meat_user/core/address/data/models/request/map_geocode_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/map_reverse_geocode_request_dto.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/core/address/domain/repo/address_location_repository.dart';
import 'package:meal_meat_user/core/network/api_results.dart';

@Injectable(as: AddressLocationRepository)
class AddressLocationRepositoryImpl implements AddressLocationRepository {
  AddressLocationRepositoryImpl(this._remoteDataSource, this._cache);

  final AddressLocationRemoteDataSource _remoteDataSource;
  final AddressLocationCache _cache;

  @override
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode,
    String? areaId,
  ) {
    return safeApiCall(() async {
      return _cache.getOrFetch(countryCode, areaId, () async {
        final response = await _remoteDataSource.getLocationsCatalog(
          countryCode,
          areaId,
        );
        return response.toEntity();
      });
    });
  }

  @override
  Future<ApiResult<MapAddressAutofillEntity>> geocode(
    String address, {
    String countryCode = 'KW',
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.geocode(
        MapGeocodeRequestDto(address: address, countryCode: countryCode),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<MapAddressAutofillEntity>> reverseGeocode(
    double latitude,
    double longitude,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.reverseGeocode(
        MapReverseGeocodeRequestDto(latitude: latitude, longitude: longitude),
      );
      return response.toEntity();
    });
  }
}
