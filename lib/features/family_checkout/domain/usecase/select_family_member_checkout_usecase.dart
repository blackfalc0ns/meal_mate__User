import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_checkout_selection_entity.dart';
import 'package:meal_meat_user/features/family_checkout/domain/repo/family_checkout_repository.dart';

@injectable
class SelectFamilyMemberCheckoutUseCase {
  const SelectFamilyMemberCheckoutUseCase(this._repository);

  final FamilyCheckoutRepository _repository;

  Future<ApiResult<FamilyCheckoutSelectionEntity>> call({
    required String memberId,
    required bool subscribeNow,
  }) {
    return _repository.selectFamilyMemberForCheckout(
      memberId: memberId,
      subscribeNow: subscribeNow,
    );
  }
}
