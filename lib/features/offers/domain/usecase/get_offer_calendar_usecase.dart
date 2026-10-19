import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_calendar_entry_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@injectable
class GetOfferCalendarUseCase {
  const GetOfferCalendarUseCase(this._repository);

  final OffersRepository _repository;

  Future<ApiResult<List<OfferCalendarEntryEntity>>> call() {
    return _repository.getOfferCalendar();
  }
}
