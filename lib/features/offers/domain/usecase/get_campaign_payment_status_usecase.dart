import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetCampaignPaymentStatusUseCase {
  const GetCampaignPaymentStatusUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<CampaignPaymentEntity>> call(String sessionId) {
    return _repository.getCampaignPaymentStatus(sessionId);
  }
}
