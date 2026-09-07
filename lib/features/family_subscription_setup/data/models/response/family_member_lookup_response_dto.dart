import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_lookup_entity.dart';

part 'family_member_lookup_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyMemberLookupResponseDto {
  const FamilyMemberLookupResponseDto({
    this.found,
    this.displayName,
    this.ageYears,
    this.gender,
  });

  final bool? found;
  final String? displayName;
  final int? ageYears;
  final int? gender;

  factory FamilyMemberLookupResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberLookupResponseDtoFromJson(json);

  FamilyMemberLookupEntity toEntity() => FamilyMemberLookupEntity(
    found: found ?? false,
    displayName: displayName,
    ageYears: ageYears,
    gender: gender,
  );
}
