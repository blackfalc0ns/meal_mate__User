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
}

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
