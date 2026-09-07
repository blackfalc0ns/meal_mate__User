import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_member_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_relationship_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';

extension FamilyRelationshipResponseDtoMapper on FamilyRelationshipResponseDto {
  FamilyRelationshipEntity toEntity() {
    return FamilyRelationshipEntity(
      code: code ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      forDependents: forDependents ?? false,
      isPrimary: isPrimary ?? false,
    );
  }
}

extension FamilyMemberResponseDtoMapper on FamilyMemberResponseDto {
  FamilyMemberEntity toEntity() {
    return FamilyMemberEntity(
      memberId: memberId ?? '',
      memberSubscriptionId: memberSubscriptionId,
      phoneNumber: phoneNumber,
      occupation: occupation,
      startDate: startDate,
      role: role ?? 2,
      displayName: displayName ?? '',
      relationshipCode: relationshipCode ?? '',
      gender: gender ?? 1,
      ageYears: ageYears ?? 0,
      deliveryAddressId: deliveryAddressId,
      setupStatus: setupStatus ?? 1,
      programId: programId,
      bundleId: bundleId,
      selectedTier: selectedTier,
      durationDays: durationDays,
      includeFriday: includeFriday ?? false,
      isCurrentUser: isCurrentUser ?? false,
    );
  }
}

extension FamilyFlowCurrentResponseDtoMapper on FamilyFlowCurrentResponseDto {
  FamilyFlowCurrentEntity toEntity() {
    return FamilyFlowCurrentEntity(
      familyGroupId: familyGroupId,
      name: name,
      status: status,
      selectedFamilyPackageId: selectedFamilyPackageId,
      packageNameAr: packageNameAr,
      packageNameEn: packageNameEn,
      minMembers: minMembers,
      maxMembers: maxMembers,
      discountPercent: discountPercent,
      currentStep: currentStep,
      managerPrepaid: managerPrepaid ?? false,
      members: members?.map((member) => member.toEntity()).toList() ?? const [],
    );
  }
}
