import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';

@injectable
class SetCalendarDayRestaurantUseCase {
  SetCalendarDayRestaurantUseCase(this._repository);

  final CalendarRepository _repository;

  Future<ApiResult<CalendarDayEntity>> call({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
  }) {
    return _repository.setDayRestaurant(
      subscriptionId: subscriptionId,
      date: date,
      restaurantId: restaurantId,
      localeName: localeName,
    );
  }
}
