import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

class FamilyHomeEntity {
  const FamilyHomeEntity({
    required this.groupId,
    required this.name,
    required this.status,
    required this.packageName,
    required this.price,
    required this.currencyCode,
    required this.walletAvailable,
    required this.shortcuts,
    required this.members,
    required this.todaySchedule,
  });

  final String groupId;
  final String name;
  final int status;
  final String packageName;
  final double price;
  final String currencyCode;
  final bool walletAvailable;
  final List<FamilyShortcutEntity> shortcuts;
  final List<FamilyMemberSummaryEntity> members;
  final List<FamilyMemberSummaryEntity> todaySchedule;
}

class FamilyShortcutEntity {
  const FamilyShortcutEntity({
    required this.code,
    required this.enabled,
    this.unavailableReason,
  });

  final String code;
  final bool enabled;
  final String? unavailableReason;
}
