import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_management/member/data/data_source/family_member_remote_data_source.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_write_request_dto.dart'
    as setup;
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_access_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_detail_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_permissions_response_dto.dart';

@Injectable(as: FamilyMemberRemoteDataSource)
class FamilyMemberRemoteDataSourceImpl implements FamilyMemberRemoteDataSource {
  const FamilyMemberRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<FamilyMemberDetailResponseDto> getFamilyMemberDetail(
    String memberId,
  ) => _apiServices.getFamilyMember(memberId);

  @override
  Future<FamilyMemberAccessResponseDto> getMemberAccess(String memberId) =>
      _apiServices.getFamilyMemberAccess(memberId);

  @override
  Future<FamilyMemberAccessResponseDto> updateMemberAccess(
    String memberId,
    UpdateFamilyMemberAccessRequestDto request,
  ) {
    return _apiServices.updateFamilyMemberAccess(
      memberId,
      FamilyMemberAccessRequestDto(
        hasSeparateAccount: request.hasSeparateAccount,
        isPaused: request.isPaused,
        remove: request.removeAccess,
        generateTemporaryPassword: request.generateTemporaryPassword,
      ),
    );
  }

  @override
  Future<FamilyMemberPermissionsResponseDto> getMemberPermissions(
    String memberId,
  ) => _apiServices.getFamilyMemberPermissions(memberId);

  @override
  Future<FamilyMemberPermissionsResponseDto> updateMemberPermissions(
    String memberId,
    UpdateFamilyMemberPermissionsRequestDto request,
  ) {
    return _apiServices.updateFamilyMemberPermissions(
      memberId,
      FamilyMemberPermissionsRequestDto(
        editDailyMeals: request.editDailyMeals,
        changeDeliveryTime: request.changeDeliveryTime,
        viewProgram: request.viewProgram,
        changeProgram: request.changeProgram,
        editMealsAndDays: request.editMealsAndDays,
        editAddress: request.editAddress,
        unitExchange: request.unitExchange,
        changePassword: request.changePassword,
        expectedVersion: request.expectedVersion,
      ),
    );
  }

  @override
  Future<void> updateMemberBasicInfo(
    String memberId,
    FamilyMemberWriteRequestDto request,
  ) {
    return _apiServices.updateFamilyMember(
      memberId,
      setup.FamilyMemberWriteRequestDto(
        displayName: request.displayName,
        relationshipCode: request.relationshipCode,
        gender: request.gender,
        ageYears: request.ageYears,
        deliveryAddressId: request.deliveryAddressId,
        phone: request.phone,
        occupation: request.occupation,
      ),
    );
  }

  @override
  Future<void> renewMemberSubscription(String renewalPath) =>
      _apiServices.createFamilyMemberRenewalRequest(renewalPath);
}
