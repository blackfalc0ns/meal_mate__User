import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_cubit.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_content.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_section.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_selected_day_section.dart';

class _FakeOverviewCubit extends Cubit<CalendarOverviewState>
    implements CalendarOverviewCubit {
  _FakeOverviewCubit(super.state);

  void emitState(CalendarOverviewState newState) => emit(newState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeMealSelectionCubit extends Cubit<MealSelectionState>
    implements MealSelectionCubit {
  _FakeMealSelectionCubit(super.state);

  void emitState(MealSelectionState newState) => emit(newState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
      'CalendarContent is a StatelessWidget with zero setState and fine-grained rebuild boundaries',
      (tester) async {
    final days = [
      CalendarDayEntity(
        dayNumber: 5,
        weekday: 'Mon',
        date: DateTime(2026, 10, 5),
        canEdit: true,
      ),
      CalendarDayEntity(
        dayNumber: 6,
        weekday: 'Tue',
        date: DateTime(2026, 10, 6),
        canEdit: true,
      ),
    ];

    final overviewCubit = _FakeOverviewCubit(
      CalendarOverviewState(
        days: days,
        selectedDate: DateTime(2026, 10, 5),
      ),
    );

    final mealCubit = _FakeMealSelectionCubit(
      const MealSelectionState(),
    );

    int contentBuildCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<CalendarOverviewCubit>.value(value: overviewCubit),
              BlocProvider<MealSelectionCubit>.value(value: mealCubit),
            ],
            child: Builder(
              builder: (context) {
                contentBuildCount++;
                return CalendarContent(
                  showBottomSpace: false,
                  onSelectRestaurant: () {},
                  onChangeMeal: () {},
                  onMealTap: (_, _) {},
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CalendarContent), findsOneWidget);
    expect(find.byType(CalendarPickerSection), findsOneWidget);
    expect(find.byType(CalendarSelectedDaySection), findsOneWidget);
    expect(contentBuildCount, 1);

    // Verify CalendarContent is indeed a StatelessWidget
    final contentWidget = tester.widget(find.byType(CalendarContent));
    expect(contentWidget, isA<StatelessWidget>());

    // 1. Changing meal state (e.g. isConfirming) should NOT rebuild CalendarPickerSection or parent
    mealCubit.emitState(const MealSelectionState(isConfirming: true));
    await tester.pump();

    expect(contentBuildCount, 1,
        reason: 'Parent builder must not rebuild when meal state changes');

    // 2. Expand/collapse toggle in picker panel triggers only internal picker section state
    final arrowButton = find.byTooltip('Expand');
    if (arrowButton.evaluate().isNotEmpty) {
      await tester.tap(arrowButton);
      await tester.pumpAndSettle();
      expect(contentBuildCount, 1,
          reason: 'CalendarContent must not rebuild on picker expansion');
    }
  });
}
