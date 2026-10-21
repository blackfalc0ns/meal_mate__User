import 'package:meal_meat_user/features/family_management/member/domain/entities/update_family_member_access_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/update_family_member_permissions_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_write_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';

extension UpdateFamilyMemberAccessRequestMapper
    on UpdateFamilyMemberAccessRequestEntity {
  UpdateFamilyMemberAccessRequestDto toDto() =>
      UpdateFamilyMemberAccessRequestDto(
        hasSeparateAccount: hasSeparateAccount,
        isPaused: isPaused,
        removeAccess: removeAccess,
        generateTemporaryPassword: generateTemporaryPassword,
        credentialOperationKey: credentialOperationKey,
      );
}

extension UpdateFamilyMemberPermissionsRequestMapper
    on UpdateFamilyMemberPermissionsRequestEntity {
  UpdateFamilyMemberPermissionsRequestDto toDto() =>
      UpdateFamilyMemberPermissionsRequestDto(
        expectedVersion: expectedVersion,
        patch: patch,
        editDailyMeals: editDailyMeals,
        changeDeliveryTime: changeDeliveryTime,
        viewProgram: viewProgram,
        changeProgram: changeProgram,
        editMealsAndDays: editMealsAndDays,
        editAddress: editAddress,
        unitExchange: unitExchange,
        changePassword: changePassword,
        viewCalendar: viewCalendar,
        viewInvoices: viewInvoices,
        selectRestaurant: selectRestaurant,
        confirmMeals: confirmMeals,
        requestFreeze: requestFreeze,
        requestRenewal: requestRenewal,
        requestUpgrade: requestUpgrade,
        cancelSubscription: cancelSubscription,
        viewFamilyCalendars: viewFamilyCalendars,
        viewFamilyPlans: viewFamilyPlans,
        viewFamilyInvoices: viewFamilyInvoices,
      );
}

extension FamilyMemberWriteRequestMapper on FamilyMemberWriteRequestEntity {
  FamilyMemberWriteRequestDto toDto() => FamilyMemberWriteRequestDto(
    displayName: displayName,
    relationshipCode: relationshipCode,
    gender: gender,
    ageYears: ageYears,
    deliveryAddressId: deliveryAddressId,
    phone: phone,
    occupation: occupation,
  );
}
