class CalendarRestaurantOptionEntity {
  const CalendarRestaurantOptionEntity({
    required this.name,
    required this.description,
    required this.mealCount,
    required this.rating,
    required this.logoType,
  });

  final String name;
  final String description;
  final int mealCount;
  final String rating;
  final CalendarRestaurantLogoType logoType;
}

enum CalendarRestaurantLogoType {
  healthyBowl,
  dietHouse,
  proteinKitchen,
  starbucks,
  burgerKing,
}
