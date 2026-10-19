import 'package:flutter/foundation.dart';

class FamilySubscriptionSettingsEntity {
  const FamilySubscriptionSettingsEntity({
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.originalPrice,
    required this.discountedPrice,
    required this.currency,
    required this.endsOn,
    required this.heroImageAsset,
    required this.members,
    required this.quickActions,
    required this.mealStatuses,
    required this.warningTitle,
    required this.warningMessage,
  });

  final String title;
  final String subtitle;
  final String statusLabel;
  final String originalPrice;
  final String discountedPrice;
  final String currency;
  final String endsOn;
  final String heroImageAsset;
  final List<FamilySubscriptionMemberEntity> members;
  final List<FamilySubscriptionQuickActionEntity> quickActions;
  final List<FamilySubscriptionMealStatusEntity> mealStatuses;
  final String warningTitle;
  final String warningMessage;
}

class FamilySubscriptionMembersPageEntity {
  const FamilySubscriptionMembersPageEntity({required this.members});

  final List<FamilySubscriptionListMemberEntity> members;
}

class FamilyMemberDetailEntity {
  const FamilyMemberDetailEntity({
    this.memberId = '',
    this.subscriptionId,
    this.isManager = false,
    this.canManageAccess = true,
    required this.title,
    required this.name,
    required this.imageAsset,
    required this.ageLabel,
    required this.statusLabel,
    required this.roleLabel,
    required this.programTitle,
    required this.programImageAsset,
    required this.programName,
    this.programSubtitle = '',
    required this.changeProgramLabel,
    required this.packageTitle,
    required this.remainingDaysLabel,
    required this.packageDescription,
    this.packageSubtitle = '',
    this.packageImageAsset = '',
    required this.editPackageLabel,
    required this.selectionTitle,
    required this.completedValue,
    required this.completedLabel,
    required this.progress,
    required this.showCalendarLabel,
    required this.shortcuts,
    this.canUpgradeTier = false,
    this.canFreeze = false,
    this.canRenew = false,
    this.canCancel = false,
    this.onUpgradeTier,
    this.onFreeze,
    this.onRenew,
    this.onCancel,
  });

  final String memberId;
  final String? subscriptionId;
  final bool isManager;
  final bool canManageAccess;

  final String title;
  final String name;
  final String imageAsset;
  final String ageLabel;
  final String statusLabel;
  final String roleLabel;
  final String programTitle;
  final String programImageAsset;
  final String programName;
  final String programSubtitle;
  final String changeProgramLabel;
  final String packageTitle;
  final String remainingDaysLabel;
  final String packageDescription;
  final String packageSubtitle;
  final String packageImageAsset;
  final String editPackageLabel;
  final String selectionTitle;
  final String completedValue;
  final String completedLabel;
  final double progress;
  final String showCalendarLabel;
  final List<FamilyMemberDetailShortcutEntity> shortcuts;

  final bool canUpgradeTier;
  final bool canFreeze;
  final bool canRenew;
  final bool canCancel;
  final VoidCallback? onUpgradeTier;
  final VoidCallback? onFreeze;
  final VoidCallback? onRenew;
  final VoidCallback? onCancel;
}

class FamilyMemberDetailShortcutEntity {
  const FamilyMemberDetailShortcutEntity({
    required this.title,
    required this.subtitle,
    required this.type,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final FamilyMemberDetailShortcutType type;
  final void Function()? onTap;
}

enum FamilyMemberDetailShortcutType { dailyMeals, permissions }

class FamilyMemberPermissionsPageEntity {
  const FamilyMemberPermissionsPageEntity({
    required this.memberName,
    required this.memberImageAsset,
    required this.sections,
  });

  final String memberName;
  final String memberImageAsset;
  final List<FamilyMemberPermissionSectionEntity> sections;
}

class FamilyMemberPermissionSectionEntity {
  const FamilyMemberPermissionSectionEntity({
    required this.iconType,
    required this.permissions,
  });

  final FamilyMemberPermissionSectionIconType iconType;
  final List<FamilyMemberPermissionEntity> permissions;
}

class FamilyMemberPermissionEntity {
  const FamilyMemberPermissionEntity({
    required this.type,
    required this.enabled,
  });

  final FamilyMemberPermissionType type;
  final bool enabled;
}

enum FamilyMemberPermissionSectionIconType { meals, program, settings }

enum FamilyMemberPermissionType {
  chooseDailyMeals,
  editMealsBeforeLock,
  viewMealDetails,
  viewNutritionProgram,
  changeNutritionProgram,
  editMealsAndDaysCount,
  editAddress,
  replaceMeal,
  viewReportsAndPayments,
  leaveFamilyPlan,
}

class FamilySubscriptionListMemberEntity {
  const FamilySubscriptionListMemberEntity({
    required this.name,
    required this.imageAsset,
    required this.accountLabel,
    required this.programLabel,
    required this.mealsLabel,
    required this.daysLabel,
    required this.statusLabel,
    required this.status,
    required this.noteLabel,
    required this.noteStatus,
    required this.goal,
  });

  final String name;
  final String imageAsset;
  final String accountLabel;
  final String programLabel;
  final String mealsLabel;
  final String daysLabel;
  final String statusLabel;
  final FamilySubscriptionListMemberStatus status;
  final String noteLabel;
  final FamilySubscriptionListMemberNoteStatus noteStatus;
  final FamilySubscriptionListMemberGoal goal;
}

class FamilySubscriptionMemberEntity {
  const FamilySubscriptionMemberEntity({
    required this.name,
    required this.imageAsset,
    required this.statusLabel,
    required this.isComplete,
    this.memberId = '',
    this.onTap,
  });

  final String name;
  final String imageAsset;
  final String statusLabel;
  final bool isComplete;
  final String memberId;
  final void Function()? onTap;
}

class FamilySubscriptionQuickActionEntity {
  const FamilySubscriptionQuickActionEntity({
    this.code = '',
    required this.label,
    required this.iconAsset,
  });

  final String code;
  final String label;
  final String iconAsset;
}

class FamilySubscriptionMealStatusEntity {
  const FamilySubscriptionMealStatusEntity({
    required this.memberName,
    required this.memberImageAsset,
    required this.mealsLabel,
    required this.statusLabel,
    required this.progress,
    required this.status,
  });

  final String memberName;
  final String memberImageAsset;
  final String mealsLabel;
  final String statusLabel;
  final double progress;
  final FamilySubscriptionMealStatus status;
}

enum FamilySubscriptionMealStatus { completed, selected, missing }

enum FamilySubscriptionListMemberStatus { active, setup }

enum FamilySubscriptionListMemberNoteStatus { success, warning, error }

enum FamilySubscriptionListMemberGoal { balanced, weightLoss, muscleGain }

enum FamilyMemberAccessStatus { active, paused }

class FamilyMemberAccessEntity {
  const FamilyMemberAccessEntity({
    required this.memberName,
    required this.memberImageAsset,
    required this.status,
    required this.lastLogin,
    required this.email,
    required this.hasIndependentAccount,
  });

  final String memberName;
  final String memberImageAsset;
  final FamilyMemberAccessStatus status;
  final String lastLogin;
  final String email;
  final bool hasIndependentAccount;
}
