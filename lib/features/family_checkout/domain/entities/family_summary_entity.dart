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
  final String? startDate;

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
    this.startDate,
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

class FamilyMemberRestaurantEntity {
  final String restaurantId;
  final String? logoUrl;
  final String? name;
  final String? nameAr;
  final int occurrenceCount;

  const FamilyMemberRestaurantEntity({
    required this.restaurantId,
    this.logoUrl,
    this.name,
    this.nameAr,
    this.occurrenceCount = 0,
  });

  String displayName(String languageCode) {
    if (languageCode.toLowerCase().startsWith('en') &&
        (name?.isNotEmpty ?? false)) {
      return name!;
    }
    return nameAr ?? name ?? '';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyMemberRestaurantEntity &&
          runtimeType == other.runtimeType &&
          restaurantId == other.restaurantId &&
          logoUrl == other.logoUrl &&
          name == other.name &&
          nameAr == other.nameAr &&
          occurrenceCount == other.occurrenceCount;

  @override
  int get hashCode =>
      restaurantId.hashCode ^
      logoUrl.hashCode ^
      name.hashCode ^
      nameAr.hashCode ^
      occurrenceCount.hashCode;
}

class FamilyMemberRestaurantRepetitionEntity {
  final int limit;
  final int restaurantCount;
  final int durationDays;

  const FamilyMemberRestaurantRepetitionEntity({
    this.limit = 0,
    this.restaurantCount = 0,
    this.durationDays = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyMemberRestaurantRepetitionEntity &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          restaurantCount == other.restaurantCount &&
          durationDays == other.durationDays;

  @override
  int get hashCode =>
      limit.hashCode ^ restaurantCount.hashCode ^ durationDays.hashCode;
}

class FamilyMemberScheduleEntity {
  final String memberId;
  final String? paymentDate;
  final String? firstDeliveryDate;
  final String? endDate;
  final int deliveryDaysCount;
  final int mealsPerDay;
  final int totalMeals;
  final List<FamilyMemberRestaurantEntity> restaurants;
  final FamilyMemberRestaurantRepetitionEntity? restaurantRepetition;

  const FamilyMemberScheduleEntity({
    required this.memberId,
    this.paymentDate,
    this.firstDeliveryDate,
    this.endDate,
    this.deliveryDaysCount = 0,
    this.mealsPerDay = 0,
    this.totalMeals = 0,
    this.restaurants = const [],
    this.restaurantRepetition,
  });
}

class FamilySummaryAvailabilityEntity {
  final String? status;
  final int coveredRestaurantCount;
  final int eligibleRestaurantCount;
  final String? checkedAtUtc;
  final String? effectiveStartDate;
  final String? messageCode;
  final Map<String, dynamic> failureReasons;

  const FamilySummaryAvailabilityEntity({
    this.status,
    this.coveredRestaurantCount = 0,
    this.eligibleRestaurantCount = 0,
    this.checkedAtUtc,
    this.effectiveStartDate,
    this.messageCode,
    this.failureReasons = const {},
  });
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
  final List<FamilyMemberScheduleEntity> memberSchedules;
  final int participantCount;
  final String? checkoutEndpoint;
  final String? batchId;
  final int? batchVersion;
  final int rosterCount;
  final int selectedNewSubscriberCount;
  final int eligibleExistingSubscriberCount;
  final int unsubscribedCount;
  final bool lockedQuote;
  final String? selectedFamilyPackageId;
  final String? effectiveFamilyPackageId;
  final int? effectiveFamilyPackageMinMembers;
  final int? effectiveFamilyPackageMaxMembers;
  final String? packageSelectionMode;
  final int? occupiedSeatCount;
  final int? availableSeatCount;
  final int? maxSeats;
  final int? deferredMemberCount;
  final int? currentPurchaseCount;
  final bool managerSeatExempt;
  final bool managerIndividualIsLive;
  final bool isInitialPurchaseOrReactivation;
  final FamilySummaryAvailabilityEntity? availability;
  final FamilyMemberRestaurantRepetitionEntity? restaurantRepetition;

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
    this.memberSchedules = const [],
    this.participantCount = 0,
    this.checkoutEndpoint,
    this.batchId,
    this.batchVersion,
    this.rosterCount = 0,
    this.selectedNewSubscriberCount = 0,
    this.eligibleExistingSubscriberCount = 0,
    this.unsubscribedCount = 0,
    this.lockedQuote = false,
    this.selectedFamilyPackageId,
    this.effectiveFamilyPackageId,
    this.effectiveFamilyPackageMinMembers,
    this.effectiveFamilyPackageMaxMembers,
    this.packageSelectionMode,
    this.occupiedSeatCount,
    this.availableSeatCount,
    this.maxSeats,
    this.deferredMemberCount,
    this.currentPurchaseCount,
    this.managerSeatExempt = false,
    this.managerIndividualIsLive = false,
    this.isInitialPurchaseOrReactivation = true,
    this.availability,
    this.restaurantRepetition,
  });

  /// The scope of new subscriptions on this checkout invoice.
  int get invoiceSubscribersCount => participantCount > 0
      ? participantCount
      : (selectedNewSubscriberCount > 0
            ? selectedNewSubscriberCount
            : newMembersCount);

  String get discountLabel {
    final percent = familyDiscountPercent * 100;
    final formatted = percent % 1 == 0
        ? percent.toInt().toString()
        : percent.toStringAsFixed(1);
    return '$formatted%';
  }
}
