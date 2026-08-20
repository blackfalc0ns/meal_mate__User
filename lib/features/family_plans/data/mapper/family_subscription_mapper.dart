import 'package:meal_meat_user/features/family_plans/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_member_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_relationship_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_size_package_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_summary_entity.dart';

extension FamilySizePackageResponseDtoMapper on FamilySizePackageResponseDto {
  FamilySizePackageEntity toEntity() {
    return FamilySizePackageEntity(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      minMembers: minMembers,
      maxMembers: maxMembers,
      discountPercent: discountPercent,
      sortOrder: sortOrder,
      imageStorageKey: imageStorageKey,
      imageUrl: imageUrl,
    );
  }
}

extension FamilyRelationshipResponseDtoMapper on FamilyRelationshipResponseDto {
  FamilyRelationshipEntity toEntity() {
    return FamilyRelationshipEntity(
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      forDependents: forDependents,
      isPrimary: isPrimary,
    );
  }
}

extension FamilyMemberResponseDtoMapper on FamilyMemberResponseDto {
  FamilyMemberEntity toEntity() {
    return FamilyMemberEntity(
      memberId: memberId,
      role: role,
      displayName: displayName,
      relationshipCode: relationshipCode,
      gender: gender,
      ageYears: ageYears,
      deliveryAddressId: deliveryAddressId,
      setupStatus: setupStatus,
      programId: programId,
      bundleId: bundleId,
      selectedTier: selectedTier,
      durationDays: durationDays,
      includeFriday: includeFriday,
      isCurrentUser: isCurrentUser,
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
      members: members.map((m) => m.toEntity()).toList(),
    );
  }
}

extension FamilyMemberPlanSummaryDtoMapper on FamilyMemberPlanSummaryDto {
  FamilyMemberPlanSummaryEntity toEntity() {
    return FamilyMemberPlanSummaryEntity(
      memberId: memberId,
      displayName: displayName,
      programNameAr: programNameAr,
      programNameEn: programNameEn,
      bundleNameAr: bundleNameAr,
      bundleNameEn: bundleNameEn,
      tier: tier,
      durationDays: durationDays,
      includeFriday: includeFriday,
      price: price,
    );
  }
}

extension FamilySummaryResponseDtoMapper on FamilySummaryResponseDto {
  FamilySummaryEntity toEntity() {
    return FamilySummaryEntity(
      subtotal: subtotal,
      familyDiscountPercent: familyDiscountPercent,
      familyDiscountAmount: familyDiscountAmount,
      finalPrice: finalPrice,
      canCheckout: canCheckout,
      checkoutBlockReason: checkoutBlockReason,
      members: members.map((m) => m.toEntity()).toList(),
    );
  }
}
