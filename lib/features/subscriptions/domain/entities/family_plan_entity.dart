class FamilyPlanEntity {
  const FamilyPlanEntity({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.statusLabel,
    required this.originalPrice,
    required this.discountedPrice,
    required this.currency,
    required this.features,
    required this.members,
    required this.summaryStats,
    required this.priceRows,
    required this.totalLabel,
    required this.totalPrice,
  });

  final String title;
  final String subtitle;
  final String badge;
  final String statusLabel;
  final String originalPrice;
  final String discountedPrice;
  final String currency;
  final List<String> features;
  final List<FamilyMemberEntity> members;
  final List<FamilySummaryStatEntity> summaryStats;
  final List<FamilyPriceRowEntity> priceRows;
  final String totalLabel;
  final String totalPrice;
}

class FamilyMemberEntity {
  const FamilyMemberEntity({
    required this.name,
    required this.imageAsset,
    required this.mealsCount,
    required this.mealChecks,
    this.isOwner = false,
    this.badgeColorHex = 0xFFEAF1EB,
    this.badgeTextColorHex = 0xFF0C6C3F,
  });

  final String name;
  final String imageAsset;
  final String mealsCount;
  final List<bool> mealChecks;
  final bool isOwner;
  final int badgeColorHex;
  final int badgeTextColorHex;
}

class FamilySummaryStatEntity {
  const FamilySummaryStatEntity({
    required this.value,
    required this.label,
    required this.iconName,
  });

  final String value;
  final String label;
  final String iconName;
}

class FamilyPriceRowEntity {
  const FamilyPriceRowEntity({required this.label, required this.value});

  final String label;
  final String value;
}
