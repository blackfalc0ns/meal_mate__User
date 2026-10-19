import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class RemoveOfferFromCalendarUseCase {
  const RemoveOfferFromCalendarUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<void>> call({
    required String offerId,
    required String date,
  }) {
    return _repository.removeOfferFromCalendar(offerId, date);
  }
}
