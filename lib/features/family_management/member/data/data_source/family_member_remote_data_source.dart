import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_access_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_detail_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_permissions_response_dto.dart';

abstract interface class FamilyMemberRemoteDataSource {
  Future<FamilyMemberDetailResponseDto> getFamilyMemberDetail(String memberId);
  Future<FamilyMemberAccessResponseDto> getMemberAccess(String memberId);
  Future<FamilyMemberAccessResponseDto> updateMemberAccess(
    String memberId,
    UpdateFamilyMemberAccessRequestDto request,
  );
  Future<FamilyMemberPermissionsResponseDto> getMemberPermissions(String memberId);
  Future<FamilyMemberPermissionsResponseDto> updateMemberPermissions(
    String memberId,
    UpdateFamilyMemberPermissionsRequestDto request,
  );
  Future<void> updateMemberBasicInfo(
    String memberId,
    FamilyMemberWriteRequestDto request,
  );
  Future<void> renewMemberSubscription(String renewalPath);
}
