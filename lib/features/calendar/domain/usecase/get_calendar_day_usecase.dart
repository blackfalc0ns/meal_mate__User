import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';

@injectable
class GetCalendarDayUseCase {
  GetCalendarDayUseCase(this._repository);

  final CalendarRepository _repository;

  Future<ApiResult<CalendarDayEntity>> call({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    return _repository.getDay(
      subscriptionId: subscriptionId,
      date: date,
      localeName: localeName,
    );
  }
}
