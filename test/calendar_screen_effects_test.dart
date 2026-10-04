import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_effect.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_navigation_coordinator.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_screen_effects.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class _FakeNavigationCoordinator implements CalendarNavigationCoordinator {
  int openRestaurantPickerCalls = 0;
  int openMealPickerCalls = 0;
  int closeMealPickerCalls = 0;
  int showMealsConfirmationSheetCalls = 0;
  final List<String> successSnackBars = [];
  final List<String> errorSnackBars = [];

  @override
  bool get isRestaurantSheetOpen => false;

  @override
  bool get isMealPickerOpen => false;

  @override
  Future<void> openRestaurantPicker(
    BuildContext context, {
    DateTime? date,
    String? subscriptionId,
  }) async {
    openRestaurantPickerCalls++;
  }

  @override
  Future<void> openMealPicker(
    BuildContext context, {
    CalendarRestaurantOptionEntity? initialRestaurant,
    RoundedLoadingButtonController? saveButtonController,
  }) async {
    openMealPickerCalls++;
  }

  @override
  void closeMealPicker(BuildContext context) {
    closeMealPickerCalls++;
  }

  @override
  Future<void> showMealsConfirmationSheet(BuildContext context) async {
    showMealsConfirmationSheetCalls++;
  }

  @override
  void showSuccessSnackBar(BuildContext context, String message) {
    successSnackBars.add(message);
  }

  @override
  void showErrorSnackBar(BuildContext context, String message) {
    errorSnackBars.add(message);
  }

  @override
  void openMealDetails(
    BuildContext context,
    dynamic meal,
    dynamic restaurant,
  ) {}
}

class _TestFlowCubit extends Cubit<CalendarFlowState>
    implements CalendarFlowCubit {
  _TestFlowCubit() : super(const CalendarFlowState());

  void emitEffect(CalendarFlowEffect effect) {
    emit(CalendarFlowState(effect: effect));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget buildTestWidget({
    required _TestFlowCubit flowCubit,
    required _FakeNavigationCoordinator coordinator,
  }) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<CalendarFlowCubit>.value(
        value: flowCubit as dynamic,
        child: CalendarScreenEffects(
          coordinator: coordinator,
          child: const Scaffold(body: Text('Content')),
        ),
      ),
    );
  }

  testWidgets('handles OpenRestaurantPickerEffect exactly once', (
    tester,
  ) async {
    final flowCubit = _TestFlowCubit();
    final coordinator = _FakeNavigationCoordinator();

    await tester.pumpWidget(
      buildTestWidget(flowCubit: flowCubit, coordinator: coordinator),
    );
    await tester.pumpAndSettle();

    expect(coordinator.openRestaurantPickerCalls, 0);

    flowCubit.emitEffect(
      OpenRestaurantPickerEffect(
        id: 1,
        date: DateTime(2026, 10, 5),
        subscriptionId: 'sub-1',
      ),
    );
    await tester.pump();

    expect(coordinator.openRestaurantPickerCalls, 1);

    // Re-emitting state without change or same ID should not trigger again
    flowCubit.emit(flowCubit.state);
    await tester.pump();
    expect(coordinator.openRestaurantPickerCalls, 1);
  });

  testWidgets('handles OpenMealPickerEffect exactly once', (tester) async {
    final flowCubit = _TestFlowCubit();
    final coordinator = _FakeNavigationCoordinator();

    await tester.pumpWidget(
      buildTestWidget(flowCubit: flowCubit, coordinator: coordinator),
    );
    await tester.pumpAndSettle();

    flowCubit.emitEffect(
      OpenMealPickerEffect(
        id: 2,
        date: DateTime(2026, 10, 5),
        subscriptionId: 'sub-1',
        restaurantId: 'rest-1',
      ),
    );
    await tester.pump();

    expect(coordinator.openMealPickerCalls, 1);
  });

  testWidgets('handles CloseMealPickerEffect', (tester) async {
    final flowCubit = _TestFlowCubit();
    final coordinator = _FakeNavigationCoordinator();

    await tester.pumpWidget(
      buildTestWidget(flowCubit: flowCubit, coordinator: coordinator),
    );
    await tester.pumpAndSettle();

    flowCubit.emitEffect(const CloseMealPickerEffect(id: 3));
    await tester.pump();

    expect(coordinator.closeMealPickerCalls, 1);
  });

  testWidgets(
    'handles MealsSavedEffect with success snackbar and closing picker',
    (tester) async {
      final flowCubit = _TestFlowCubit();
      final coordinator = _FakeNavigationCoordinator();

      await tester.pumpWidget(
        buildTestWidget(flowCubit: flowCubit, coordinator: coordinator),
      );
      await tester.pumpAndSettle();

      const day = CalendarDayEntity(
        dayNumber: 5,
        weekday: 'Mon',
        canEdit: true,
      );
      flowCubit.emitEffect(const MealsSavedEffect(id: 4, day: day));
      await tester.pump();

      expect(coordinator.closeMealPickerCalls, 1);
      expect(coordinator.successSnackBars.length, 1);
    },
  );

  testWidgets(
    'handles MealsConfirmedEffect with snackbar, close, and confirmation sheet',
    (tester) async {
      final flowCubit = _TestFlowCubit();
      final coordinator = _FakeNavigationCoordinator();

      await tester.pumpWidget(
        buildTestWidget(flowCubit: flowCubit, coordinator: coordinator),
      );
      await tester.pumpAndSettle();

      const day = CalendarDayEntity(
        dayNumber: 5,
        weekday: 'Mon',
        canEdit: false,
      );
      flowCubit.emitEffect(const MealsConfirmedEffect(id: 5, day: day));
      await tester.pump();

      expect(coordinator.closeMealPickerCalls, 1);
      expect(coordinator.successSnackBars.length, 1);
      expect(coordinator.showMealsConfirmationSheetCalls, 1);
    },
  );

  testWidgets('handles CalendarFailureEffect with localized message', (
    tester,
  ) async {
    final flowCubit = _TestFlowCubit();
    final coordinator = _FakeNavigationCoordinator();

    await tester.pumpWidget(
      buildTestWidget(flowCubit: flowCubit, coordinator: coordinator),
    );
    await tester.pumpAndSettle();

    final failure = Failure(
      errorMessage: 'Something went wrong',
      code: 'calendar.selection_locked',
    );
    flowCubit.emitEffect(CalendarFailureEffect(id: 6, failure: failure));
    await tester.pump();

    expect(coordinator.errorSnackBars.length, 1);
  });
}
