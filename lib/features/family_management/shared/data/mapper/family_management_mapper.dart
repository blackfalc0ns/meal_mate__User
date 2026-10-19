import 'package:meal_meat_user/features/family_management/overview/data/models/response/api/family_home_response_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/response/api/family_member_access_response_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/response/api/family_member_detail_response_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/response/api/family_member_permissions_response_dto.dart';
import 'package:meal_meat_user/features/family_management/overview/data/models/response/api/family_member_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_management/shared/domain/entities/family_management_entity.dart';

extension FamilyHomeResponseDtoMapper on FamilyHomeResponseDto {
  FamilyHomeEntity toEntity(String localeName) => FamilyHomeEntity(
    groupId: groupId ?? '',
    name: name ?? '',
    status: _familyStatusCode(status),
    packageName: localeName == 'ar'
        ? packageLabelAr ?? packageLabelEn ?? ''
        : packageLabelEn ?? packageLabelAr ?? '',
    price: quotedFinalPrice ?? 0,
    currencyCode: currencyCode ?? '',
    walletAvailable: wallet?.available ?? false,
    shortcuts: (shortcuts ?? const [])
        .where((item) => item.enabled == true)
        .map(
          (item) => FamilyShortcutEntity(code: item.code ?? '', enabled: true),
        )
        .where((item) => item.code.isNotEmpty)
        .toList(),
    members: (members ?? const [])
        .map((item) => item.toEntity(localeName))
        .toList(),
    todaySchedule: (todaySchedule ?? const [])
        .map((item) => item.toEntity(localeName))
        .toList(),
  );
}

extension FamilyMemberSummaryResponseDtoMapper
    on FamilyMemberSummaryResponseDto {
  FamilyMemberSummaryEntity toEntity(String localeName) =>
      FamilyMemberSummaryEntity(
        memberId: memberId ?? '',
        displayName: displayName ?? '',
        role: _familyRoleCode(role),
        ageYears: ageYears,
        isPaused: isPaused ?? false,
        subscriptionId: memberSubscriptionId?.trim().isEmpty == true
            ? null
            : memberSubscriptionId,
        programName: localeName == 'ar'
            ? programNameAr ??
                  programLabelAr ??
                  programNameEn ??
                  programLabelEn ??
                  programName ??
                  programLabel ??
                  ''
            : programNameEn ??
                  programLabelEn ??
                  programNameAr ??
                  programLabelAr ??
                  programName ??
                  programLabel ??
                  '',
        remainingDays: remainingDays ?? 0,
        setupStatus: _familySetupStatusCode(setupStatus),
        todayUiStatus: todayUiStatus,
        todayFilledCount: todayFilledCount ?? 0,
        todayRequiredCount: todayRequiredCount ?? 0,
        lifecycleStatus: lifecycle?.status,
        checkoutSelected: lifecycle?.checkoutSelected ?? false,
      );
}

extension FamilyMemberDetailResponseDtoMapper on FamilyMemberDetailResponseDto {
  FamilyMemberDetailEntity toEntity(String localeName) =>
      FamilyMemberDetailEntity(
        memberId: memberId ?? '',
        displayName: displayName ?? '',
        role: _familyRoleCode(role),
        ageYears: ageYears,
        isPaused: isPaused ?? false,
        subscriptionId: memberSubscriptionId?.trim().isEmpty == true
            ? null
            : memberSubscriptionId,
        currentSubscriptionId: currentSubscriptionId?.trim().isEmpty == true
            ? null
            : (currentSubscriptionId ?? memberSubscriptionId),
        upcomingSubscriptionId: upcomingSubscriptionId?.trim().isEmpty == true
            ? null
            : upcomingSubscriptionId,
        programName: localeName == 'ar'
            ? programNameAr ?? programNameEn ?? programName ?? ''
            : programNameEn ?? programNameAr ?? programName ?? '',
        remainingDays: remainingDays ?? 0,
        setupStatus: _familySetupStatusCode(setupStatus),
        canRenew: canRenew == true && renewalPath?.trim().isNotEmpty == true,
        relationshipCode: relationshipCode,
        phoneNumber: phoneNumber,
        startDate: DateTime.tryParse(startDate ?? ''),
        endDate: DateTime.tryParse(endDate ?? ''),
        renewalPath: renewalPath,
        hasSeparateAccount: hasSeparateAccount ?? false,
        todayNutrition: todayNutrition?.toEntity(),
        lifecycleStatus: lifecycle?.status,
        checkoutSelected: lifecycle?.checkoutSelected ?? false,
      );
}

