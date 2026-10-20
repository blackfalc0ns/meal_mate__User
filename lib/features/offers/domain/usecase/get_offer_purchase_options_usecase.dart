import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetOfferPurchaseOptionsUseCase {
  const GetOfferPurchaseOptionsUseCase(this._repository);
  final OffersRepository _repository;

  Future<ApiResult<OfferPurchaseOptionsEntity>> call(
    String offerId, {
    String? startDate,
    bool? includeFriday,
  }) => _repository.getOfferPurchaseOptions(
    offerId,
    startDate: startDate,
    includeFriday: includeFriday,
  );
}
