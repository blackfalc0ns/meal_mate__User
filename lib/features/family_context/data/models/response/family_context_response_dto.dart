import 'package:json_annotation/json_annotation.dart';

part 'family_context_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyContextResponseDto {
  const FamilyContextResponseDto({
    this.groupId,
    this.isManager,
    this.memberId,
    this.memberSubscriptionId,
    this.capabilities,
  });

  final String? groupId;
  final bool? isManager;
  final String? memberId;
  final String? memberSubscriptionId;
  final List<FamilyCapabilityResponseDto>? capabilities;

  factory FamilyContextResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyContextResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyCapabilityResponseDto {
  const FamilyCapabilityResponseDto({
    this.action,
    this.allowed,
    this.reasonCode,
    this.requiredPermission,
  });

  final String? action;
  final bool? allowed;
  final String? reasonCode;
  final String? requiredPermission;

  factory FamilyCapabilityResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyCapabilityResponseDtoFromJson(json);
}
