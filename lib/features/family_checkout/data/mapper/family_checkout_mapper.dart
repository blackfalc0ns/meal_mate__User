import 'package:meal_meat_user/features/family_checkout/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';

extension FamilySummaryMemberDtoMapper on FamilySummaryMemberDto {
  FamilySummaryMemberEntity toEntity() {
    return FamilySummaryMemberEntity(
      memberId: memberId ?? '',
      displayName: displayName ?? '',
      isManager: isManager ?? false,
      setupStatus: setupStatus ?? 0,
      isReady: isReady ?? (setupStatus == 2),
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
      isReady: isReady ?? (setupStatus == 2),
      programNameAr: programNameAr,
      programNameEn: programNameEn,
      bundleNameAr: bundleNameAr,
      bundleNameEn: bundleNameEn,
      durationDays: durationDays,
      durationLabelAr: durationLabelAr,
      durationLabelEn: durationLabelEn,
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
      startDate: startDate,
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

extension FamilyMemberScheduleDtoMapper on FamilyMemberScheduleDto {
  FamilyMemberScheduleEntity toEntity() {
    return FamilyMemberScheduleEntity(
      memberId: memberId ?? '',
      paymentDate: paymentDate,
      firstDeliveryDate: firstDeliveryDate,
      endDate: endDate,
      deliveryDaysCount: deliveryDaysCount ?? 0,
      mealsPerDay: mealsPerDay ?? 0,
      totalMeals: totalMeals ?? 0,
      restaurants:
          restaurants?.map((item) => item.toString()).toList() ?? const [],
    );
  }
}

extension FamilySummaryResponseDtoMapper on FamilySummaryResponseDto {
  FamilySummaryEntity toEntity() {
    return FamilySummaryEntity(
      familyGroupId: familyGroupId,
      familyName: familyName,
      selectedMemberId: selectedMemberId,
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
      memberSchedules:
          memberSchedules?.map((schedule) => schedule.toEntity()).toList() ??
          const [],
      participantCount:
          participantCount ??
          selectedNewSubscriberCount ??
          newMembersCount ??
          0,
      checkoutEndpoint: checkoutEndpoint,
      batchId: batchId,
      batchVersion: batchVersion,
      rosterCount: rosterCount ?? (members?.length ?? 0),
      selectedNewSubscriberCount:
          selectedNewSubscriberCount ?? (newMembersCount ?? 0),
      eligibleExistingSubscriberCount: eligibleExistingSubscriberCount ?? 0,
      unsubscribedCount: unsubscribedCount ?? 0,
      lockedQuote: lockedQuote ?? false,
    );
  }
}
