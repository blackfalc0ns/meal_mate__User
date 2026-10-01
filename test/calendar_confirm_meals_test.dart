import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/confirm_calendar_day_meals_usecase.dart';

class FakeCalendarRepository implements CalendarRepository {
  CalendarDayEntity? returnedDay;
  Failure? failure;
  int confirmCalls = 0;
  String? lastConfirmedDate;

  @override
  Future<ApiResult<CalendarDayEntity>> confirmDayMeals({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) async {
    confirmCalls++;
    lastConfirmedDate = date;
    if (failure != null) {
      return ApiErrorResult(failure: failure!);
    }
    return ApiSuccessResult(data: returnedDay ?? const CalendarDayEntity(dayNumber: 25, weekday: 'الأحد'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ConfirmCalendarDayMealsUseCase', () {
    late FakeCalendarRepository repo;
    late ConfirmCalendarDayMealsUseCase useCase;

    setUp(() {
      repo = FakeCalendarRepository();
      useCase = ConfirmCalendarDayMealsUseCase(repo);
    });

    test('successfully calls repository confirmDayMeals and returns confirmed entity', () async {
      repo.returnedDay = const CalendarDayEntity(
        id: 'day-1',
        status: 'SentToRestaurant',
        uiStatus: 'awaiting_restaurant',
        canEdit: false,
        dayNumber: 25,
        weekday: 'الأحد',
      );

      final result = await useCase(
        subscriptionId: 'sub-123',
        date: '2026-09-25',
        localeName: 'ar',
      );

      expect(repo.confirmCalls, 1);
      expect(repo.lastConfirmedDate, '2026-09-25');
      expect(result, isA<ApiSuccessResult<CalendarDayEntity>>());
      final entity = (result as ApiSuccessResult<CalendarDayEntity>).data;
      expect(entity.status, 'SentToRestaurant');
      expect(entity.isAwaitingRestaurantConfirmation, isTrue);
      expect(entity.isEditable, isFalse);
    });

    test('returns failure when repository fails', () async {
      repo.failure = Failure(
        errorMessage: 'selection locked',
        code: 'calendar.selection_locked',
      );

      final result = await useCase(
        subscriptionId: 'sub-123',
        date: '2026-09-25',
        localeName: 'ar',
      );

      expect(repo.confirmCalls, 1);
      expect(result, isA<ApiErrorResult<CalendarDayEntity>>());
      final err = (result as ApiErrorResult<CalendarDayEntity>).failure;
      expect(err.code, 'calendar.selection_locked');
    });
  });

  group('CalendarDayEntity status checks', () {
    test('isEditable is false when status is SentToRestaurant or canEdit is false', () {
      final day = CalendarDayEntity(
        status: 'SentToRestaurant',
        uiStatus: 'awaiting_restaurant',
        canEdit: false,
        date: DateTime(2026, 9, 25),
        dayNumber: 25,
        weekday: 'الأحد',
      );

      expect(day.isEditable, isFalse);
      expect(day.isRestaurantClosed, isTrue);
      expect(day.isAwaitingRestaurantConfirmation, isTrue);
    });
  });
}
