import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_write_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/update_family_member_access_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/update_family_member_permissions_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';

abstract interface class FamilyMemberRepository {
  Future<ApiResult<FamilyMemberDetailEntity>> getFamilyMemberDetail(
    String memberId, {
    String locale = 'ar',
  });

  Future<ApiResult<FamilyMemberAccessEntity>> getMemberAccess(String memberId);

  Future<ApiResult<FamilyMemberAccessEntity>> updateMemberAccess(
    String memberId,
    UpdateFamilyMemberAccessRequestEntity request,
  );

  Future<ApiResult<FamilyMemberPermissionsEntity>> getMemberPermissions(
    String memberId, {
    String locale = 'ar',
  });

  Future<ApiResult<FamilyMemberPermissionsEntity>> updateMemberPermissions(
    String memberId,
    UpdateFamilyMemberPermissionsRequestEntity request, {
    String locale = 'ar',
  });

  Future<ApiResult<void>> updateMemberBasicInfo(
    String memberId,
    FamilyMemberWriteRequestEntity request,
  );

  Future<ApiResult<void>> renewMemberSubscription(String renewalPath);

  Future<ApiResult<List<FamilyCapabilityEntity>>> getMemberCapabilities(
    String memberId,
  );

  Future<ApiResult<void>> detachMember(String memberId);
}
