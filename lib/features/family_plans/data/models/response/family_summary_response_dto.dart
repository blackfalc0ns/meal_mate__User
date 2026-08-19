import 'package:json_annotation/json_annotation.dart';

part 'family_summary_response_dto.g.dart';

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

@JsonSerializable(createToJson: false)
class FamilySummaryResponseDto {
  const FamilySummaryResponseDto({
    this.familyGroupId,
    this.familyName,
    this.selectedMemberId,
    this.subtotal,
    this.familyDiscountPercent,
    this.familyDiscountAmount,
    this.finalPrice,
    this.currencyCode,
    this.canCheckout,
    this.checkoutBlockReason,
    this.checkoutEndpoint,
    this.mealOverview,
  });

  final String? familyGroupId;
  final String? familyName;
  final String? selectedMemberId;
  @JsonKey(fromJson: _parseDouble)
  final double? subtotal;
  @JsonKey(fromJson: _parseDouble)
  final double? familyDiscountPercent;
  @JsonKey(fromJson: _parseDouble)
  final double? familyDiscountAmount;
  @JsonKey(fromJson: _parseDouble)
  final double? finalPrice;
  final String? currencyCode;
  final bool? canCheckout;
  final String? checkoutBlockReason;
  final String? checkoutEndpoint;
  final List<FamilyMealOverviewResponseDto>? mealOverview;

  factory FamilySummaryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilySummaryResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyMealOverviewResponseDto {
  const FamilyMealOverviewResponseDto({
    this.memberId,
    this.displayName,
    this.breakfast,
    this.lunch,
    this.snack,
    this.dinner,
    this.mealsPerDay,
  });

  final String? memberId;
  final String? displayName;
  final bool? breakfast;
  final bool? lunch;
  final bool? snack;
  final bool? dinner;
  @JsonKey(fromJson: _parseInt)
  final int? mealsPerDay;

  factory FamilyMealOverviewResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMealOverviewResponseDtoFromJson(json);
}
