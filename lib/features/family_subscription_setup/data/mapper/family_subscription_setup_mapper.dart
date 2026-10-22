import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_member_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_relationship_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/core/address/data/mapper/customer_address_mapper.dart';
import 'package:meal_meat_user/features/food_preferences/data/mapper/food_preferences_mapper.dart';

extension FamilyRelationshipResponseDtoMapper on FamilyRelationshipResponseDto {
  FamilyRelationshipEntity toEntity() {
    return FamilyRelationshipEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      forDependents: forDependents ?? false,
      isPrimary: isPrimary ?? false,
    );
  }
}

extension FamilyMemberResponseDtoMapper on FamilyMemberResponseDto {
  FamilyMemberEntity toEntity() {
    return FamilyMemberEntity(
      memberId: memberId ?? '',
      memberSubscriptionId: memberSubscriptionId,
      currentSubscriptionId: currentSubscriptionId,
      upcomingSubscriptionId: upcomingSubscriptionId,
      customerUserId: customerUserId,
      phoneNumber: phoneNumber,
      occupation: occupation,
      startDate: startDate,
      role: role ?? 2,
      displayName: displayName ?? '',
      relationshipCode: relationshipCode ?? '',
      gender: gender ?? 1,
      ageYears: ageYears ?? 0,
      deliveryAddressId: deliveryAddressId,
      setupStatus: setupStatus ?? 0,
      readinessBlocker: readinessBlocker,
      programId: programId,
      bundleId: bundleId,
      selectedTier: selectedTier,
      durationDays: durationDays,
      includeFriday: includeFriday ?? false,
      isCurrentUser: isCurrentUser ?? false,
      deliveryAddress: deliveryAddress?.toEntity(),
      allergies: allergies?.map((item) => item.toEntity()).toList() ?? const [],
      allergiesCompleted: allergiesCompleted ?? false,
      dislikedFoods:
          dislikedFoods?.map((item) => item.toEntity()).toList() ?? const [],
      dietaryPreferences:
          dietaryPreferences?.map((item) => item.toEntity()).toList() ??
          const [],
      dietaryCompleted: dietaryCompleted ?? false,
      hasNoAllergies: hasNoAllergies ?? false,
      hasNoDietaryRestriction: hasNoDietaryRestriction ?? false,
      subscribeNow: subscribeNow ?? false,
      checkoutSelected: lifecycle?.checkoutSelected ?? subscribeNow ?? false,
      lifecycleStatus: lifecycle?.status,
    );
  }
}

extension FamilyFlowCurrentResponseDtoMapper on FamilyFlowCurrentResponseDto {
  FamilyFlowCurrentEntity toEntity() {
    return FamilyFlowCurrentEntity(
      familyGroupId: familyGroupId,
      name: name,
      status: status,
      selectedFamilyPackageId: selectedFamilyPackageId,
      packageNameAr: packageNameAr ?? packageName,
      packageNameEn: packageNameEn ?? packageName,
      minMembers: minMembers,
      maxMembers: maxMembers,
      discountPercent: discountPercent,
      currentStep: currentStep,
      managerPrepaid: managerPrepaid ?? false,
      members: members?.map((member) => member.toEntity()).toList() ?? const [],
      sessionExpired: sessionExpired ?? false,
      sessionExpiresAtUtc: sessionExpiresAtUtc != null
          ? DateTime.tryParse(sessionExpiresAtUtc!)
          : null,
      sessionMessage: sessionMessage,
      packageAvailable: packageAvailable ?? false,
      pendingCheckout: pendingCheckout != null
          ? FamilyPendingCheckoutEntity(
              familyGroupId: pendingCheckout!.familyGroupId,
              paymentAnchorSubscriptionId:
                  pendingCheckout!.paymentAnchorSubscriptionId,
              paymentUrl: pendingCheckout!.paymentUrl,
              holdExpiresAtUtc: pendingCheckout!.holdExpiresAtUtc != null
                  ? DateTime.tryParse(pendingCheckout!.holdExpiresAtUtc!)
                  : null,
              finalPrice: pendingCheckout!.finalPrice,
              batchId: pendingCheckout!.batchId,
              batchVersion: pendingCheckout!.batchVersion,
            )
          : null,
      retryPaymentEndpoint: retryPaymentEndpoint,
    );
  }
}
