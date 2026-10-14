import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/address/data/models/request/address_coverage_preview_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/address_coverage_preview_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/family_addresses/data/models/request/family_delivery_address_request_dto.dart';
import 'package:meal_meat_user/features/family_addresses/data/models/response/family_delivery_address_response_dto.dart';
import 'package:meal_meat_user/features/family_addresses/data/data_source/family_addresses_remote_data_source.dart';

@Injectable(as: FamilyAddressesRemoteDataSource)
class FamilyAddressesRemoteDataSourceImpl
    implements FamilyAddressesRemoteDataSource {
  const FamilyAddressesRemoteDataSourceImpl(this._api);
  final ApiServices _api;
  @override
  Future<List<CustomerAddressResponseDto>> getAddresses(String memberId) =>
      _api.getFamilyMemberAddresses(memberId);
  @override
  Future<CustomerAddressResponseDto> addAddress(
    String memberId,
    CustomerAddressRequestDto request,
  ) => _api.addFamilyMemberAddress(memberId, request);
  @override
  Future<CustomerAddressResponseDto> updateAddress(
    String memberId,
    String addressId,
    CustomerAddressRequestDto request,
  ) => _api.updateFamilyMemberAddress(memberId, addressId, request);
  @override
  Future<AddressCoveragePreviewResponseDto> previewAddress(
    String memberId,
    AddressCoveragePreviewRequestDto request,
  ) => _api.previewFamilyMemberAddress(memberId, request);
  @override
  Future<AddressCoveragePreviewResponseDto> previewExistingAddress(
    String memberId,
    String addressId, {
    int? page,
    int? pageSize,
  }) => _api.previewExistingFamilyMemberAddress(
    memberId,
    addressId,
    page: page,
    pageSize: pageSize,
  );
  @override
  Future<CustomerAddressResponseDto> setDefaultAddress(
    String memberId,
    String addressId,
  ) => _api.setDefaultFamilyMemberAddress(
    memberId,
    addressId,
    const <String, dynamic>{},
  );
  @override
  Future<FamilyDeliveryAddressSnapshotResponseDto>
  getSubscriptionDeliveryAddress(String subscriptionId) =>
      _api.getSubscriptionDeliveryAddress(subscriptionId);
  @override
  Future<FamilyDeliveryAddressResultResponseDto>
  updateSubscriptionDeliveryAddress(
    String subscriptionId,
    FamilyDeliveryAddressRequestDto request,
  ) => _api.updateSubscriptionDeliveryAddress(subscriptionId, request);
}
