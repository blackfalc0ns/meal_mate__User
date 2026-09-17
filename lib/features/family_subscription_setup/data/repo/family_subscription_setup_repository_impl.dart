import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/data_source/family_subscription_setup_remote_data_source.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/mapper/family_subscription_setup_mapper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_convert_from_individual_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_group_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_lookup_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_lookup_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';

@LazySingleton(as: FamilySubscriptionSetupRepository)
class FamilySubscriptionSetupRepositoryImpl
    implements FamilySubscriptionSetupRepository {
  FamilySubscriptionSetupRepositoryImpl(
    this._remoteDataSource,
    this._snapshotStore,
  );

  final FamilySubscriptionSetupRemoteDataSource _remoteDataSource;
  final FamilyFlowSnapshotStore _snapshotStore;
  Future<ApiResult<FamilyFlowCurrentEntity>>? _currentRequest;

  @override
  Future<ApiResult<List<FamilyRelationshipEntity>>> getFamilyRelationships() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilyRelationships();
      return response.map((relationship) => relationship.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> getFamilySubscriptionCurrent() {
    final snapshot = _snapshotStore.current;
    if (snapshot != null) {
      return Future.value(ApiSuccessResult(data: snapshot));
    }
    final inFlight = _currentRequest;
    if (inFlight != null) return inFlight;
    final requestRevision = _snapshotStore.revision;
    final request = safeApiCall(() async {
      final response = await _remoteDataSource.getFamilySubscriptionCurrent();
      return response.toEntity();
    });
    _currentRequest = request;
    return request
        .then((result) {
          if (result is ApiSuccessResult<FamilyFlowCurrentEntity>) {
            _snapshotStore.updateIfUnchanged(requestRevision, result.data);
          }
          return result;
        })
        .whenComplete(() => _currentRequest = null);
  }

  Future<ApiResult<FamilyFlowCurrentEntity>> _flowMutation(
    Future<FamilyFlowCurrentResponseDto> Function() call,
  ) {
    return safeApiCall(() async {
      final entity = (await call()).toEntity();
      _snapshotStore.update(entity);
      return entity;
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> convertFromIndividual({
    String? name,
    String? familyPackageId,
  }) {
    return _flowMutation(
      () => _remoteDataSource.convertFromIndividual(
        FamilyConvertFromIndividualRequestDto(
          name: name,
          familyPackageId: familyPackageId,
        ),
      ),
    );
  }

  @override
  Future<ApiResult<void>> abandonFamilyDraft() {
    return safeApiCall(() async {
      await _remoteDataSource.abandonFamilyDraft();
      _snapshotStore.invalidate();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> updateFamilyGroup({
    required String name,
    String? familyPackageId,
  }) {
    return _flowMutation(
      () => _remoteDataSource.updateFamilyGroup(
        FamilyGroupWriteRequestDto(
          name: name,
          familyPackageId: familyPackageId,
        ),
      ),
    );
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> addFamilyMember({
    required String phone,
    required String displayName,
    String? occupation,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  }) {
    return _flowMutation(
      () => _remoteDataSource.addFamilyMember(
        FamilyMemberWriteRequestDto(
          phone: phone.trim().isEmpty ? null : phone.trim(),
          displayName: displayName,
          occupation: occupation,
          relationshipCode: relationshipCode,
          gender: gender,
          ageYears: ageYears,
          deliveryAddressId: deliveryAddressId,
        ),
      ),
    );
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> updateFamilyMember({
    required String memberId,
    required String phone,
    required String displayName,
    String? occupation,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  }) {
    return _flowMutation(
      () => _remoteDataSource.updateFamilyMember(
        memberId,
        FamilyMemberWriteRequestDto(
          phone: phone.trim().isEmpty ? null : phone.trim(),
          displayName: displayName,
          occupation: occupation,
          relationshipCode: relationshipCode,
          gender: gender,
          ageYears: ageYears,
          deliveryAddressId: deliveryAddressId,
        ),
      ),
    );
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> deleteFamilyMember(
    String memberId,
  ) {
    return _flowMutation(() => _remoteDataSource.deleteFamilyMember(memberId));
  }

  @override
  Future<ApiResult<FamilyMemberLookupEntity>> lookupFamilyMember(String phone) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.lookupFamilyMember(
        FamilyMemberLookupRequestDto(phone: phone),
      );
      return response.toEntity();
    });
  }
}
