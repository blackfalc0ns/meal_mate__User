import 'package:meal_meat_user/features/offers/domain/entities/campaign_flow_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetCampaignsUseCase {
  const GetCampaignsUseCase(this._repository);
  final OffersRepository _repository;
  Future<ApiResult<CampaignPageEntity>> call({
    int pageSize = 20,
    String? cursor,
  }) => _repository.getCampaigns(pageSize: pageSize, cursor: cursor);
}
