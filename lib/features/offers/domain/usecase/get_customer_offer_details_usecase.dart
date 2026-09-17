import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetCustomerOfferDetailsUseCase {
  const GetCustomerOfferDetailsUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<OfferEntity>> call(String offerId) {
    return _repository.getOfferDetails(offerId);
  }
}
