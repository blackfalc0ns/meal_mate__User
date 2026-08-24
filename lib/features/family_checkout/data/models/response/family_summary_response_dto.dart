import 'package:json_annotation/json_annotation.dart';

part 'family_summary_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilySummaryMemberDto {
  const FamilySummaryMemberDto({
    this.memberId,
    this.displayName,
    this.isManager,
    this.setupStatus,
    this.isReady,
    this.roleAr,
  });

  @JsonKey(readValue: _readMemberId)
  final String? memberId;
  final String? displayName;
  final bool? isManager;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? setupStatus;
  final bool? isReady;
  final String? roleAr;

  factory FamilySummaryMemberDto.fromJson(Map<String, dynamic> json) =>
      _$FamilySummaryMemberDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilySelectedMemberSummaryDto {
  const FamilySelectedMemberSummaryDto({
    this.memberId,
    this.displayName,
    this.isManager,
    this.roleAr,
    this.setupStatus,
    this.isReady,
    this.programNameAr,
    this.programNameEn,
    this.bundleNameAr,
    this.bundleNameEn,
    this.durationDays,
    this.durationLabelAr,
    this.selectedTier,
    this.tierNameAr,
    this.includeFriday,
    this.breakfast,
    this.lunch,
    this.snack,
    this.dinner,
    this.mealsPerDay,
    this.memberPrice,
  });

  @JsonKey(readValue: _readMemberId)
  final String? memberId;
  final String? displayName;
  final bool? isManager;
  final String? roleAr;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? setupStatus;
  final bool? isReady;
  final String? programNameAr;
  final String? programNameEn;
  final String? bundleNameAr;
  final String? bundleNameEn;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? durationDays;
  final String? durationLabelAr;
  @JsonKey(readValue: _readSelectedTier, fromJson: _nullableIntFromJson)
  final int? selectedTier;
  final String? tierNameAr;
  final bool? includeFriday;
  final bool? breakfast;
  final bool? lunch;
  final bool? snack;
  final bool? dinner;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? mealsPerDay;
  @JsonKey(readValue: _readMemberPrice)
  final double? memberPrice;

  factory FamilySelectedMemberSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$FamilySelectedMemberSummaryDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyMealOverviewDto {
  const FamilyMealOverviewDto({
    this.memberId,
    this.displayName,
    this.breakfast,
    this.lunch,
    this.snack,
    this.dinner,
    this.mealsPerDay,
    this.isReady,
    this.isManager,
  });

  @JsonKey(readValue: _readMemberId)
  final String? memberId;
  final String? displayName;
  final bool? breakfast;
  final bool? lunch;
  final bool? snack;
  final bool? dinner;
  @JsonKey(fromJson: _mealCountFromJson)
  final int? mealsPerDay;
  final bool? isReady;
  final bool? isManager;

  factory FamilyMealOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMealOverviewDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilySummaryResponseDto {
  const FamilySummaryResponseDto({
    this.subtotal,
    this.familyDiscountPercent,
    this.familyDiscountAmount,
    this.finalPrice,
    this.currencyCode,
    this.canCheckout,
    this.checkoutBlockReason,
    this.members,
    this.selectedMember,
    this.mealOverview,
  });

  final double? subtotal;
  final double? familyDiscountPercent;
  final double? familyDiscountAmount;
  final double? finalPrice;
  final String? currencyCode;
  final bool? canCheckout;
  final String? checkoutBlockReason;
  final List<FamilySummaryMemberDto>? members;
  final FamilySelectedMemberSummaryDto? selectedMember;
  final List<FamilyMealOverviewDto>? mealOverview;

  factory FamilySummaryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilySummaryResponseDtoFromJson(json);
}

Object? _readMemberId(Map<dynamic, dynamic> json, String key) {
  return json[key] ?? json['id'];
}

Object? _readSelectedTier(Map<dynamic, dynamic> json, String key) {
  return json[key] ?? json['tier'];
}

Object? _readMemberPrice(Map<dynamic, dynamic> json, String key) {
  return json[key] ?? json['price'];
}

int? _nullableIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

int? _mealCountFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) {
    final matches = RegExp(r'\d+').allMatches(value);
    if (matches.isNotEmpty) {
      return int.tryParse(matches.first.group(0)!);
    }
  }
  return null;
}
