import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class StartCampaignPaymentUseCase {
  const StartCampaignPaymentUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<CampaignPaymentEntity>> call(
    StartCampaignPaymentRequestEntity request,
  ) {
    return _repository.startCampaignPayment(request);
  }
}
