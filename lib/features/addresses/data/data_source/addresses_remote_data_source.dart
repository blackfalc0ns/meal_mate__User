import 'package:meal_meat_user/core/address/data/models/request/address_coverage_preview_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/address_coverage_preview_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/customer_address_response_dto.dart';

abstract interface class AddressesRemoteDataSource {
  Future<List<CustomerAddressResponseDto>> getCustomerAddresses();

  Future<CustomerAddressResponseDto> addCustomerAddress(
    CustomerAddressRequestDto request,
  );

  Future<CustomerAddressResponseDto> updateCustomerAddress(
    String addressId,
    CustomerAddressRequestDto request,
  );

  Future<void> deleteCustomerAddress(String addressId);

  Future<AddressCoveragePreviewResponseDto> previewNewAddressCoverage(
    AddressCoveragePreviewRequestDto request,
  );

  Future<AddressCoveragePreviewResponseDto> previewExistingAddressCoverage(
    String addressId, {
    int? page,
    int? pageSize,
  });

  Future<CustomerAddressResponseDto> confirmSetDefaultAddress(String addressId);
}
