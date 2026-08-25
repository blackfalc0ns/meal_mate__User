import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';

@injectable
class GetCalendarRestaurantsUseCase {
  GetCalendarRestaurantsUseCase(this._repository);

  final CalendarRepository _repository;

  Future<ApiResult<List<CalendarRestaurantOptionEntity>>> call({
    required String subscriptionId,
    required String localeName,
  }) {
    return _repository.getRestaurants(
      subscriptionId: subscriptionId,
      localeName: localeName,
    );
  }
}
