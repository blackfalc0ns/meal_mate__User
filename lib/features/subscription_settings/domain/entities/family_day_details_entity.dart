enum FamilyDayMealIconType { breakfast, lunch, dinner, snack }

class FamilyDayDetailsEntity {
  const FamilyDayDetailsEntity({
    required this.title,
    required this.reviewButtonLabel,
    required this.selectedMealsLabel,
    required this.member,
    required this.meals,
  });

  final String title;
  final String reviewButtonLabel;
  final String selectedMealsLabel;
  final FamilyDayMemberEntity member;
  final List<FamilyDayMealEntity> meals;
}

class FamilyDayMemberEntity {
  const FamilyDayMemberEntity({
    required this.name,
    required this.ageLabel,
    required this.statusLabel,
    required this.imageAsset,
  });

  final String name;
  final String ageLabel;
  final String statusLabel;
  final String imageAsset;
}

class FamilyDayMealEntity {
  const FamilyDayMealEntity({
    required this.mealType,
    required this.restaurantName,
    required this.mealName,
    required this.actionLabel,
    required this.imageAsset,
    required this.iconType,
  });

  final String mealType;
  final String restaurantName;
  final String mealName;
  final String actionLabel;
  final String imageAsset;
  final FamilyDayMealIconType iconType;
}
