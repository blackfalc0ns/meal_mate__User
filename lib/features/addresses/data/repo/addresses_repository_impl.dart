import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/data/data_source/addresses_remote_data_source.dart';
import 'package:meal_meat_user/features/addresses/data/mapper/customer_address_mapper.dart';
import 'package:meal_meat_user/features/addresses/data/mapper/map_address_autofill_mapper.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/map_geocode_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/map_reverse_geocode_request_dto.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

@Injectable(as: AddressesRepository)
class AddressesRepositoryImpl implements AddressesRepository {
  AddressesRepositoryImpl(this._remoteDataSource);

  final AddressesRemoteDataSource _remoteDataSource;

  static final Map<String, LocationsCatalogEntity> _catalogCache = {};
  static final Map<String, LocationsCatalogEntity> _areaBlocksCache = {};

  static void clearLocationsCache() {
    _catalogCache.clear();
    _areaBlocksCache.clear();
  }

  @override
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode,
    String? areaId,
  ) {
    if (areaId == null) {
      final cachedCatalog = _catalogCache[countryCode];
      if (cachedCatalog != null && cachedCatalog.governorates.isNotEmpty) {
        return Future.value(ApiSuccessResult(data: cachedCatalog));
      }
    } else {
      final cachedArea = _areaBlocksCache[areaId];
      if (cachedArea != null) {
        return Future.value(ApiSuccessResult(data: cachedArea));
      }
    }

    return safeApiCall(() async {
      final response = await _remoteDataSource.getLocationsCatalog(
        countryCode,
        areaId,
      );
      final entity = response.toEntity();
      if (areaId == null) {
        if (entity.governorates.isNotEmpty) {
          _catalogCache[countryCode] = entity;
        }
      } else {
        _areaBlocksCache[areaId] = entity;
      }
      return entity;
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
  Future<ApiResult<AddressCoveragePreviewEntity>> previewNewAddressCoverage(
    CustomerAddressRequestEntity request, {
    int? page,
    int? pageSize,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.previewNewAddressCoverage(
        request.toPreviewDto(page: page, pageSize: pageSize),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>>
  previewExistingAddressCoverage(String addressId, {int? page, int? pageSize}) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.previewExistingAddressCoverage(
        addressId,
        page: page,
        pageSize: pageSize,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> confirmSetDefaultAddress(
    String addressId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.confirmSetDefaultAddress(
        addressId,
      );
      return response.toEntity();
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
