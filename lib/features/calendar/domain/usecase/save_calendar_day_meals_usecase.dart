import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';

@injectable
class SaveCalendarDayMealsUseCase {
  SaveCalendarDayMealsUseCase(this._repository);

  final CalendarRepository _repository;

  Future<ApiResult<void>> call({
    required String subscriptionId,
    required String date,
    required List<CalendarMealEntity> meals,
  }) {
    return _repository.saveDayMeals(
      subscriptionId: subscriptionId,
      date: date,
      meals: meals,
    );
  }
}
