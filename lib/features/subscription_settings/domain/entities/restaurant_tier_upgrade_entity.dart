class RestaurantTierUpgradeEntity {
  const RestaurantTierUpgradeEntity({
    required this.title,
    required this.packagePrefix,
    required this.mealsCount,
    required this.mealsSuffix,
    required this.remainingPrefix,
    required this.remainingDays,
    required this.remainingSuffix,
    required this.activeLabel,
    required this.currentLabel,
    required this.currentTierName,
    required this.note,
    required this.chooseTitle,
    required this.chooseSubtitle,
    required this.price,
    required this.pricePeriod,
    required this.continuePlusLabel,
    required this.continueMaxLabel,
    required this.tiers,
    required this.currentPackageLabel,
    required this.currentTier,
    required this.newTier,
    required this.features,
    required this.quickComparisonTitle,
    required this.quickComparisonRows,
    required this.detailsTitle,
    required this.detailsRows,
    required this.totalLabel,
    required this.totalValue,
    required this.applyNote,
    required this.paymentTitle,
    required this.paymentMethod,
    required this.confirmLabel,
    required this.backLabel,
  });

  final String title;
  final String packagePrefix;
  final String mealsCount;
  final String mealsSuffix;
  final String remainingPrefix;
  final String remainingDays;
  final String remainingSuffix;
  final String activeLabel;
  final String currentLabel;
  final String currentTierName;
  final String note;
  final String chooseTitle;
  final String chooseSubtitle;
  final String price;
  final String pricePeriod;
  final String continuePlusLabel;
  final String continueMaxLabel;
  final List<RestaurantTierOptionEntity> tiers;
  final String currentPackageLabel;
  final RestaurantTierPreviewEntity currentTier;
  final RestaurantTierPreviewEntity newTier;
  final List<RestaurantTierFeatureEntity> features;
  final String quickComparisonTitle;
  final List<RestaurantTierComparisonRowEntity> quickComparisonRows;
  final String detailsTitle;
  final List<RestaurantTierDetailRowEntity> detailsRows;
  final String totalLabel;
  final String totalValue;
  final String applyNote;
  final String paymentTitle;
  final RestaurantTierPaymentMethodEntity paymentMethod;
  final String confirmLabel;
  final String backLabel;
}

class RestaurantTierPreviewEntity {
  const RestaurantTierPreviewEntity({
    required this.name,
    required this.badgeAsset,
  });

  final String name;
  final String badgeAsset;
}

class RestaurantTierFeatureEntity {
  const RestaurantTierFeatureEntity({required this.label, required this.icon});

  final String label;
  final RestaurantTierFeatureIcon icon;
}

class RestaurantTierComparisonRowEntity {
  const RestaurantTierComparisonRowEntity({
    required this.packageLabel,
    required this.tierName,
    required this.badgeAsset,
    required this.restaurantCountPrefix,
    required this.restaurantCount,
    required this.restaurantCountSuffix,
    required this.caption,
  });

  final String packageLabel;
  final String tierName;
  final String badgeAsset;
  final String restaurantCountPrefix;
  final String restaurantCount;
  final String restaurantCountSuffix;
  final String caption;
}

class RestaurantTierDetailRowEntity {
  const RestaurantTierDetailRowEntity({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final bool isStrong;
}

class RestaurantTierPaymentMethodEntity {
  const RestaurantTierPaymentMethodEntity({
    required this.brand,
    required this.cardText,
    required this.subtitle,
    required this.changeLabel,
  });

  final String brand;
  final String cardText;
  final String subtitle;
  final String changeLabel;
}

enum RestaurantTierFeatureIcon { food, reward, restaurant }

class RestaurantTierOptionEntity {
  const RestaurantTierOptionEntity({
    required this.name,
    required this.description,
    required this.restaurantCount,
    required this.buttonLabel,
    required this.badgeAsset,
    required this.type,
  });

  final String name;
  final String description;
  final String restaurantCount;
  final String buttonLabel;
  final String badgeAsset;
  final RestaurantTierOptionType type;
}

enum RestaurantTierOptionType { current, plus, max }
