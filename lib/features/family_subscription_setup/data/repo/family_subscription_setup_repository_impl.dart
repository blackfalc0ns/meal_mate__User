import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/data_source/family_subscription_setup_remote_data_source.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/mapper/family_subscription_setup_mapper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_convert_from_individual_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_group_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_lookup_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_lookup_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';

@Injectable(as: FamilySubscriptionSetupRepository)
class FamilySubscriptionSetupRepositoryImpl
    implements FamilySubscriptionSetupRepository {
  FamilySubscriptionSetupRepositoryImpl(this._remoteDataSource);

  final FamilySubscriptionSetupRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<FamilyRelationshipEntity>>> getFamilyRelationships() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilyRelationships();
      return response.map((relationship) => relationship.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> getFamilySubscriptionCurrent() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getFamilySubscriptionCurrent();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> convertFromIndividual({
    String? name,
    String? familyPackageId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.convertFromIndividual(
        FamilyConvertFromIndividualRequestDto(
          name: name,
          familyPackageId: familyPackageId,
        ),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> abandonFamilyDraft() {
    return safeApiCall(() async {
      await _remoteDataSource.abandonFamilyDraft();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> updateFamilyGroup({
    required String name,
    String? familyPackageId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateFamilyGroup(
        FamilyGroupWriteRequestDto(
          name: name,
          familyPackageId: familyPackageId,
        ),
      );
      return response.toEntity();
    });
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
    return safeApiCall(() async {
      final response = await _remoteDataSource.addFamilyMember(
        FamilyMemberWriteRequestDto(
          phone: phone,
          displayName: displayName,
          occupation: occupation,
          relationshipCode: relationshipCode,
          gender: gender,
          ageYears: ageYears,
          deliveryAddressId: deliveryAddressId,
        ),
      );
      return response.toEntity();
    });
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
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateFamilyMember(
        memberId,
        FamilyMemberWriteRequestDto(
          phone: phone,
          displayName: displayName,
          occupation: occupation,
          relationshipCode: relationshipCode,
          gender: gender,
          ageYears: ageYears,
          deliveryAddressId: deliveryAddressId,
        ),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> deleteFamilyMember(
    String memberId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.deleteFamilyMember(memberId);
      return response.toEntity();
    });
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
