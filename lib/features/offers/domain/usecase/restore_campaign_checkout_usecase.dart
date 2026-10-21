import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_session_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class RestoreCampaignCheckoutUseCase {
  const RestoreCampaignCheckoutUseCase(this._repository);
  final OffersRepository _repository;
  Future<ApiResult<CampaignSessionEntity?>> call() =>
      _repository.restoreCampaignCheckoutSession();
}
