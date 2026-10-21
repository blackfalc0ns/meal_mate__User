import 'support/family_meal_selection_view_model_factory.dart';
import 'dart:async';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_state.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_context/domain/usecase/get_my_family_contexts_usecase.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_state.dart';
import 'support/family_calendar_view_model_factory.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

class _UnusedContextsUseCase implements GetMyFamilyContextsUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PendingContextsUseCase implements GetMyFamilyContextsUseCase {
  final result = Completer<ApiResult<List<FamilyContextEntity>>>();
  @override
  Future<ApiResult<List<FamilyContextEntity>>> call() => result.future;
}

void main() {
  test('clearing login context rejects an earlier session response', () async {
    final useCase = _PendingContextsUseCase();
    final context = FamilyContextViewModel(useCase);
    addTearDown(context.close);
    context.loadFamilyContext();
    context.doIntent(const ClearFamilyContextsEvent());
    useCase.result.complete(
      const ApiSuccessResult(
        data: [
          FamilyContextEntity(groupId: 'previous-account', isManager: true),
        ],
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(context.state.contexts, isEmpty);
    expect(context.state.isLoading, isFalse);
  });

  test(
    'calendar and meals use login permissions and react to context changes',
    () async {
      final context = FamilyContextViewModel(_UnusedContextsUseCase());
      getIt.registerSingleton<FamilyContextViewModel>(context);
      addTearDown(() async {
        await getIt.unregister<FamilyContextViewModel>();
        await context.close();
      });
      context.emit(
        const FamilyContextState(
          contexts: [
            FamilyContextEntity(
              groupId: 'family',
              isManager: true,
              capabilities: [
                FamilyCapabilityEntity(action: 'editDailyMeals', allowed: true),
              ],
            ),
          ],
        ),
      );
      final calendar = createFamilyCalendarViewModel(
        membersData: const [
          FamilyMemberSummaryEntity(
            memberId: 'one',
            displayName: 'One',
            role: 2,
            ageYears: 20,
            isPaused: false,
            subscriptionId: 'sub-one',
            programName: '',
            remainingDays: 1,
            setupStatus: 2,
          ),
          FamilyMemberSummaryEntity(
            memberId: 'two',
            displayName: 'Two',
            role: 2,
            ageYears: 20,
            isPaused: false,
            subscriptionId: 'sub-two',
            programName: '',
            remainingDays: 1,
            setupStatus: 2,
          ),
        ],
      );
      addTearDown(calendar.close);
      await calendar.doIntent(const InitFamilyCalendarEvent(localeName: 'en'));
      expect(calendar.state.canSelectRestaurant, isTrue);
      expect(
        FamilyMealSelectionState.fromCalendar(calendar.state).canConfirmMeals,
        isTrue,
      );
      await calendar.doIntent(
        const SelectFamilyMemberEvent(index: 1, localeName: 'en'),
      );
      expect(calendar.state.canSelectRestaurant, isTrue);
      final meals = createFamilyMealSelectionViewModel(calendar: calendar);
      addTearDown(meals.close);
      expect(meals.state.canConfirmMeals, isTrue);
      context.emit(const FamilyContextState());
      await Future<void>.delayed(Duration.zero);
      expect(calendar.state.canSelectRestaurant, isFalse);
      expect(meals.state.canConfirmMeals, isFalse);
      expect(
        FamilyMealSelectionState.fromCalendar(calendar.state).canConfirmMeals,
        isFalse,
      );
    },
  );
}
