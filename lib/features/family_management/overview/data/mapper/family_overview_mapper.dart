import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_home_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_home_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_summary_response_dto.dart';

class FamilyOverviewMapper {
  const FamilyOverviewMapper._();

  static FamilyHomeEntity toHomeEntity(
    FamilyHomeResponseDto dto, {
    String locale = 'ar',
  }) {
    final packageName = locale.toLowerCase().startsWith('en')
        ? (dto.packageLabelEn ?? dto.packageLabelAr ?? '')
        : (dto.packageLabelAr ?? dto.packageLabelEn ?? '');

    final statusInt = _mapStatusToInt(dto.status);

    return FamilyHomeEntity(
      groupId: dto.groupId ?? '',
      name: dto.name ?? '',
      status: statusInt,
      packageName: packageName,
      price: dto.quotedFinalPrice ?? 0.0,
      currencyCode: dto.currencyCode ?? 'KWD',
      walletAvailable: dto.wallet?.available ?? false,
      shortcuts: (dto.shortcuts ?? const [])
          .where((item) => item.enabled == true)
          .map(
            (s) => FamilyShortcutEntity(
              code: s.code ?? '',
              enabled: true,
              unavailableReason: s.unavailableReason,
            ),
          )
          .where((item) => item.code.isNotEmpty)
          .toList(),
      members: (dto.members ?? const [])
          .map((m) => toMemberSummaryEntity(m, locale: locale))
          .toList(),
      todaySchedule: (dto.todaySchedule ?? const [])
          .map((m) => toMemberSummaryEntity(m, locale: locale))
          .toList(),
    );
  }

  static FamilyMemberSummaryEntity toMemberSummaryEntity(
    FamilyMemberSummaryResponseDto dto, {
    String locale = 'ar',
  }) {
    final isEn = locale.toLowerCase().startsWith('en');
    final programName = isEn
        ? (dto.programNameEn ??
            dto.programLabelEn ??
            dto.programNameAr ??
            dto.programLabelAr ??
            dto.programName ??
            dto.programLabel ??
            '')
        : (dto.programNameAr ??
            dto.programLabelAr ??
            dto.programNameEn ??
            dto.programLabelEn ??
            dto.programName ??
            dto.programLabel ??
            '');

    return FamilyMemberSummaryEntity(
      memberId: dto.memberId ?? '',
      displayName: dto.displayName ?? '',
      role: _mapRoleCode(dto.role),
      ageYears: dto.ageYears,
      isPaused: dto.isPaused ?? false,
      subscriptionId: dto.memberSubscriptionId?.trim().isEmpty == true
          ? null
          : dto.memberSubscriptionId,
      upcomingSubscriptionId: dto.upcomingSubscriptionId?.trim().isEmpty == true
          ? null
          : dto.upcomingSubscriptionId,
      upcomingStartDate: dto.upcomingStartDate,
      programName: programName,
      remainingDays: dto.remainingDays ?? 0,
      setupStatus: _mapSetupStatusToInt(dto.setupStatus),
      todayUiStatus: dto.todayUiStatus,
      todayFilledCount: dto.todayFilledCount ?? 0,
      todayRequiredCount: dto.todayRequiredCount ?? 0,
      lifecycleStatus: dto.lifecycle?.status,
      checkoutSelected: dto.lifecycle?.checkoutSelected ?? false,
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

  static int _mapStatusToInt(Object? status) {
    if (status is num) return status.toInt();
    return switch (status?.toString().trim().toLowerCase()) {
      'active' => 1,
      'inactive' => 0,
      _ => 0,
    };
  }

  static int _mapSetupStatusToInt(Object? setupStatus) {
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
