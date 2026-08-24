import 'package:meal_meat_user/features/family_checkout/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';

extension FamilySummaryMemberDtoMapper on FamilySummaryMemberDto {
  FamilySummaryMemberEntity toEntity() {
    return FamilySummaryMemberEntity(
      memberId: memberId,
      displayName: displayName,
      isManager: isManager,
      setupStatus: setupStatus,
      isReady: isReady,
      roleAr: roleAr,
    );
  }
}

extension FamilySelectedMemberSummaryDtoMapper
    on FamilySelectedMemberSummaryDto {
  FamilySelectedMemberSummaryEntity toEntity() {
    return FamilySelectedMemberSummaryEntity(
      memberId: memberId,
      displayName: displayName,
      isManager: isManager,
      roleAr: roleAr,
      setupStatus: setupStatus,
      isReady: isReady,
      programNameAr: programNameAr,
      programNameEn: programNameEn,
      bundleNameAr: bundleNameAr,
      bundleNameEn: bundleNameEn,
      durationDays: durationDays,
      durationLabelAr: durationLabelAr,
      selectedTier: selectedTier,
      tierNameAr: tierNameAr,
      includeFriday: includeFriday,
      breakfast: breakfast,
      lunch: lunch,
      snack: snack,
      dinner: dinner,
      mealsPerDay: mealsPerDay,
      memberPrice: memberPrice,
    );
  }
}

extension FamilyMealOverviewDtoMapper on FamilyMealOverviewDto {
  FamilyMealOverviewEntity toEntity() {
    return FamilyMealOverviewEntity(
      memberId: memberId,
      displayName: displayName,
      breakfast: breakfast,
      lunch: lunch,
      snack: snack,
      dinner: dinner,
      mealsPerDay: mealsPerDay,
      isReady: isReady,
      isManager: isManager,
    );
  }
}

extension FamilySummaryResponseDtoMapper on FamilySummaryResponseDto {
  FamilySummaryEntity toEntity() {
    return FamilySummaryEntity(
      subtotal: subtotal,
      familyDiscountPercent: familyDiscountPercent,
      familyDiscountAmount: familyDiscountAmount,
      finalPrice: finalPrice,
      currencyCode: currencyCode,
      canCheckout: canCheckout,
      checkoutBlockReason: checkoutBlockReason,
      members: members.map((member) => member.toEntity()).toList(),
      selectedMember: selectedMember?.toEntity(),
      mealOverview: mealOverview.map((meal) => meal.toEntity()).toList(),
    );
  }
}
