import 'package:meal_meat_user/features/family_plans/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_group_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_member_plan_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/request/family_member_request_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_checkout_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_group_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_metadata_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_payment_method_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_response_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_metadata_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_plan_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_payment_method_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_summary_entity.dart';

extension FamilyMetadataResponseDtoMapper on FamilyMetadataResponseDto {
  FamilyMetadataEntity toEntity() {
    return FamilyMetadataEntity(
      relationships:
          relationships?.map((e) => e.toEntity()).toList() ?? const [],
      goals: goals?.map((e) => e.toEntity()).toList() ?? const [],
      activityLevels:
          activityLevels?.map((e) => e.toEntity()).toList() ?? const [],
      maxMembers: maxMembers ?? 4,
      discountPercent: discountPercent ?? 0.1,
      minMembersForDiscount: minMembersForDiscount ?? 2,
    );
  }
}

extension FamilyRelationshipDtoMapper on FamilyRelationshipDto {
  FamilyRelationshipEntity toEntity() {
    return FamilyRelationshipEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
    );
  }
}

extension FamilyNutritionalGoalDtoMapper on FamilyNutritionalGoalDto {
  FamilyNutritionalGoalEntity toEntity() {
    return FamilyNutritionalGoalEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
    );
  }
}

extension FamilyActivityLevelDtoMapper on FamilyActivityLevelDto {
  FamilyActivityLevelEntity toEntity() {
    return FamilyActivityLevelEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
    );
  }
}

extension FamilyGroupResponseDtoMapper on FamilyGroupResponseDto {
  FamilyGroupEntity toEntity() {
    return FamilyGroupEntity(
      familyGroupId: familyGroupId ?? '',
      name: name ?? '',
      status: FamilyGroupStatus.fromValue(status),
      maxMembers: maxMembers ?? 4,
      discountPercent: discountPercent ?? 0.1,
      currentStep: currentStep ?? 1,
      members: members?.map((e) => e.toEntity()).toList() ?? const [],
    );
  }
}

extension FamilyMemberResponseDtoMapper on FamilyMemberResponseDto {
  FamilyGroupMemberEntity toEntity() {
    return FamilyGroupMemberEntity(
      memberId: memberId ?? '',
      role: FamilyMemberRole.fromValue(role),
      displayName: displayName ?? '',
      relationshipCode: relationshipCode ?? '',
      gender: FamilyGender.fromValue(gender),
      ageYears: ageYears ?? 0,
      nutritionalGoalCode: nutritionalGoalCode ?? '',
      activityLevel: FamilyActivityLevel.fromValue(activityLevel),
      deliveryAddressId: deliveryAddressId ?? '',
      setupStatus: FamilyMemberSetupStatus.fromValue(setupStatus),
      programId: programId,
      bundleId: bundleId,
      selectedTier:
          selectedTier != null ? FamilyTier.fromValue(selectedTier) : null,
      durationDays: durationDays,
      includeFriday: includeFriday ?? false,
    );
  }
}

extension FamilySummaryResponseDtoMapper on FamilySummaryResponseDto {
  FamilySummaryEntity toEntity() {
    return FamilySummaryEntity(
      familyGroupId: familyGroupId ?? '',
      familyName: familyName ?? '',
      selectedMemberId: selectedMemberId ?? '',
      subtotal: subtotal ?? 0.0,
      familyDiscountPercent: familyDiscountPercent ?? 0.0,
      familyDiscountAmount: familyDiscountAmount ?? 0.0,
      finalPrice: finalPrice ?? 0.0,
      currencyCode: currencyCode ?? 'KWD',
      canCheckout: canCheckout ?? false,
      checkoutBlockReason: checkoutBlockReason,
      checkoutEndpoint: checkoutEndpoint ?? '',
      mealOverview: mealOverview?.map((e) => e.toEntity()).toList() ?? const [],
    );
  }
}

extension FamilyMealOverviewResponseDtoMapper on FamilyMealOverviewResponseDto {
  FamilyMealOverviewEntity toEntity() {
    return FamilyMealOverviewEntity(
      memberId: memberId ?? '',
      displayName: displayName ?? '',
      breakfast: breakfast ?? false,
      lunch: lunch ?? false,
      snack: snack ?? false,
      dinner: dinner ?? false,
      mealsPerDay: mealsPerDay ?? 0,
    );
  }
}

extension FamilyPaymentMethodResponseDtoMapper on FamilyPaymentMethodResponseDto {
  FamilyPaymentMethodEntity toEntity() {
    return FamilyPaymentMethodEntity(
      paymentMethodId: paymentMethodId ?? 0,
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      integrationType: integrationType,
      isAvailable: isAvailable ?? false,
      unavailableReason: unavailableReason,
    );
  }
}

extension FamilyCheckoutResponseDtoMapper on FamilyCheckoutResponseDto {
  FamilyCheckoutResponseEntity toEntity() {
    return FamilyCheckoutResponseEntity(
      familyGroupId: familyGroupId ?? '',
      paymentAnchorSubscriptionId: paymentAnchorSubscriptionId ?? '',
      paymentUrl: paymentUrl ?? '',
      holdExpiresAtUtc: holdExpiresAtUtc ?? '',
      finalPrice: finalPrice ?? 0.0,
    );
  }
}

extension FamilyGroupRequestEntityMapper on FamilyGroupRequestEntity {
  FamilyGroupRequestDto toDto() {
    return FamilyGroupRequestDto(name: name);
  }
}

extension FamilyMemberRequestEntityMapper on FamilyMemberRequestEntity {
  FamilyMemberRequestDto toDto() {
    return FamilyMemberRequestDto(
      displayName: displayName,
      relationshipCode: relationshipCode,
      gender: gender,
      ageYears: ageYears,
      nutritionalGoalCode: nutritionalGoalCode,
      activityLevel: activityLevel,
      deliveryAddressId: deliveryAddressId,
    );
  }
}

extension FamilyMemberPlanRequestEntityMapper
    on FamilyMemberPlanRequestEntity {
  FamilyMemberPlanRequestDto toDto() {
    return FamilyMemberPlanRequestDto(
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      durationDays: durationDays,
      includeFriday: includeFriday,
    );
  }
}

extension FamilyCheckoutRequestEntityMapper on FamilyCheckoutRequestEntity {
  FamilyCheckoutRequestDto toDto() {
    return FamilyCheckoutRequestDto(
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      correlationId: correlationId,
      paymentMethodId: paymentMethodId,
    );
  }
}
