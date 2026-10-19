import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_calendar_entry_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class AddOfferToCalendarUseCase {
  const AddOfferToCalendarUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<OfferCalendarEntryEntity>> call({
    required String offerId,
    required String scheduledDate,
  }) {
    return _repository.addOfferToCalendar(offerId, scheduledDate);
  }
}
