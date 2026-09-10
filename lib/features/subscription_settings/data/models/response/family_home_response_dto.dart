import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_summary_response_dto.dart';

part 'family_home_response_dto.g.dart';

@JsonSerializable()
class FamilyHomeResponseDto {
  const FamilyHomeResponseDto({
    this.groupId,
    this.name,
    this.status,
    this.packageLabelAr,
    this.packageLabelEn,
    this.quotedFinalPrice,
    this.currencyCode,
    this.wallet,
    this.shortcuts,
    this.members,
    this.todaySchedule,
  });
  final String? groupId;
  final String? name;
  final Object? status;
  final String? packageLabelAr;
  final String? packageLabelEn;
  final double? quotedFinalPrice;
  final String? currencyCode;
  final FamilyWalletResponseDto? wallet;
  final List<FamilyShortcutResponseDto>? shortcuts;
  final List<FamilyMemberSummaryResponseDto>? members;
  final List<FamilyMemberSummaryResponseDto>? todaySchedule;

  factory FamilyHomeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyHomeResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyHomeResponseDtoToJson(this);
}

@JsonSerializable()
class FamilyWalletResponseDto {
  const FamilyWalletResponseDto({this.available, this.unavailableReason});
  final bool? available;
  final String? unavailableReason;
  factory FamilyWalletResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyWalletResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyWalletResponseDtoToJson(this);
}

@JsonSerializable()
class FamilyShortcutResponseDto {
  const FamilyShortcutResponseDto({
    this.code,
    this.enabled,
    this.unavailableReason,
  });
  final String? code;
  final bool? enabled;
  final String? unavailableReason;
  factory FamilyShortcutResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyShortcutResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyShortcutResponseDtoToJson(this);
}
