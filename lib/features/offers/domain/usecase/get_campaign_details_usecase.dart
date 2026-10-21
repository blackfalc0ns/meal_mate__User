import 'package:meal_meat_user/features/offers/domain/entities/campaign_flow_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetCampaignDetailsUseCase {
  const GetCampaignDetailsUseCase(this._repository);
  final OffersRepository _repository;
  Future<ApiResult<CampaignDetailsEntity>> call(
    String campaignId, {
    String? bundleId,
    int? durationDays,
  }) => _repository.getCampaignDetails(
    campaignId,
    bundleId: bundleId,
    durationDays: durationDays,
  );
}
