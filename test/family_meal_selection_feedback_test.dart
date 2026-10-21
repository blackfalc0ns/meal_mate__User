import 'support/family_meal_selection_view_model_factory.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/confirm_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_event.dart';
import 'support/family_calendar_view_model_factory.dart';

class _PendingConfirm implements ConfirmCalendarDayMealsUseCase {
  final result = Completer<ApiResult<CalendarDayEntity>>();
  int calls = 0;
  @override
  Future<ApiResult<CalendarDayEntity>> call({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    calls++;
    return result.future;
  }
}

class _PendingSave implements SaveCalendarDayMealsUseCase {
  final result = Completer<ApiResult<CalendarDayEntity>>();
  @override
  Future<ApiResult<CalendarDayEntity>> call({
    required String subscriptionId,
    required String date,
    required String localeName,
    required List<CalendarMealEntity> meals,
  }) => result.future;
}

class _PendingAuto implements AutoSelectCalendarDayUseCase {
  final result = Completer<ApiResult<CalendarDayEntity>>();
  @override
  Future<ApiResult<CalendarDayEntity>> call({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) => result.future;
}

void main() {
  for (final operation in ['save', 'confirm', 'auto']) {
    test(
      '$operation clears previous success and reports backend failure',
      () async {
        final calendar = createFamilyCalendarViewModel();
        addTearDown(calendar.close);
        final save = _PendingSave();
        final confirm = _PendingConfirm();
        final auto = _PendingAuto();
        final vm = createFamilyMealSelectionViewModel(
          calendar: calendar,
          subscriptionId: 'sub',
          date: DateTime(2026, 10, 15),
          saveDayMealsUseCase: save,
          confirmDayMealsUseCase: confirm,
          autoSelectDayUseCase: auto,
        );
        addTearDown(vm.close);
        vm.emit(vm.state.copyWith(saveMealsSuccess: true));
        vm.doIntent(switch (operation) {
          'save' => const SaveFamilyDayMealsEvent(localeName: 'en'),
          'confirm' => const ConfirmFamilyDayMealsEvent(localeName: 'en'),
          _ => const AutoSelectFamilyDayMealsEvent(localeName: 'en'),
        });
        expect(vm.state.saveMealsSuccess, isFalse);
        expect(vm.state.isSavingMeals, isTrue);
        if (operation == 'confirm') {
          vm.doIntent(const ConfirmFamilyDayMealsEvent(localeName: 'en'));
          expect(confirm.calls, 1);
        }
        final result = switch (operation) {
          'save' => save.result,
          'confirm' => confirm.result,
          _ => auto.result,
        };
        result.complete(
          ApiErrorResult(failure: Failure(errorMessage: 'Rejected')),
        );
        await pumpEventQueue();
        expect(vm.state.saveMealsSuccess, isFalse);
        expect(vm.state.saveMealsFailure, isNotNull);
        expect(vm.state.isSavingMeals, isFalse);
      },
    );
  }
}
