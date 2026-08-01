import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_nutrition_details_entity.dart';

class HomeNutritionDetailsFakeDataSource {
  const HomeNutritionDetailsFakeDataSource();

  HomeNutritionDetailsEntity getDetails() {
    return const HomeNutritionDetailsEntity(
      remainingCalories: 380,
      burnedCalories: 620,
      goalCalories: 2000,
      macros: [
        HomeNutritionDetailsMacroEntity(
          type: HomeNutritionDetailsMacroType.protein,
          consumed: 89,
          target: 120,
          percent: 74,
          imageAsset: AssetsFake.nutritionDetailsProtein,
        ),
        HomeNutritionDetailsMacroEntity(
          type: HomeNutritionDetailsMacroType.carbs,
          consumed: 210,
          target: 260,
          percent: 81,
          imageAsset: AssetsFake.nutritionDetailsCarbs,
        ),
        HomeNutritionDetailsMacroEntity(
          type: HomeNutritionDetailsMacroType.fat,
          consumed: 58,
          target: 70,
          percent: 83,
          imageAsset: AssetsFake.nutritionDetailsFat,
        ),
        HomeNutritionDetailsMacroEntity(
          type: HomeNutritionDetailsMacroType.fiber,
          consumed: 22,
          target: 30,
          percent: 73,
          imageAsset: AssetsFake.nutritionDetailsFiber,
        ),
        HomeNutritionDetailsMacroEntity(
          type: HomeNutritionDetailsMacroType.sugar,
          consumed: 18,
          target: 50,
          percent: 36,
          imageAsset: AssetsFake.nutritionDetailsSugar,
        ),
      ],
    );
  }
}
