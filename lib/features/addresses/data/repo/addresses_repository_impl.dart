import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/data/data_source/addresses_remote_data_source.dart';
import 'package:meal_meat_user/features/addresses/data/mapper/customer_address_mapper.dart';
import 'package:meal_meat_user/features/addresses/data/mapper/map_address_autofill_mapper.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/map_geocode_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/map_reverse_geocode_request_dto.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

@Injectable(as: AddressesRepository)
class AddressesRepositoryImpl implements AddressesRepository {
  AddressesRepositoryImpl(this._remoteDataSource);

  final AddressesRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode,
    String? areaId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getLocationsCatalog(
        countryCode,
        areaId,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<List<CustomerAddressEntity>>> getCustomerAddresses() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCustomerAddresses();
      return response.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> addCustomerAddress(
    CustomerAddressRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.addCustomerAddress(
        request.toDto(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateCustomerAddress(
        addressId,
        request.toDto(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> deleteCustomerAddress(String addressId) {
    return safeApiCall(() async {
      await _remoteDataSource.deleteCustomerAddress(addressId);
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
        MapReverseGeocodeRequestDto(
          latitude: latitude,
          longitude: longitude,
        ),
      );
      return response.toEntity();
    });
  }
}
