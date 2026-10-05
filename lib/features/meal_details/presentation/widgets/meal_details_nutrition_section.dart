import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_nutrition_card.dart';

class MealDetailsNutritionSection extends StatelessWidget {
  const MealDetailsNutritionSection({super.key, required this.meal});

  final MealDetailsEntity meal;

  @override
  Widget build(BuildContext context) {
    return MealDetailsNutritionCard(meal: meal);
  }
}
