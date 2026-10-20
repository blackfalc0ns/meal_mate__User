import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetAvailableOffersUseCase {
  const GetAvailableOffersUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<List<OfferEntity>>> call({
    double? cartAmount,
    int? durationDays,
    String? deliveryGovernorate,
    String? programId,
    String? bundleId,
    String? restaurantId,
    int? page,
    int? pageSize,
    String? search,
    String? category,
    bool? eligibleOnly,
    bool? includeCampaigns,
  }) {
    return _repository.getAvailableOffers(
      cartAmount: cartAmount,
      durationDays: durationDays,
      deliveryGovernorate: deliveryGovernorate,
      programId: programId,
      bundleId: bundleId,
      restaurantId: restaurantId,
      page: page,
      pageSize: pageSize,
      search: search,
      category: category,
      eligibleOnly: eligibleOnly,
      includeCampaigns: includeCampaigns,
    );
  }
}
