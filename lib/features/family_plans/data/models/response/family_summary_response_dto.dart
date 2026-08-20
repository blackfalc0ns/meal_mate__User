class FamilyMemberPlanSummaryDto {
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

  FamilyMemberPlanSummaryDto({
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

  factory FamilyMemberPlanSummaryDto.fromJson(Map<String, dynamic> json) {
    int? parseNullableInt(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val);
      return null;
    }

    return FamilyMemberPlanSummaryDto(
      memberId: json['memberId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      programNameAr: json['programNameAr'] as String?,
      programNameEn: json['programNameEn'] as String?,
      bundleNameAr: json['bundleNameAr'] as String?,
      bundleNameEn: json['bundleNameEn'] as String?,
      tier: parseNullableInt(json['tier']),
      durationDays: parseNullableInt(json['durationDays']),
      includeFriday: json['includeFriday'] as bool? ?? false,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'displayName': displayName,
        'programNameAr': programNameAr,
        'programNameEn': programNameEn,
        'bundleNameAr': bundleNameAr,
        'bundleNameEn': bundleNameEn,
        'tier': tier,
        'durationDays': durationDays,
        'includeFriday': includeFriday,
        'price': price,
      };
}

class FamilySummaryResponseDto {
  final double subtotal;
  final double familyDiscountPercent;
  final double familyDiscountAmount;
  final double finalPrice;
  final bool canCheckout;
  final String? checkoutBlockReason;
  final List<FamilyMemberPlanSummaryDto> members;

  FamilySummaryResponseDto({
    required this.subtotal,
    required this.familyDiscountPercent,
    required this.familyDiscountAmount,
    required this.finalPrice,
    required this.canCheckout,
    this.checkoutBlockReason,
    this.members = const [],
  });

  factory FamilySummaryResponseDto.fromJson(Map<String, dynamic> json) {
    return FamilySummaryResponseDto(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      familyDiscountPercent:
          (json['familyDiscountPercent'] as num?)?.toDouble() ?? 0.0,
      familyDiscountAmount:
          (json['familyDiscountAmount'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      canCheckout: json['canCheckout'] as bool? ?? false,
      checkoutBlockReason: json['checkoutBlockReason'] as String?,
      members: (json['members'] as List<dynamic>?)
              ?.map(
                (e) => FamilyMemberPlanSummaryDto.fromJson(
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
        'canCheckout': canCheckout,
        'checkoutBlockReason': checkoutBlockReason,
        'members': members.map((e) => e.toJson()).toList(),
      };
}
