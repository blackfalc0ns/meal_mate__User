enum HomeNutritionDetailsMacroType { protein, carbs, fat, fiber, sugar }

class HomeNutritionDetailsEntity {
  const HomeNutritionDetailsEntity({
    required this.remainingCalories,
    required this.burnedCalories,
    required this.goalCalories,
    required this.macros,
  });

  final int remainingCalories;
  final int burnedCalories;
  final int goalCalories;
  final List<HomeNutritionDetailsMacroEntity> macros;
}

class HomeNutritionDetailsMacroEntity {
  const HomeNutritionDetailsMacroEntity({
    required this.type,
    required this.consumed,
    required this.target,
    required this.percent,
    required this.imageAsset,
  });

  final HomeNutritionDetailsMacroType type;
  final int consumed;
  final int target;
  final int percent;
  final String imageAsset;
}
