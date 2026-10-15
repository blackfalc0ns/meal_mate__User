import 'package:meal_meat_user/features/family_context/data/models/response/family_context_response_dto.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';

extension FamilyCapabilityResponseDtoMapper on FamilyCapabilityResponseDto {
  FamilyCapabilityEntity toEntity() {
    return FamilyCapabilityEntity(
      action: action ?? '',
      allowed: allowed ?? false,
      reasonCode: reasonCode,
      requiredPermission: requiredPermission,
    );
  }
}

extension FamilyContextResponseDtoMapper on FamilyContextResponseDto {
  FamilyContextEntity toEntity() {
    return FamilyContextEntity(
      groupId: groupId ?? '',
      isManager: isManager ?? false,
      memberId: memberId,
      memberSubscriptionId: memberSubscriptionId,
      isDetachedFromFamilyManagement: isDetachedFromFamilyManagement ?? false,
      setupStatus: setupStatus ?? '',
      hasSeparateAccount: hasSeparateAccount ?? false,
      isPaused: isPaused ?? false,
      requiresPasswordSetup: requiresPasswordSetup ?? false,
      accessStatus: accessStatus ?? '',
      capabilities:
          capabilities?.map((c) => c.toEntity()).toList() ?? const [],
    );
  }
}
