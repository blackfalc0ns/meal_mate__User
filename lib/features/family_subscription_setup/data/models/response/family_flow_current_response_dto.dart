import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_member_response_dto.dart';

part 'family_flow_current_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyFlowCurrentResponseDto {
  const FamilyFlowCurrentResponseDto({
    this.familyGroupId,
    this.name,
    this.status,
    this.selectedFamilyPackageId,
    this.packageNameAr,
    this.packageNameEn,
    this.packageName,
    this.minMembers,
    this.maxMembers,
    this.discountPercent,
    this.currentStep,
    this.managerPrepaid,
    this.members,
    this.sessionExpired,
    this.sessionExpiresAtUtc,
    this.sessionMessage,
    this.packageAvailable,
  });

  final String? familyGroupId;
  final String? name;
  @JsonKey(fromJson: _statusFromJson)
  final int? status;
  final String? selectedFamilyPackageId;
  final String? packageNameAr;
  final String? packageNameEn;
  final String? packageName;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? minMembers;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? maxMembers;
  final double? discountPercent;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? currentStep;
  final bool? managerPrepaid;
  final List<FamilyMemberResponseDto>? members;
  final bool? sessionExpired;
  final String? sessionExpiresAtUtc;
  final String? sessionMessage;
  final bool? packageAvailable;

  factory FamilyFlowCurrentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyFlowCurrentResponseDtoFromJson(json);
}

int? _statusFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) {
    final lower = value.toLowerCase();
    if (lower == 'draft') return 1;
    if (lower == 'checkoutpending' || lower == 'checkout_pending') return 2;
    if (lower == 'active') return 3;
    return int.tryParse(value) ?? 1;
  }
  return null;
}

int? _nullableIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
