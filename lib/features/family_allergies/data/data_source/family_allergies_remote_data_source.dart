import 'package:meal_meat_user/features/family_allergies/data/models/request/family_member_allergies_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_disliked_ingredients_request_dto.dart';

abstract interface class FamilyAllergiesRemoteDataSource {
  Future<bool> saveMemberAllergies(
    String memberId,
    FamilyMemberAllergiesRequestDto request,
  );
  Future<void> saveMemberDislikedIngredients(
    String memberId,
    FoodPreferencesDislikedIngredientsRequestDto request,
  );
}
