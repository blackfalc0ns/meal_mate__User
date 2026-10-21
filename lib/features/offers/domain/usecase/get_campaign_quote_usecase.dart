import 'package:meal_meat_user/features/offers/domain/entities/campaign_flow_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_quote_request_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetCampaignQuoteUseCase {
  const GetCampaignQuoteUseCase(this._repository);
  final OffersRepository _repository;
  Future<ApiResult<CampaignQuoteEntity>> call(
    CampaignQuoteRequestEntity request,
  ) => _repository.getCampaignQuote(request);
}
