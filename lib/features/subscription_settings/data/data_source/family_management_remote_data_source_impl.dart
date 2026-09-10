import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/subscription_settings/data/data_source/family_management_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_home_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_access_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_detail_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_permissions_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_summary_response_dto.dart';

@Injectable(as: FamilyManagementRemoteDataSource)
class FamilyManagementRemoteDataSourceImpl
    implements FamilyManagementRemoteDataSource {
  FamilyManagementRemoteDataSourceImpl(this._apiServices);
  final ApiServices _apiServices;

  @override
  Future<FamilyHomeResponseDto> getHome() => _apiServices.getFamilyHome();
  @override
  Future<List<FamilyMemberSummaryResponseDto>> getMembers() =>
      _apiServices.getFamilyMembers();
  @override
  Future<FamilyMemberDetailResponseDto> getMember(String memberId) =>
      _apiServices.getFamilyMember(memberId);
  @override
  Future<FamilyMemberAccessResponseDto> getAccess(String memberId) =>
      _apiServices.getFamilyMemberAccess(memberId);
  @override
  Future<FamilyMemberAccessResponseDto> updateAccess(
    String memberId,
    FamilyMemberAccessRequestDto request,
  ) => _apiServices.updateFamilyMemberAccess(memberId, request);
  @override
  Future<FamilyMemberPermissionsResponseDto> getPermissions(String memberId) =>
      _apiServices.getFamilyMemberPermissions(memberId);
  @override
  Future<FamilyMemberPermissionsResponseDto> updatePermissions(
    String memberId,
    FamilyMemberPermissionsRequestDto request,
  ) => _apiServices.updateFamilyMemberPermissions(memberId, request);
  @override
  Future<void> renewSubscription(String renewalPath) =>
      _apiServices.createFamilyMemberRenewalRequest(renewalPath);
}