int _familyRoleCode(Object? value) {
  if (value is num) return value.toInt();
  return switch (value?.toString().trim().toLowerCase()) {
    'manager' => 1,
    'member' => 2,
    _ => 0,
  };
}

int _familyStatusCode(Object? value) {
  if (value is num) return value.toInt();
  return switch (value?.toString().trim().toLowerCase()) {
    'active' => 1,
    _ => 0,
  };
}

int _familySetupStatusCode(Object? value) {
  if (value is num) return value.toInt();
  return switch (value?.toString().trim().toLowerCase()) {
    'notstarted' => 0,
    'inprogress' => 1,
    'ready' => 2,
    _ => 0,
  };
}

extension on FamilyNutritionResponseDto {
  FamilyNutritionEntity toEntity() => FamilyNutritionEntity(
    calories: calories ?? 0,
    proteinG: proteinG ?? 0,
    carbsG: carbsG ?? 0,
    fatG: fatG ?? 0,
  );
}

extension FamilyMemberAccessResponseDtoMapper on FamilyMemberAccessResponseDto {
  FamilyMemberAccessEntityV2 toEntity() => FamilyMemberAccessEntityV2(
    memberId: memberId ?? '',
    hasSeparateAccount: hasSeparateAccount ?? false,
    isPaused: isPaused ?? false,
    hasExistingLogin: hasExistingLogin ?? false,
    linkedCustomerUserId: linkedCustomerUserId,
    pausedAtUtc: DateTime.tryParse(pausedAtUtc ?? ''),
    removedAtUtc: DateTime.tryParse(removedAtUtc ?? ''),
    inviteDeepLink: inviteDeepLink,
    inviteExpiresAtUtc: DateTime.tryParse(inviteExpiresAtUtc ?? ''),
    phoneNumber: phoneNumber,
    generatedPassword: generatedPassword,
    version: version,
  );
}

extension FamilyMemberPermissionsResponseDtoMapper
    on FamilyMemberPermissionsResponseDto {
  FamilyMemberPermissionsEntity toEntity(String localeName) =>
      FamilyMemberPermissionsEntity(
        memberId: memberId ?? '',
        version: version,
        values: {
          'editDailyMeals': editDailyMeals ?? false,
          'changeDeliveryTime': changeDeliveryTime ?? false,
          'viewProgram': viewProgram ?? false,
          'changeProgram': changeProgram ?? false,
          'editMealsAndDays': editMealsAndDays ?? false,
          'editAddress': editAddress ?? false,
          'unitExchange': unitExchange ?? false,
          'changePassword': changePassword ?? false,
        },
        groups: (groups ?? const [])
            .map(
              (group) => FamilyPermissionGroupEntity(
                code: group.code ?? '',
                label: localeName == 'ar'
                    ? group.labelAr ?? group.labelEn ?? ''
                    : group.labelEn ?? group.labelAr ?? '',
                labelAr: group.labelAr,
                labelEn: group.labelEn,
                permissions: (group.permissions ?? const [])
                    .where((item) {
                      final k = item.key ?? '';
                      if (k == 'changeProgram' || k == 'changeDeliveryTime') {
                        return false;
                      }
                      if (item.isSupported == false) {
                        return false;
                      }
                      return true;
                    })
                    .map(
                      (item) => FamilyPermissionItemEntity(
                        key: item.key ?? '',
                        label: localeName == 'ar'
                            ? item.labelAr ?? item.labelEn ?? ''
                            : item.labelEn ?? item.labelAr ?? '',
                        value: item.value ?? false,
                        labelAr: item.labelAr,
                        labelEn: item.labelEn,
                        descriptionAr: item.descriptionAr,
                        descriptionEn: item.descriptionEn,
                        isSupported: item.isSupported ?? true,
                        isManagerConfigurable: item.isManagerConfigurable ?? true,
                        requiredPermissions: item.requiredPermissions ?? const [],
                      ),
                    )
                    .toList(),
              ),
            )
            .where((group) => group.permissions.isNotEmpty)
            .toList(),
      );
}
