import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_save_button.dart';

class _FakeMealSelectionCubit extends Cubit<MealSelectionState>
    implements MealSelectionViewModel {
  _FakeMealSelectionCubit([super.state = const MealSelectionState()]);

  void emitState(MealSelectionState newState) {
    emit(newState);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget buildTestWidget({
    bool? isLoading,
    bool? enabled,
    VoidCallback? onPressed,
    MealSelectionViewModel? cubit,
  }) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: cubit != null
            ? BlocProvider<MealSelectionViewModel>.value(
                value: cubit,
                child: CalendarMealSaveButton(
                  isLoading: isLoading,
                  enabled: enabled,
                  onPressed: onPressed,
                ),
              )
            : CalendarMealSaveButton(
                isLoading: isLoading,
                enabled: enabled,
                onPressed: onPressed,
              ),
      ),
    );
  }

  group('CalendarMealSaveButton declarative interface', () {
    testWidgets(
      'renders enabled and idle when enabled=true and isLoading=false',
      (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          buildTestWidget(
            isLoading: false,
            enabled: true,
            onPressed: () => pressed = true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Confirm Meals'), findsOneWidget);

        await tester.tap(find.byType(CalendarMealSaveButton));
        expect(pressed, isTrue);
      },
    );

    testWidgets('renders disabled when enabled=false', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        buildTestWidget(
          isLoading: false,
          enabled: false,
          onPressed: () => pressed = true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byType(CalendarMealSaveButton));
      expect(pressed, isFalse);
    });

    testWidgets(
      'renders progress indicator when isLoading=true (saving/confirming)',
      (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          buildTestWidget(
            isLoading: true,
            enabled: true,
            onPressed: () => pressed = true,
          ),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.tap(
          find.byType(CalendarMealSaveButton),
          warnIfMissed: false,
        );
        expect(pressed, isFalse);
      },
    );
  });

  group('CalendarMealSaveButton BlocSelector integration', () {
    testWidgets('observes MealSelectionCubit loading and enabled state', (
      tester,
    ) async {
      final cubit = _FakeMealSelectionCubit(
        const MealSelectionState(isSaving: false, isConfirming: false),
      );

      await tester.pumpWidget(buildTestWidget(cubit: cubit));
      await tester.pumpAndSettle();

      // Initially canSaveMeals is false when required slots are not satisfied
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // When saving: loading indicator appears
      cubit.emitState(const MealSelectionState(isSaving: true));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // When confirming: loading indicator appears
      cubit.emitState(const MealSelectionState(isConfirming: true));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // When failure returns to idle
      cubit.emitState(
        const MealSelectionState(isSaving: false, isConfirming: false),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
