class FamilySummaryMemberEntity {
  final String memberId;
  final String displayName;
  final bool isManager;
  final int setupStatus;
  final bool isReady;
  final String? roleAr;

  const FamilySummaryMemberEntity({
    required this.memberId,
    required this.displayName,
    this.isManager = false,
    this.setupStatus = 0,
    this.isReady = false,
    this.roleAr,
  });
}

class FamilySelectedMemberSummaryEntity {
  final String memberId;
  final String displayName;
  final bool isManager;
  final String? roleAr;
  final int setupStatus;
  final bool isReady;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final int? durationDays;
  final String? durationLabelAr;
  final String? durationLabelEn;
  final int? selectedTier;
  final String? tierNameAr;
  final String? tierNameEn;
  final bool includeFriday;
  final bool breakfast;
  final bool lunch;
  final bool snack;
  final bool dinner;
  final int mealsPerDay;
  final double memberPrice;

  const FamilySelectedMemberSummaryEntity({
    required this.memberId,
    required this.displayName,
    this.isManager = false,
    this.roleAr,
    this.setupStatus = 0,
    this.isReady = false,
    this.programNameAr,
    this.programNameEn,
    this.bundleNameAr,
    this.bundleNameEn,
    this.durationDays,
    this.durationLabelAr,
    this.durationLabelEn,
    this.selectedTier,
    this.tierNameAr,
    this.tierNameEn,
    this.includeFriday = false,
    this.breakfast = false,
    this.lunch = false,
    this.snack = false,
    this.dinner = false,
    this.mealsPerDay = 0,
    this.memberPrice = 0.0,
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

  String durationText(String languageCode) {
    if (languageCode.toLowerCase().startsWith('en') &&
        (durationLabelEn?.isNotEmpty ?? false)) {
      return durationLabelEn!;
    }
    if (durationLabelAr != null && durationLabelAr!.isNotEmpty) {
      return durationLabelAr!;
    }
    if (durationDays != null && durationDays! > 0) {
      return languageCode.toLowerCase().startsWith('en')
          ? '$durationDays Days'
          : '$durationDays يوم';
    }
    return '';
  }

  String tierText(String languageCode) {
    if (languageCode.toLowerCase().startsWith('en') &&
        (tierNameEn?.isNotEmpty ?? false)) {
      return tierNameEn!;
    }
    if (tierNameAr != null && tierNameAr!.isNotEmpty) {
      return tierNameAr!;
    }
    if (selectedTier != null) {
      switch (selectedTier) {
        case 1:
          return languageCode.toLowerCase().startsWith('en')
              ? 'Basic'
              : 'أساسي';
        case 2:
          return languageCode.toLowerCase().startsWith('en')
              ? 'Platinum'
              : 'بلاتينيوم';
        case 3:
          return languageCode.toLowerCase().startsWith('en')
              ? 'Elite'
              : 'إيليت';
        default:
          return 'Tier $selectedTier';
      }
    }
    return '';
  }
}

class FamilyMealOverviewEntity {
  final String memberId;
  final String displayName;
  final bool breakfast;
  final bool lunch;
  final bool snack;
  final bool dinner;
  final int mealsPerDay;
  final bool isReady;
  final bool isManager;

  const FamilyMealOverviewEntity({
    required this.memberId,
    required this.displayName,
    this.breakfast = false,
    this.lunch = false,
    this.snack = false,
    this.dinner = false,
    this.mealsPerDay = 0,
    this.isReady = false,
    this.isManager = false,
  });

  List<bool> get mealChecks => [breakfast, lunch, snack, dinner];
}

class FamilySummaryEntity {
  final String? familyGroupId;
  final String? familyName;
  final String? selectedMemberId;
  final double subtotal;
  final double familyDiscountPercent;
  final double familyDiscountAmount;
  final double finalPrice;
  final String currencyCode;
  final bool canCheckout;
  final String? checkoutBlockReason;
  final bool managerPrepaid;
  final String? managerSubscriptionId;
  final int newMembersCount;
  final double newMembersSubtotal;
  final List<FamilySummaryMemberEntity> members;
  final FamilySelectedMemberSummaryEntity? selectedMember;
  final List<FamilyMealOverviewEntity> mealOverview;
  final String? checkoutEndpoint;

  const FamilySummaryEntity({
    this.familyGroupId,
    this.familyName,
    this.selectedMemberId,
    required this.subtotal,
    required this.familyDiscountPercent,
    required this.familyDiscountAmount,
    required this.finalPrice,
    this.currencyCode = 'KWD',
    required this.canCheckout,
    this.checkoutBlockReason,
    this.managerPrepaid = false,
    this.managerSubscriptionId,
    this.newMembersCount = 0,
    this.newMembersSubtotal = 0.0,
    this.members = const [],
    this.selectedMember,
    this.mealOverview = const [],
    this.checkoutEndpoint,
  });

  String get discountLabel {
    final percent = familyDiscountPercent * 100;
    final formatted = percent % 1 == 0
        ? percent.toInt().toString()
        : percent.toStringAsFixed(1);
    return '$formatted%';
  }
}
