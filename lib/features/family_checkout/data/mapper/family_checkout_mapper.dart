import 'package:meal_meat_user/features/family_checkout/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';

extension FamilySummaryMemberDtoMapper on FamilySummaryMemberDto {
  FamilySummaryMemberEntity toEntity() {
    return FamilySummaryMemberEntity(
      memberId: memberId ?? '',
      displayName: displayName ?? '',
      isManager: isManager ?? false,
      setupStatus: setupStatus ?? 0,
      isReady: isReady ?? (setupStatus == 3),
      roleAr: roleAr,
    );
  }
}

extension FamilySelectedMemberSummaryDtoMapper
    on FamilySelectedMemberSummaryDto {
  FamilySelectedMemberSummaryEntity toEntity() {
    return FamilySelectedMemberSummaryEntity(
      memberId: memberId ?? '',
      displayName: displayName ?? '',
      isManager: isManager ?? false,
      roleAr: roleAr,
      setupStatus: setupStatus ?? 0,
      isReady: isReady ?? (setupStatus == 3),
      programNameAr: programNameAr,
      programNameEn: programNameEn,
      bundleNameAr: bundleNameAr,
      bundleNameEn: bundleNameEn,
      durationDays: durationDays,
      durationLabelAr: durationLabelAr,
      selectedTier: selectedTier,
      tierNameAr: tierNameAr,
      tierNameEn: tierNameEn,
      includeFriday: includeFriday ?? false,
      breakfast: breakfast ?? false,
      lunch: lunch ?? false,
      snack: snack ?? false,
      dinner: dinner ?? false,
      mealsPerDay: mealsPerDay ?? 0,
      memberPrice: memberPrice ?? 0.0,
    );
  }
}

extension FamilyMealOverviewDtoMapper on FamilyMealOverviewDto {
  FamilyMealOverviewEntity toEntity() {
    return FamilyMealOverviewEntity(
      memberId: memberId ?? '',
      displayName: displayName ?? '',
      breakfast: breakfast ?? false,
      lunch: lunch ?? false,
      snack: snack ?? false,
      dinner: dinner ?? false,
      mealsPerDay: mealsPerDay ?? 0,
      isReady: isReady ?? false,
      isManager: isManager ?? false,
    );
  }
}

extension FamilySummaryResponseDtoMapper on FamilySummaryResponseDto {
  FamilySummaryEntity toEntity() {
    return FamilySummaryEntity(
      familyGroupId: familyGroupId,
      familyName: familyName,
      subtotal: subtotal ?? 0.0,
      familyDiscountPercent: familyDiscountPercent ?? 0.0,
      familyDiscountAmount: familyDiscountAmount ?? 0.0,
      finalPrice: finalPrice ?? 0.0,
      currencyCode: currencyCode ?? 'KWD',
      canCheckout: canCheckout ?? false,
      checkoutBlockReason: checkoutBlockReason,
      managerPrepaid: managerPrepaid ?? false,
      managerSubscriptionId: managerSubscriptionId,
      newMembersCount: newMembersCount ?? 0,
      newMembersSubtotal: newMembersSubtotal ?? 0.0,
      members: members?.map((member) => member.toEntity()).toList() ?? const [],
      selectedMember: selectedMember?.toEntity(),
      mealOverview:
          mealOverview?.map((meal) => meal.toEntity()).toList() ?? const [],
      checkoutEndpoint: checkoutEndpoint,
    );
  }
}
