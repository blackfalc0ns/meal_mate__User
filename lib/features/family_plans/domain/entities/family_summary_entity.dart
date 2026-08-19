class FamilySummaryEntity {
  const FamilySummaryEntity({
    required this.familyGroupId,
    required this.familyName,
    required this.selectedMemberId,
    required this.subtotal,
    required this.familyDiscountPercent,
    required this.familyDiscountAmount,
    required this.finalPrice,
    required this.currencyCode,
    required this.canCheckout,
    this.checkoutBlockReason,
    required this.checkoutEndpoint,
    required this.mealOverview,
  });

  final String familyGroupId;
  final String familyName;
  final String selectedMemberId;
  final double subtotal;
  final double familyDiscountPercent;
  final double familyDiscountAmount;
  final double finalPrice;
  final String currencyCode;
  final bool canCheckout;
  final String? checkoutBlockReason;
  final String checkoutEndpoint;
  final List<FamilyMealOverviewEntity> mealOverview;
}

class FamilyMealOverviewEntity {
  const FamilyMealOverviewEntity({
    required this.memberId,
    required this.displayName,
    required this.breakfast,
    required this.lunch,
    required this.snack,
    required this.dinner,
    required this.mealsPerDay,
  });

  final String memberId;
  final String displayName;
  final bool breakfast;
  final bool lunch;
  final bool snack;
  final bool dinner;
  final int mealsPerDay;
}
