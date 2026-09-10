import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/data/data_source/family_management_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/family_management_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/family_management_repository.dart';

@Injectable(as: FamilyManagementRepository)
class FamilyManagementRepositoryImpl implements FamilyManagementRepository {
  FamilyManagementRepositoryImpl(this._remoteDataSource);
  final FamilyManagementRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<FamilyHomeEntity>> getHome(String localeName) => safeApiCall(
    () async => (await _remoteDataSource.getHome()).toEntity(localeName),
  );
  @override
  Future<ApiResult<List<FamilyMemberSummaryEntity>>> getMembers(
    String localeName,
  ) => safeApiCall(
    () async => (await _remoteDataSource.getMembers())
        .map((item) => item.toEntity(localeName))
        .toList(),
  );
  @override
  Future<ApiResult<FamilyMemberDetailEntity>> getMember(
    String memberId,
    String localeName,
  ) => safeApiCall(
    () async =>
        (await _remoteDataSource.getMember(memberId)).toEntity(localeName),
  );
  @override
  Future<ApiResult<FamilyMemberAccessEntityV2>> getAccess(String memberId) =>
      safeApiCall(
        () async => (await _remoteDataSource.getAccess(memberId)).toEntity(),
      );
  @override
  Future<ApiResult<FamilyMemberAccessEntityV2>> updateAccess({
    required String memberId,
    bool? hasSeparateAccount,
    bool? isPaused,
    bool? remove,
  }) => safeApiCall(
    () async => (await _remoteDataSource.updateAccess(
      memberId,
      FamilyMemberAccessRequestDto(
        hasSeparateAccount: hasSeparateAccount,
        isPaused: isPaused,
        remove: remove,
      ),
    )).toEntity(),
  );
  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> getPermissions(
    String memberId,
    String localeName,
  ) => safeApiCall(
    () async =>
        (await _remoteDataSource.getPermissions(memberId)).toEntity(localeName),
  );
  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> updatePermissions({
    required String memberId,
    required Map<String, bool> values,
    required String localeName,
  }) => safeApiCall(
    () async => (await _remoteDataSource.updatePermissions(
      memberId,
      FamilyMemberPermissionsRequestDto(
        editDailyMeals: values['editDailyMeals'] ?? false,
        changeDeliveryTime: values['changeDeliveryTime'] ?? false,
        viewProgram: values['viewProgram'] ?? false,
        changeProgram: values['changeProgram'] ?? false,
        editMealsAndDays: values['editMealsAndDays'] ?? false,
        editAddress: values['editAddress'] ?? false,
        unitExchange: values['unitExchange'] ?? false,
        changePassword: values['changePassword'] ?? false,
      ),
    )).toEntity(localeName),
  );
  @override
  Future<ApiResult<void>> renewSubscription(String renewalPath) =>
      safeApiCall(() => _remoteDataSource.renewSubscription(renewalPath));
}
