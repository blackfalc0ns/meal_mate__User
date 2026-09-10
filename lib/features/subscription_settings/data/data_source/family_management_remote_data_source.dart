import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_home_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_access_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_detail_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_permissions_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_summary_response_dto.dart';

abstract interface class FamilyManagementRemoteDataSource {
  Future<FamilyHomeResponseDto> getHome();
  Future<List<FamilyMemberSummaryResponseDto>> getMembers();
  Future<FamilyMemberDetailResponseDto> getMember(String memberId);
  Future<FamilyMemberAccessResponseDto> getAccess(String memberId);
  Future<FamilyMemberAccessResponseDto> updateAccess(
    String memberId,
    FamilyMemberAccessRequestDto request,
  );
  Future<FamilyMemberPermissionsResponseDto> getPermissions(String memberId);
  Future<FamilyMemberPermissionsResponseDto> updatePermissions(
    String memberId,
    FamilyMemberPermissionsRequestDto request,
  );
  Future<void> renewSubscription(String renewalPath);
}
