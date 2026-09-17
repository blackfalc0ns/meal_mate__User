import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_allergies/domain/repo/family_allergies_repository.dart';

@injectable
class SaveFamilyMemberDislikedIngredientsUseCase {
  const SaveFamilyMemberDislikedIngredientsUseCase(this._repository);

  final FamilyAllergiesRepository _repository;

  Future<ApiResult<void>> call({
    required String memberId,
    required List<String> ingredientCodes,
  }) => _repository.saveMemberDislikedIngredients(
    memberId: memberId,
    ingredientCodes: ingredientCodes,
  );
}
