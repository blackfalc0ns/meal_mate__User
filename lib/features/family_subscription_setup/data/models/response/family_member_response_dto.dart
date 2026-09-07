import 'package:json_annotation/json_annotation.dart';

part 'family_member_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyMemberResponseDto {
  const FamilyMemberResponseDto({
    this.memberId,
    this.memberSubscriptionId,
    this.phoneNumber,
    this.occupation,
    this.startDate,
    this.role,
    this.displayName,
    this.relationshipCode,
    this.gender,
    this.ageYears,
    this.deliveryAddressId,
    this.setupStatus,
    this.programId,
    this.bundleId,
    this.selectedTier,
    this.durationDays,
    this.includeFriday,
    this.isCurrentUser,
  });

  final String? memberId;
  final String? memberSubscriptionId;
  final String? phoneNumber;
  final String? occupation;
  final String? startDate;
  @JsonKey(fromJson: _roleFromJson)
  final int? role;
  final String? displayName;
  final String? relationshipCode;
  @JsonKey(fromJson: _genderFromJson)
  final int? gender;
  final int? ageYears;
  final String? deliveryAddressId;
  @JsonKey(fromJson: _setupStatusFromJson)
  final int? setupStatus;
  final String? programId;
  final String? bundleId;
  @JsonKey(fromJson: _tierFromJson)
  final int? selectedTier;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? durationDays;
  final bool? includeFriday;
  final bool? isCurrentUser;

  factory FamilyMemberResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberResponseDtoFromJson(json);
}

int? _roleFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) {
    if (value.toLowerCase() == 'manager') return 1;
    return int.tryParse(value) ?? 2;
  }
  return null;
}

int? _genderFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) {
    if (value.toLowerCase() == 'female' || value == '2') return 2;
    return int.tryParse(value) ?? 1;
  }
  return null;
}

int? _setupStatusFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) {
    final lower = value.toLowerCase();
    if (lower == 'completed' || value == '3') return 3;
    if (lower == 'inprogress' || value == '2') return 2;
    if (lower == 'notstarted' || value == '1') return 1;
    return int.tryParse(value) ?? 2;
  }
  return null;
}

int? _tierFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'basic' || lower == 'select' || lower == '1') return 1;
    if (lower == 'platinum' ||
        lower == 'plat' ||
        lower == 'plus' ||
        lower == '2') {
      return 2;
    }
    if (lower == 'elite' || lower == 'max' || lower == '3') return 3;
    return int.tryParse(value);
  }
  return null;
}

int? _nullableIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
