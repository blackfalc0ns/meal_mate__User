import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';

abstract interface class FamilyManagementRepository {
  Future<ApiResult<FamilyHomeEntity>> getHome(String localeName);
  Future<ApiResult<List<FamilyMemberSummaryEntity>>> getMembers(
    String localeName,
  );
  Future<ApiResult<FamilyMemberDetailEntity>> getMember(
    String memberId,
    String localeName,
  );
  Future<ApiResult<FamilyMemberAccessEntityV2>> getAccess(String memberId);
  Future<ApiResult<FamilyMemberAccessEntityV2>> updateAccess({
    required String memberId,
    bool? hasSeparateAccount,
    bool? isPaused,
    bool? remove,
    int? expectedVersion,
  });
  Future<ApiResult<FamilyMemberPermissionsEntity>> getPermissions(
    String memberId,
    String localeName,
  );
  Future<ApiResult<FamilyMemberPermissionsEntity>> updatePermissions({
    required String memberId,
    required Map<String, bool> values,
    required String localeName,
    int? expectedVersion,
  });
  Future<ApiResult<void>> renewSubscription(String renewalPath);
}
