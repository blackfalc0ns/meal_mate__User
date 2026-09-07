import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_allergies/domain/repo/family_allergies_repository.dart';

@injectable
class SaveFamilyMemberAllergiesUseCase {
  const SaveFamilyMemberAllergiesUseCase(this._repository);
  final FamilyAllergiesRepository _repository;
  Future<ApiResult<bool>> call({
    required String memberId,
    required List<FamilyMemberAllergySelection> allergies,
  }) =>
      _repository.saveMemberAllergies(memberId: memberId, allergies: allergies);
}
