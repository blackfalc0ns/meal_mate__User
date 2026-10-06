import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';

abstract interface class AddressesRepository {
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
    CustomerAddressRequestEntity request, {
    int? page,
    int? pageSize,
  });

  Future<ApiResult<AddressCoveragePreviewEntity>>
  previewExistingAddressCoverage(String addressId, {int? page, int? pageSize});

  Future<ApiResult<CustomerAddressEntity>> confirmSetDefaultAddress(
    String addressId,
  );
}
