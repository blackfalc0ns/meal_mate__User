import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_management/member/data/data_source/family_member_remote_data_source.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_write_request_dto.dart'
    as setup;
import 'package:meal_meat_user/features/family_management/member/data/models/request/api/family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/api/family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/response/api/family_member_access_response_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/response/api/family_member_detail_response_dto.dart';
import 'package:meal_meat_user/features/family_context/data/models/response/family_context_response_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/response/api/family_member_permissions_response_dto.dart';

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
        credentialOperationKey: request.credentialOperationKey,
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
        expectedVersion: request.expectedVersion,
        patch: request.patch,
        editDailyMeals: request.editDailyMeals,
        viewProgram: request.viewProgram,
        editMealsAndDays: request.editMealsAndDays,
        editAddress: request.editAddress,
        unitExchange: request.unitExchange,
        changePassword: request.changePassword,
        viewCalendar: request.viewCalendar,
        viewInvoices: request.viewInvoices,
        selectRestaurant: request.selectRestaurant,
        confirmMeals: request.confirmMeals,
        requestFreeze: request.requestFreeze,
        requestRenewal: request.requestRenewal,
        requestUpgrade: request.requestUpgrade,
        cancelSubscription: request.cancelSubscription,
        viewFamilyCalendars: request.viewFamilyCalendars,
        viewFamilyPlans: request.viewFamilyPlans,
        viewFamilyInvoices: request.viewFamilyInvoices,
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

  @override
  Future<List<FamilyCapabilityResponseDto>> getMemberCapabilities(
    String memberId,
  ) =>
      _apiServices.getFamilyMemberCapabilities(memberId);

  @override
  Future<void> detachMember(String memberId) =>
      _apiServices.detachFamilyMember(memberId);
}
