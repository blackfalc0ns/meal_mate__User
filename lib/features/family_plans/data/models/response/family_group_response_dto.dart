import 'package:json_annotation/json_annotation.dart';

part 'family_group_response_dto.g.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

@JsonSerializable(createToJson: false)
class FamilyGroupResponseDto {
  const FamilyGroupResponseDto({
    this.familyGroupId,
    this.name,
    this.status,
    this.maxMembers,
    this.discountPercent,
    this.currentStep,
    this.members,
  });

  final String? familyGroupId;
  final String? name;
  @JsonKey(fromJson: _parseInt)
  final int? status;
  @JsonKey(fromJson: _parseInt)
  final int? maxMembers;
  @JsonKey(fromJson: _parseDouble)
  final double? discountPercent;
  @JsonKey(fromJson: _parseInt)
  final int? currentStep;
  final List<FamilyMemberResponseDto>? members;

  factory FamilyGroupResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyGroupResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyMemberResponseDto {
  const FamilyMemberResponseDto({
    this.memberId,
    this.role,
    this.displayName,
    this.relationshipCode,
    this.gender,
    this.ageYears,
    this.nutritionalGoalCode,
    this.activityLevel,
    this.deliveryAddressId,
    this.setupStatus,
    this.programId,
    this.bundleId,
    this.selectedTier,
    this.durationDays,
    this.includeFriday,
  });

  final String? memberId;
  @JsonKey(fromJson: _parseInt)
  final int? role;
  final String? displayName;
  final String? relationshipCode;
  @JsonKey(fromJson: _parseInt)
  final int? gender;
  @JsonKey(fromJson: _parseInt)
  final int? ageYears;
  final String? nutritionalGoalCode;
  @JsonKey(fromJson: _parseInt)
  final int? activityLevel;
  final String? deliveryAddressId;
  @JsonKey(fromJson: _parseInt)
  final int? setupStatus;
  final String? programId;
  final String? bundleId;
  @JsonKey(fromJson: _parseInt)
  final int? selectedTier;
  @JsonKey(fromJson: _parseInt)
  final int? durationDays;
  final bool? includeFriday;

  factory FamilyMemberResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberResponseDtoFromJson(json);
}
