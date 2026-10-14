import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_access_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_detail_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_permissions_response_dto.dart';

class FamilyMemberMapper {
  const FamilyMemberMapper._();

  static FamilyMemberDetailEntity toDetailEntity(
    FamilyMemberDetailResponseDto dto, {
    String locale = 'ar',
  }) {
    final isEn = locale.toLowerCase().startsWith('en');
    final programName = isEn
        ? (dto.programNameEn ?? dto.programNameAr ?? dto.programName ?? '')
        : (dto.programNameAr ?? dto.programNameEn ?? dto.programName ?? '');

    final nutrition = dto.todayNutrition != null
        ? FamilyNutritionEntity(
            calories: dto.todayNutrition!.calories ?? 0,
            proteinG: dto.todayNutrition!.proteinG ?? 0,
            carbsG: dto.todayNutrition!.carbsG ?? 0,
            fatG: dto.todayNutrition!.fatG ?? 0,
          )
        : null;

    DateTime? parseDate(String? str) {
      if (str == null || str.isEmpty) return null;
      return DateTime.tryParse(str);
    }

    final roleCode = _mapRoleCode(dto.role);
    final setupStatusCode = _mapSetupStatusCode(dto.setupStatus);

    return FamilyMemberDetailEntity(
      memberId: dto.memberId ?? '',
      displayName: dto.displayName ?? '',
      role: roleCode,
      ageYears: dto.ageYears,
      isPaused: dto.isPaused ?? false,
      subscriptionId: dto.memberSubscriptionId?.trim().isEmpty == true
          ? null
          : dto.memberSubscriptionId,
      currentSubscriptionId: dto.currentSubscriptionId?.trim().isEmpty == true
          ? null
          : (dto.currentSubscriptionId ?? dto.memberSubscriptionId),
      upcomingSubscriptionId: dto.upcomingSubscriptionId?.trim().isEmpty == true
          ? null
          : dto.upcomingSubscriptionId,
      programName: programName,
      remainingDays: dto.remainingDays ?? 0,
      setupStatus: setupStatusCode,
      canRenew: dto.canRenew == true && dto.renewalPath?.trim().isNotEmpty == true,
      relationshipCode: dto.relationshipCode,
      phoneNumber: dto.phoneNumber,
      startDate: parseDate(dto.startDate),
      endDate: parseDate(dto.endDate),
      renewalPath: dto.renewalPath,
      todayNutrition: nutrition,
      hasSeparateAccount: dto.hasSeparateAccount ?? false,
      lifecycleStatus: dto.lifecycle?.status,
      checkoutSelected: dto.lifecycle?.checkoutSelected ?? false,
    );
  }

  static FamilyMemberAccessEntity toAccessEntity(
    FamilyMemberAccessResponseDto dto,
  ) {
    DateTime? parseDate(String? str) {
      if (str == null || str.isEmpty) return null;
      return DateTime.tryParse(str);
    }

    return FamilyMemberAccessEntity(
      memberId: dto.memberId ?? '',
      hasSeparateAccount: dto.hasSeparateAccount ?? false,
      isPaused: dto.isPaused ?? false,
      hasExistingLogin: dto.hasExistingLogin ?? false,
      linkedCustomerUserId: dto.linkedCustomerUserId,
      pausedAtUtc: parseDate(dto.pausedAtUtc),
      removedAtUtc: parseDate(dto.removedAtUtc),
      inviteDeepLink: dto.inviteDeepLink,
      inviteExpiresAtUtc: parseDate(dto.inviteExpiresAtUtc),
      phoneNumber: dto.phoneNumber,
      generatedPassword: dto.generatedPassword,
      version: dto.version,
    );
  }

  static FamilyMemberPermissionsEntity toPermissionsEntity(
    FamilyMemberPermissionsResponseDto dto, {
    String locale = 'ar',
  }) {
    final values = <String, bool>{
      'editDailyMeals': dto.editDailyMeals ?? false,
      'changeDeliveryTime': dto.changeDeliveryTime ?? false,
      'viewProgram': dto.viewProgram ?? false,
      'changeProgram': dto.changeProgram ?? false,
      'editMealsAndDays': dto.editMealsAndDays ?? false,
      'editAddress': dto.editAddress ?? false,
      'unitExchange': dto.unitExchange ?? false,
      'changePassword': dto.changePassword ?? false,
    };

    final isEn = locale.toLowerCase().startsWith('en');

    final groups = (dto.groups ?? const [])
        .map(
          (group) => FamilyPermissionGroupEntity(
            code: group.code ?? '',
            label: isEn
                ? (group.labelEn ?? group.labelAr ?? '')
                : (group.labelAr ?? group.labelEn ?? ''),
            permissions: (group.permissions ?? const [])
                .map(
                  (item) => FamilyPermissionItemEntity(
                    key: item.key ?? '',
                    label: isEn
                        ? (item.labelEn ?? item.labelAr ?? '')
                        : (item.labelAr ?? item.labelEn ?? ''),
                    value: item.value ?? false,
                  ),
                )
                .toList(),
          ),
        )
        .toList();

    return FamilyMemberPermissionsEntity(
      memberId: dto.memberId ?? '',
      version: dto.version,
      values: values,
      groups: groups,
    );
  }

  static int _mapRoleCode(Object? role) {
    if (role is num) return role.toInt();
    return switch (role?.toString().trim().toLowerCase()) {
      'manager' => 1,
      'member' => 2,
      _ => 0,
    };
  }

  static int _mapSetupStatusCode(Object? setupStatus) {
    if (setupStatus is num) return setupStatus.toInt();
    return switch (setupStatus?.toString().trim().toLowerCase()) {
      'completed' || 'active' => 3,
      'readytopay' || 'ready' => 2,
      'setupincomplete' || 'inprogress' => 1,
      'notstarted' => 0,
      _ => 0,
    };
  }
}
