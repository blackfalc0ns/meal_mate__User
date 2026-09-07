import 'package:meal_meat_user/features/addresses/data/models/request/address_coverage_preview_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/address_coverage_preview_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/customer_address_response_dto.dart';

abstract interface class FamilyAddressesRemoteDataSource {
  Future<List<CustomerAddressResponseDto>> getAddresses(String memberId);
  Future<CustomerAddressResponseDto> addAddress(
    String memberId,
    CustomerAddressRequestDto request,
  );
  Future<CustomerAddressResponseDto> updateAddress(
    String memberId,
    String addressId,
    CustomerAddressRequestDto request,
  );
  Future<AddressCoveragePreviewResponseDto> previewAddress(
    String memberId,
    AddressCoveragePreviewRequestDto request,
  );
  Future<AddressCoveragePreviewResponseDto> previewExistingAddress(
    String memberId,
    String addressId,
  );
  Future<CustomerAddressResponseDto> setDefaultAddress(
    String memberId,
    String addressId,
  );
}
