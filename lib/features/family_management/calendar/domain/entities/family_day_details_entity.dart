enum FamilyDayMealIconType { breakfast, lunch, dinner, snack }

class FamilyDayDetailsEntity {
  const FamilyDayDetailsEntity({
    required this.title,
    required this.reviewButtonLabel,
    required this.selectedMealsLabel,
    required this.members,
    required this.member,
    required this.meals,
  });

  final String title;
  final String reviewButtonLabel;
  final String selectedMealsLabel;
  final List<FamilyDayMemberEntity> members;
  final FamilyDayMemberEntity member;
  final List<FamilyDayMealEntity> meals;
}

class FamilyDayMemberEntity {
  const FamilyDayMemberEntity({
    required this.name,
    required this.ageLabel,
    required this.statusLabel,
    required this.imageAsset,
    this.memberId,
    this.subscriptionId,
    this.imageUrl,
  });

  final String name;
  final String ageLabel;
  final String statusLabel;
  final String imageAsset;
  final String? memberId;
  final String? subscriptionId;
  final String? imageUrl;
}

class FamilyDayMealEntity {
  const FamilyDayMealEntity({
    required this.mealType,
    required this.restaurantName,
    required this.mealName,
    required this.actionLabel,
    required this.imageAsset,
    required this.iconType,
    this.calories = '',
    this.carbs = '',
    this.protein = '',
    this.fat = '',
    this.caloriesLabel,
    this.carbsLabel,
    this.proteinLabel,
    this.fatLabel,
    this.imageUrl,
    this.isEmpty = false,
  });

  final String mealType;
  final String restaurantName;
  final String mealName;
  final String actionLabel;
  final String imageAsset;
  final FamilyDayMealIconType iconType;
  final String calories;
  final String carbs;
  final String protein;
  final String fat;
  final String? caloriesLabel;
  final String? carbsLabel;
  final String? proteinLabel;
  final String? fatLabel;
  final String? imageUrl;
  final bool isEmpty;
}
