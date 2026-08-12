import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';

abstract interface class AddressesRepository {
  Future<ApiResult<LocationsCatalogEntity>> getLocationsCatalog(
    String countryCode,
  );

  Future<ApiResult<List<CustomerAddressEntity>>> getCustomerAddresses();

  Future<ApiResult<void>> addCustomerAddress(
    CustomerAddressRequestEntity request,
  );

  Future<ApiResult<void>> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestEntity request,
  );

  Future<ApiResult<void>> deleteCustomerAddress(String addressId);
}
