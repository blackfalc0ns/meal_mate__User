class FamilySummaryMemberDto {
  final String memberId;
  final String displayName;
  final bool isManager;
  final int setupStatus;
  final bool isReady;
  final String? roleAr;

  FamilySummaryMemberDto({
    required this.memberId,
    required this.displayName,
    this.isManager = false,
    this.setupStatus = 0,
    this.isReady = false,
    this.roleAr,
  });

  factory FamilySummaryMemberDto.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    final setupStatus = parseInt(json['setupStatus']);
    final isReady = json['isReady'] as bool? ?? (setupStatus == 3);

    return FamilySummaryMemberDto(
      memberId: (json['memberId'] ?? json['id'] ?? '') as String,
      displayName: json['displayName'] as String? ?? '',
      isManager: json['isManager'] as bool? ?? false,
      setupStatus: setupStatus,
      isReady: isReady,
      roleAr: json['roleAr'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'displayName': displayName,
        'isManager': isManager,
        'setupStatus': setupStatus,
        'isReady': isReady,
        'roleAr': roleAr,
      };
}

class FamilySelectedMemberSummaryDto {
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
  final int? selectedTier;
  final String? tierNameAr;
  final bool includeFriday;
  final bool breakfast;
  final bool lunch;
  final bool snack;
  final bool dinner;
  final int mealsPerDay;
  final double memberPrice;

  FamilySelectedMemberSummaryDto({
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
    this.selectedTier,
    this.tierNameAr,
    this.includeFriday = false,
    this.breakfast = false,
    this.lunch = false,
    this.snack = false,
    this.dinner = false,
    this.mealsPerDay = 0,
    this.memberPrice = 0.0,
  });

  factory FamilySelectedMemberSummaryDto.fromJson(Map<String, dynamic> json) {
    int? parseNullableInt(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val);
      return null;
    }

    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    final setupStatus = parseInt(json['setupStatus']);
    final isReady = json['isReady'] as bool? ?? (setupStatus == 3);

    return FamilySelectedMemberSummaryDto(
      memberId: (json['memberId'] ?? json['id'] ?? '') as String,
      displayName: json['displayName'] as String? ?? '',
      isManager: json['isManager'] as bool? ?? false,
      roleAr: json['roleAr'] as String?,
      setupStatus: setupStatus,
      isReady: isReady,
      programNameAr: json['programNameAr'] as String?,
      programNameEn: json['programNameEn'] as String?,
      bundleNameAr: json['bundleNameAr'] as String?,
      bundleNameEn: json['bundleNameEn'] as String?,
      durationDays: parseNullableInt(json['durationDays']),
      durationLabelAr: json['durationLabelAr'] as String?,
      selectedTier: parseNullableInt(json['selectedTier'] ?? json['tier']),
      tierNameAr: json['tierNameAr'] as String?,
      includeFriday: json['includeFriday'] as bool? ?? false,
      breakfast: json['breakfast'] as bool? ?? false,
      lunch: json['lunch'] as bool? ?? false,
      snack: json['snack'] as bool? ?? false,
      dinner: json['dinner'] as bool? ?? false,
      mealsPerDay: parseInt(json['mealsPerDay']),
      memberPrice: (json['memberPrice'] ?? json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'displayName': displayName,
        'isManager': isManager,
        'roleAr': roleAr,
        'setupStatus': setupStatus,
        'isReady': isReady,
        'programNameAr': programNameAr,
        'programNameEn': programNameEn,
        'bundleNameAr': bundleNameAr,
        'bundleNameEn': bundleNameEn,
        'durationDays': durationDays,
        'durationLabelAr': durationLabelAr,
        'selectedTier': selectedTier,
        'tierNameAr': tierNameAr,
        'includeFriday': includeFriday,
        'breakfast': breakfast,
        'lunch': lunch,
        'snack': snack,
        'dinner': dinner,
        'mealsPerDay': mealsPerDay,
        'memberPrice': memberPrice,
      };
}

class FamilyMealOverviewDto {
  final String memberId;
  final String displayName;
  final bool breakfast;
  final bool lunch;
  final bool snack;
  final bool dinner;
  final int mealsPerDay;
  final bool isReady;
  final bool isManager;

  FamilyMealOverviewDto({
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

  factory FamilyMealOverviewDto.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      if (val is String) {
        final matches = RegExp(r'\d+').allMatches(val);
        if (matches.isNotEmpty) {
          return int.tryParse(matches.first.group(0)!) ?? 0;
        }
      }
      return 0;
    }

    return FamilyMealOverviewDto(
      memberId: (json['memberId'] ?? json['id'] ?? '') as String,
      displayName: json['displayName'] as String? ?? '',
      breakfast: json['breakfast'] as bool? ?? false,
      lunch: json['lunch'] as bool? ?? false,
      snack: json['snack'] as bool? ?? false,
      dinner: json['dinner'] as bool? ?? false,
      mealsPerDay: parseInt(json['mealsPerDay']),
      isReady: json['isReady'] as bool? ?? false,
      isManager: json['isManager'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'displayName': displayName,
        'breakfast': breakfast,
        'lunch': lunch,
        'snack': snack,
        'dinner': dinner,
        'mealsPerDay': mealsPerDay,
        'isReady': isReady,
        'isManager': isManager,
      };
}

class FamilySummaryResponseDto {
  final double subtotal;
  final double familyDiscountPercent;
  final double familyDiscountAmount;
  final double finalPrice;
  final String currencyCode;
  final bool canCheckout;
  final String? checkoutBlockReason;
  final List<FamilySummaryMemberDto> members;
  final FamilySelectedMemberSummaryDto? selectedMember;
  final List<FamilyMealOverviewDto> mealOverview;

  FamilySummaryResponseDto({
    required this.subtotal,
    required this.familyDiscountPercent,
    required this.familyDiscountAmount,
    required this.finalPrice,
    this.currencyCode = 'KWD',
    required this.canCheckout,
    this.checkoutBlockReason,
    this.members = const [],
    this.selectedMember,
    this.mealOverview = const [],
  });

  factory FamilySummaryResponseDto.fromJson(Map<String, dynamic> json) {
    return FamilySummaryResponseDto(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      familyDiscountPercent:
          (json['familyDiscountPercent'] as num?)?.toDouble() ?? 0.0,
      familyDiscountAmount:
          (json['familyDiscountAmount'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      currencyCode: json['currencyCode'] as String? ?? 'KWD',
      canCheckout: json['canCheckout'] as bool? ?? false,
      checkoutBlockReason: json['checkoutBlockReason'] as String?,
      members: (json['members'] as List<dynamic>?)
              ?.map(
                (e) => FamilySummaryMemberDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      selectedMember: json['selectedMember'] != null
          ? FamilySelectedMemberSummaryDto.fromJson(
              json['selectedMember'] as Map<String, dynamic>,
            )
          : null,
      mealOverview: (json['mealOverview'] as List<dynamic>?)
              ?.map(
                (e) => FamilyMealOverviewDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'subtotal': subtotal,
        'familyDiscountPercent': familyDiscountPercent,
        'familyDiscountAmount': familyDiscountAmount,
        'finalPrice': finalPrice,
        'currencyCode': currencyCode,
        'canCheckout': canCheckout,
        'checkoutBlockReason': checkoutBlockReason,
        'members': members.map((e) => e.toJson()).toList(),
        'selectedMember': selectedMember?.toJson(),
        'mealOverview': mealOverview.map((e) => e.toJson()).toList(),
      };
}
