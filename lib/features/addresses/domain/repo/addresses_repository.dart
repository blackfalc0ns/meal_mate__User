import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/map_address_autofill_entity.dart';

abstract interface class AddressesRepository {
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode,
    String? areaId,
  );

  Future<ApiResult<List<CustomerAddressEntity>>> getCustomerAddresses();

  Future<ApiResult<CustomerAddressEntity>> addCustomerAddress(
    CustomerAddressRequestEntity request,
  );

  Future<ApiResult<CustomerAddressEntity>> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestEntity request,
  );

  Future<ApiResult<void>> deleteCustomerAddress(String addressId);

  Future<ApiResult<AddressCoveragePreviewEntity>> previewNewAddressCoverage(
    CustomerAddressRequestEntity request,
  );

  Future<ApiResult<AddressCoveragePreviewEntity>> previewExistingAddressCoverage(
    String addressId,
  );

  Future<ApiResult<CustomerAddressEntity>> confirmSetDefaultAddress(
    String addressId,
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
