class FamilyMemberPlanSummaryEntity {
  final String memberId;
  final String displayName;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final int? tier;
  final int? durationDays;
  final bool includeFriday;
  final double price;

  const FamilyMemberPlanSummaryEntity({
    required this.memberId,
    required this.displayName,
    this.programNameAr,
    this.programNameEn,
    this.bundleNameAr,
    this.bundleNameEn,
    this.tier,
    this.durationDays,
    required this.includeFriday,
    required this.price,
  });

  String programName(String languageCode) {
    if (languageCode.toLowerCase().startsWith('en') &&
        (programNameEn?.isNotEmpty ?? false)) {
      return programNameEn!;
    }
    return programNameAr ?? programNameEn ?? '';
  }

  String bundleName(String languageCode) {
    if (languageCode.toLowerCase().startsWith('en') &&
        (bundleNameEn?.isNotEmpty ?? false)) {
      return bundleNameEn!;
    }
    return bundleNameAr ?? bundleNameEn ?? '';
  }
}

class FamilySummaryEntity {
  final double subtotal;
  final double familyDiscountPercent;
  final double familyDiscountAmount;
  final double finalPrice;
  final bool canCheckout;
  final String? checkoutBlockReason;
  final List<FamilyMemberPlanSummaryEntity> members;

  const FamilySummaryEntity({
    required this.subtotal,
    required this.familyDiscountPercent,
    required this.familyDiscountAmount,
    required this.finalPrice,
    required this.canCheckout,
    this.checkoutBlockReason,
    this.members = const [],
  });

  String get discountLabel {
    final percent = familyDiscountPercent * 100;
    final formatted =
        percent % 1 == 0 ? percent.toInt().toString() : percent.toStringAsFixed(1);
    return '$formatted%';
  }
}
