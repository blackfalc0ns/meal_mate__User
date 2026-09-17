import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_session_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class CreateCampaignCheckoutSessionUseCase {
  const CreateCampaignCheckoutSessionUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<CampaignSessionEntity>> call({
    required String campaignId,
    required String bundleId,
    required int durationDays,
    List<String>? requestedServiceDates,
    String? deliveryGovernorate,
  }) {
    return _repository.createCampaignCheckoutSession(
      campaignId: campaignId,
      bundleId: bundleId,
      durationDays: durationDays,
      requestedServiceDates: requestedServiceDates,
      deliveryGovernorate: deliveryGovernorate,
    );
  }
}
