import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_operational_clock.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_deadline_builder.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_action_section.dart';
import 'support/family_calendar_view_model_factory.dart';

void main() {
  setUpAll(() async {
    final font = FontLoader('Alexandria')
      ..addFont(rootBundle.load('assets/fonts/Alexandria-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Alexandria-Bold.ttf'));
    await font.load();
  });
  testWidgets('deadline updates only its scoped action while open', (
    tester,
  ) async {
    final serverNow = DateTime.utc(2000);
    final day = CalendarDayEntity(
      dayNumber: 1,
      weekday: '',
      canSelectMeal: true,
      operationalClock: CalendarOperationalClock(serverNow),
      mealSelectionClosesAt: serverNow.add(const Duration(milliseconds: 1500)),
    );
    var parentBuilds = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            parentBuilds++;
            return CalendarDeadlineBuilder(
              day: day,
              builder: (context) => TextButton(
                onPressed: day.isEditable ? () {} : null,
                child: const Text('Action'),
              ),
            );
          },
        ),
      ),
    );
    expect(
      tester.widget<TextButton>(find.byType(TextButton)).onPressed,
      isNotNull,
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 1600)),
    );
    await tester.pump(const Duration(milliseconds: 1600));
    expect(
      tester.widget<TextButton>(find.byType(TextButton)).onPressed,
      isNull,
    );
    expect(parentBuilds, 1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('existing family meals remain viewable when editing is closed', (
    tester,
  ) async {
    final model = createFamilyCalendarViewModel();
    model.emit(
      const FamilyCalendarState(
        selectedDay: CalendarDayEntity(
          dayNumber: 1,
          weekday: '',
          canSelectMeal: false,
        ),
        currentUserCapabilities: [
          FamilyCapabilityEntity(action: 'viewCalendar', allowed: true),
        ],
      ),
    );
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider<FamilyCalendarViewModel>.value(
            value: model,
            child: FamilyMemberCalendarActionSection(
              hasMeals: true,
              onChooseMeals: () => fail('editing must remain closed'),
              onShowDetails: () => opened = true,
            ),
          ),
        ),
      ),
    );
    final button = find.byType(ElevatedButton);
    expect(tester.widget<ElevatedButton>(button).onPressed, isNotNull);
    await tester.tap(button);
    expect(opened, isTrue);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.runAsync(model.close);
  });
}
