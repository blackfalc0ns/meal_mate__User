import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';

@injectable
class GetCalendarUseCase {
  GetCalendarUseCase(this._repository);

  final CalendarRepository _repository;

  Future<ApiResult<CalendarSubscriptionEntity>> call({
    required String subscriptionId,
    required String localeName,
  }) {
    return _repository.getCalendar(
      subscriptionId: subscriptionId,
      localeName: localeName,
    );
  }
}
