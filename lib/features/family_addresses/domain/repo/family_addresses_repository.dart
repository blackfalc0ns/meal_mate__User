import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';

abstract interface class FamilyAddressesRepository {
  Future<ApiResult<List<CustomerAddressEntity>>> getAddresses(String memberId);
  Future<ApiResult<CustomerAddressEntity>> addAddress(
    String memberId,
    CustomerAddressRequestEntity request,
  );
  Future<ApiResult<CustomerAddressEntity>> updateAddress(
    String memberId,
    String addressId,
    CustomerAddressRequestEntity request,
  );
  Future<ApiResult<AddressCoveragePreviewEntity>> previewAddress(
    String memberId,
    CustomerAddressRequestEntity request, {
    int? page,
    int? pageSize,
  });
  Future<ApiResult<AddressCoveragePreviewEntity>> previewExistingAddress(
    String memberId,
    String addressId, {
    int? page,
    int? pageSize,
  });
  Future<ApiResult<CustomerAddressEntity>> setDefaultAddress(
    String memberId,
    String addressId,
  );
}
