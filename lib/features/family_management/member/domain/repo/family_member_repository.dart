import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
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
    UpdateFamilyMemberAccessRequestDto request,
  );

  Future<ApiResult<FamilyMemberPermissionsEntity>> getMemberPermissions(
    String memberId, {
    String locale = 'ar',
  });

  Future<ApiResult<FamilyMemberPermissionsEntity>> updateMemberPermissions(
    String memberId,
    UpdateFamilyMemberPermissionsRequestDto request, {
    String locale = 'ar',
  });

  Future<ApiResult<void>> updateMemberBasicInfo(
    String memberId,
    FamilyMemberWriteRequestDto request,
  );

  Future<ApiResult<void>> renewMemberSubscription(String renewalPath);
}
