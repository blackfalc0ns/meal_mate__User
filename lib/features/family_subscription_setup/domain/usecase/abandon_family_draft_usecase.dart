import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';

@injectable
class AbandonFamilyDraftUseCase {
  AbandonFamilyDraftUseCase(this._repository);

  final FamilySubscriptionSetupRepository _repository;

  Future<ApiResult<void>> call() {
    return _repository.abandonFamilyDraft();
  }
}
