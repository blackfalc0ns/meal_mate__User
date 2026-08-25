import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';

@injectable
class AutoSelectCalendarDayUseCase {
  AutoSelectCalendarDayUseCase(this._repository);

  final CalendarRepository _repository;

  Future<ApiResult<void>> call({
    required String subscriptionId,
    required String date,
  }) {
    return _repository.autoSelect(subscriptionId: subscriptionId, date: date);
  }
}
