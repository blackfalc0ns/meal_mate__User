import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetSavedOffersUseCase {
  const GetSavedOffersUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<List<OfferEntity>>> call() {
    return _repository.getSavedOffers();
  }
}
