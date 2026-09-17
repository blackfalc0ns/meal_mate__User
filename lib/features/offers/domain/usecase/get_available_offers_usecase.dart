import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetAvailableOffersUseCase {
  const GetAvailableOffersUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<List<OfferEntity>>> call({
    double cartAmount = 0.0,
    int durationDays = 26,
    String? deliveryGovernorate,
    String? programId,
    String? bundleId,
    String? restaurantId,
  }) {
    return _repository.getAvailableOffers(
      cartAmount: cartAmount,
      durationDays: durationDays,
      deliveryGovernorate: deliveryGovernorate,
      programId: programId,
      bundleId: bundleId,
      restaurantId: restaurantId,
    );
  }
}
