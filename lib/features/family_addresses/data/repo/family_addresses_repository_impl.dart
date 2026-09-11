import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/data/mapper/customer_address_mapper.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/family_addresses/data/data_source/family_addresses_remote_data_source.dart';
import 'package:meal_meat_user/features/family_addresses/domain/repo/family_addresses_repository.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';

@Injectable(as: FamilyAddressesRepository)
class FamilyAddressesRepositoryImpl implements FamilyAddressesRepository {
  const FamilyAddressesRepositoryImpl(this._remote, this._snapshotStore);
  final FamilyAddressesRemoteDataSource _remote;
  final FamilyFlowSnapshotStore _snapshotStore;
  @override
  Future<ApiResult<List<CustomerAddressEntity>>> getAddresses(
    String memberId,
  ) => safeApiCall(
    () async => (await _remote.getAddresses(
      memberId,
    )).map((e) => e.toEntity()).toList(),
  );
  @override
  Future<ApiResult<CustomerAddressEntity>> addAddress(
    String memberId,
    CustomerAddressRequestEntity request,
  ) => safeApiCall(() async {
    final entity = (await _remote.addAddress(
      memberId,
      request.toDto(),
    )).toEntity();
    _snapshotStore.invalidate();
    return entity;
  });
  @override
  Future<ApiResult<CustomerAddressEntity>> updateAddress(
    String memberId,
    String addressId,
    CustomerAddressRequestEntity request,
  ) => safeApiCall(() async {
    final entity = (await _remote.updateAddress(
      memberId,
      addressId,
      request.toDto(),
    )).toEntity();
    _snapshotStore.invalidate();
    return entity;
  });
  @override
  Future<ApiResult<AddressCoveragePreviewEntity>> previewAddress(
    String memberId,
    CustomerAddressRequestEntity request,
  ) => safeApiCall(
    () async => (await _remote.previewAddress(
      memberId,
      request.toPreviewDto(),
    )).toEntity(),
  );
  @override
  Future<ApiResult<AddressCoveragePreviewEntity>> previewExistingAddress(
    String memberId,
    String addressId,
  ) => safeApiCall(
    () async =>
        (await _remote.previewExistingAddress(memberId, addressId)).toEntity(),
  );
  @override
  Future<ApiResult<CustomerAddressEntity>> setDefaultAddress(
    String memberId,
    String addressId,
  ) => safeApiCall(() async {
    final entity = (await _remote.setDefaultAddress(
      memberId,
      addressId,
    )).toEntity();
    _snapshotStore.invalidate();
    return entity;
  });
}
