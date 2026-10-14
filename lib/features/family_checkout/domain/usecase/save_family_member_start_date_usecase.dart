import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_checkout/domain/repo/family_checkout_repository.dart';

@injectable
class SaveFamilyMemberStartDateUseCase {
  SaveFamilyMemberStartDateUseCase(this._repository);

  final FamilyCheckoutRepository _repository;

  Future<ApiResult<void>> call({
    required String memberId,
    required String startDate,
  }) {
    return _repository.saveFamilyMemberStartDate(
      memberId: memberId,
      startDate: startDate,
    );
  }
}
