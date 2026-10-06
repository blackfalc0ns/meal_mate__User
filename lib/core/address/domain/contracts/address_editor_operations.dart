import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';

enum AddressEditorAction { add, update, setDefault }

abstract interface class AddressEditorOperations {
  Set<AddressEditorAction> get supportedActions;

  Future<ApiResult<AddressCoveragePreviewEntity>> previewNew(
    CustomerAddressRequestEntity request, {
    int? page,
    int? pageSize,
  });

  Future<ApiResult<AddressCoveragePreviewEntity>> previewExisting(
    String addressId, {
    int? page,
    int? pageSize,
  });

  Future<ApiResult<CustomerAddressEntity>> add(
    CustomerAddressRequestEntity request,
  );

  Future<ApiResult<CustomerAddressEntity>> update(
    String addressId,
    CustomerAddressRequestEntity request,
  );

  Future<ApiResult<CustomerAddressEntity>> setDefault(String addressId);
}
