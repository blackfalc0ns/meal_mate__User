import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class CancelCampaignSubscriptionUseCase {
  const CancelCampaignSubscriptionUseCase(this._repository);
  final OffersRepository _repository;
  Future<ApiResult<void>> call(String subscriptionId) =>
      _repository.cancelCampaignSubscription(subscriptionId);
}
