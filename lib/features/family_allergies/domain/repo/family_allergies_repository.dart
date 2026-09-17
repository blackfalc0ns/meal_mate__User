import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';

abstract interface class FamilyAllergiesRepository {
  Future<ApiResult<bool>> saveMemberAllergies({
    required String memberId,
    required List<FamilyMemberAllergySelection> allergies,
  });
  Future<ApiResult<void>> saveMemberDislikedIngredients({
    required String memberId,
    required List<String> ingredientCodes,
  });
}
