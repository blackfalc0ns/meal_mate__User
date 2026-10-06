import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurants_page_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';

@injectable
class GetCalendarRestaurantsUseCase {
  GetCalendarRestaurantsUseCase(this._repository);

  final CalendarRepository _repository;

  Future<ApiResult<CalendarRestaurantsPageEntity>> call({
    required String subscriptionId,
    required String date,
    required String localeName,
    String? query,
    int? page,
    int? pageSize,
  }) {
    return _repository.getRestaurants(
      subscriptionId: subscriptionId,
      date: date,
      localeName: localeName,
      query: query,
      page: page,
      pageSize: pageSize,
    );
  }
}
