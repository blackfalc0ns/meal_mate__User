import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_eligible_restaurant_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetOfferEligibleRestaurantsUseCase {
  const GetOfferEligibleRestaurantsUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<List<OfferEligibleRestaurantEntity>>> call(String offerId) {
    return _repository.getOfferEligibleRestaurants(offerId);
  }
}
