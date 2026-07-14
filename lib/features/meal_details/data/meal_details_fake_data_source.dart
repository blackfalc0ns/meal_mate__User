import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';

class MealDetailsFakeDataSource {
  const MealDetailsFakeDataSource();

  MealDetailsEntity getMeal() {
    return const MealDetailsEntity(
      title: 'دجاج مشوي مع الأرز البني',
      restaurantName: 'Kitchen Protein The',
      description:
          'وجبة متكاملة عالية البروتين ومصنوعة من مكونات طبيعية\nطازجة، مناسبة لبرنامج خسارة الوزن وبناء العضلات.',
      restaurantLogo: 'THE\nPROTEIN\nKITCHEN',
      ratingTitle: 'تقييم المطعم',
      ratingValue: '4.8 (520)',
      programLabel: 'مناسبة لبرنامج',
      programValue: 'خسارة الوزن',
      deliveryLabel: 'وقت التوصيل',
      deliveryValue: '1:00م -12:00م',
      ingredientsTitle: 'المكونات',
      ingredients: [
        MealDetailsIngredientEntity(
          label: 'دجاج مشوي',
          asset: Assets.mealDetailsIngredientChicken,
        ),
        MealDetailsIngredientEntity(
          label: 'أرز بني',
          asset: Assets.mealDetailsIngredientRice,
        ),
        MealDetailsIngredientEntity(
          label: 'جزر',
          asset: Assets.mealDetailsIngredientCarrot,
        ),
        MealDetailsIngredientEntity(
          label: 'بروكلي',
          asset: Assets.mealDetailsIngredientBroccoli,
        ),
        MealDetailsIngredientEntity(
          label: 'خس',
          asset: Assets.mealDetailsIngredientLettuce,
        ),
        MealDetailsIngredientEntity(
          label: 'ليمون',
          asset: Assets.mealDetailsIngredientLemon,
        ),
        MealDetailsIngredientEntity(
          label: 'دجاج',
          asset: Assets.mealDetailsIngredientChicken,
        ),
        MealDetailsIngredientEntity(
          label: 'أرز',
          asset: Assets.mealDetailsIngredientRice,
        ),
        MealDetailsIngredientEntity(
          label: 'خضار',
          asset: Assets.mealDetailsIngredientBroccoli,
        ),
        MealDetailsIngredientEntity(
          label: 'سلطة',
          asset: Assets.mealDetailsIngredientLettuce,
        ),
      ],
      nutritionTitle: 'القيم الغذائية',
      nutritionItems: [
        MealDetailsNutritionEntity(
          value: '7 جم',
          label: 'ألياف',
          type: MealDetailsNutritionType.fiber,
        ),
        MealDetailsNutritionEntity(
          value: '65 جم',
          label: 'بروتين',
          type: MealDetailsNutritionType.protein,
        ),
        MealDetailsNutritionEntity(
          value: '60 جم',
          label: 'كربوهيدرات',
          type: MealDetailsNutritionType.carbs,
        ),
        MealDetailsNutritionEntity(
          value: '15 جم',
          label: 'دهون',
          type: MealDetailsNutritionType.fat,
        ),
        MealDetailsNutritionEntity(
          value: '550',
          label: 'سعرة حرارية',
          type: MealDetailsNutritionType.calories,
        ),
      ],
      macroDistributionTitle: 'توزيع العناصر الغذائية',
      macroItems: [
        MealDetailsMacroEntity(
          percent: '%25',
          label: 'دهون',
          value: '15 جم',
          type: MealDetailsNutritionType.fat,
        ),
        MealDetailsMacroEntity(
          percent: '%30',
          label: 'بروتين',
          value: '65 جم',
          type: MealDetailsNutritionType.protein,
        ),
        MealDetailsMacroEntity(
          percent: '%45',
          label: 'كربوهيدرات',
          value: '60 جم',
          type: MealDetailsNutritionType.carbs,
        ),
      ],
      allergensTitle: 'مسببات الحساسية',
      allergens: [
        MealDetailsAllergenEntity(
          label: 'مكسرات',
          type: MealDetailsAllergenType.nuts,
        ),
        MealDetailsAllergenEntity(
          label: 'لاكتوز',
          type: MealDetailsAllergenType.lactose,
        ),
        MealDetailsAllergenEntity(
          label: 'جلوتين',
          type: MealDetailsAllergenType.gluten,
        ),
      ],
    );
  }
}
