import 'package:meal_meat_user/core/address/data/models/request/address_coverage_preview_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/address_coverage_preview_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/family_addresses/data/models/request/family_delivery_address_request_dto.dart';
import 'package:meal_meat_user/features/family_addresses/data/models/response/family_delivery_address_response_dto.dart';

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
    String addressId, {
    int? page,
    int? pageSize,
  });
  Future<CustomerAddressResponseDto> setDefaultAddress(
    String memberId,
    String addressId,
  );
  Future<FamilyDeliveryAddressSnapshotResponseDto>
  getSubscriptionDeliveryAddress(String subscriptionId);
  Future<FamilyDeliveryAddressResultResponseDto>
  updateSubscriptionDeliveryAddress(
    String subscriptionId,
    FamilyDeliveryAddressRequestDto request,
  );
}
