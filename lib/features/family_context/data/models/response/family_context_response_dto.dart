import 'package:json_annotation/json_annotation.dart';

part 'family_context_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyContextResponseDto {
  const FamilyContextResponseDto({
    this.groupId,
    this.isManager,
    this.memberId,
    this.memberSubscriptionId,
    this.isDetachedFromFamilyManagement,
    this.setupStatus,
    this.hasSeparateAccount,
    this.isPaused,
    this.requiresPasswordSetup,
    this.accessStatus,
    this.capabilities,
  });

  final String? groupId;
  final bool? isManager;
  final String? memberId;
  final String? memberSubscriptionId;
  final bool? isDetachedFromFamilyManagement;
  final String? setupStatus;
  final bool? hasSeparateAccount;
  final bool? isPaused;
  final bool? requiresPasswordSetup;
  final String? accessStatus;
  final List<FamilyCapabilityResponseDto>? capabilities;

  factory FamilyContextResponseDto.fromJson(Map<String, dynamic> json) {
    return FamilyContextResponseDto(
      groupId: json['groupId']?.toString(),
      isManager: json['isManager'] as bool?,
      memberId: json['memberId']?.toString(),
      memberSubscriptionId: json['memberSubscriptionId']?.toString(),
      isDetachedFromFamilyManagement:
          json['isDetachedFromFamilyManagement'] as bool? ??
          json['isDetached'] as bool?,
      setupStatus: json['setupStatus']?.toString(),
      hasSeparateAccount: json['hasSeparateAccount'] as bool?,
      isPaused: json['isPaused'] as bool?,
      requiresPasswordSetup: json['requiresPasswordSetup'] as bool?,
      accessStatus: json['accessStatus']?.toString(),
      capabilities: (json['capabilities'] as List<dynamic>?)
          ?.map(
            (e) => FamilyCapabilityResponseDto.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
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

  factory FamilyCapabilityResponseDto.fromJson(Map<String, dynamic> json) {
    return FamilyCapabilityResponseDto(
      action: json['action']?.toString(),
      allowed: json['allowed'] as bool?,
      reasonCode: json['reasonCode']?.toString(),
      requiredPermission: json['requiredPermission']?.toString(),
    );
  }
}
