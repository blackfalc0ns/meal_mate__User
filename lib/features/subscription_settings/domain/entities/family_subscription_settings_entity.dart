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

class FamilySubscriptionMemberEntity {
  const FamilySubscriptionMemberEntity({
    required this.name,
    required this.imageAsset,
    required this.statusLabel,
    required this.isComplete,
  });

  final String name;
  final String imageAsset;
  final String statusLabel;
  final bool isComplete;
}

class FamilySubscriptionQuickActionEntity {
  const FamilySubscriptionQuickActionEntity({
    required this.label,
    required this.iconAsset,
  });

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
