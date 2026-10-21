import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_picker_section.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_member_selector_section.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/screens/family_day_meals_screen.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/screens/family_member_calendar_screen.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_header.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_member_card.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_member_selector.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_selected_meals_card.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_calendar_primary_action.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_day_review_button.dart';
import 'support/family_calendar_view_model_factory.dart';

Widget _app(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
  theme: AppTheme.lightTheme,
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

void main() {
  final builds = <Type, int>{};
  setUp(() {
    debugOnRebuildDirtyWidget = (element, builtOnce) {
      builds.update(
        element.widget.runtimeType,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    };
  });
  tearDown(() {
    debugOnRebuildDirtyWidget = null;
    builds.clear();
  });

  testWidgets('cached member labels refresh when the locale changes', (
    tester,
  ) async {
    final vm = createFamilyCalendarViewModel();
    addTearDown(vm.close);
    vm.emit(
      vm.state.copyWith(
        members: const [
          FamilyMemberSummaryEntity(
            memberId: 'one',
            displayName: 'One',
            role: 2,
            ageYears: 8,
            isPaused: false,
            subscriptionId: 'sub',
            programName: '',
            remainingDays: 1,
            setupStatus: 2,
          ),
        ],
      ),
    );
    final child = BlocProvider<FamilyCalendarViewModel>.value(
      value: vm,
      child: Scaffold(
        body: FamilyMemberCalendarMemberSelectorSection(
          onMemberSelected: (_) {},
        ),
      ),
    );
    await tester.pumpWidget(_app(child));
    await tester.pumpAndSettle();
    final english = tester
        .widget<FamilyDayMemberSelector>(find.byType(FamilyDayMemberSelector))
        .members
        .single
        .ageLabel;
    await tester.pumpWidget(_app(child, locale: const Locale('ar')));
    await tester.pumpAndSettle();
    final arabic = tester
        .widget<FamilyDayMemberSelector>(find.byType(FamilyDayMemberSelector))
        .members
        .single
        .ageLabel;
    expect(arabic, isNot(english));
    expect(arabic, isNotEmpty);
  });

  testWidgets(
    'picker cache refreshes on selected date and service day changes',
    (tester) async {
      final vm = createFamilyCalendarViewModel();
      addTearDown(vm.close);
      final first = DateTime(2026, 10, 15);
      final second = DateTime(2026, 10, 16);
      final days = [
        CalendarDayEntity(dayNumber: 15, weekday: 'Thu', date: first),
        CalendarDayEntity(dayNumber: 16, weekday: 'Fri', date: second),
      ];
      vm.emit(vm.state.copyWith(days: days, selectedDate: first));
      await tester.pumpWidget(
        _app(
          BlocProvider<FamilyCalendarViewModel>.value(
            value: vm,
            child: Scaffold(
              body: SingleChildScrollView(
                child: FamilyMemberCalendarPickerSection(
                  fallbackDate: first,
                  onMonthChanged: (_) {},
                  onDaySelected: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      CalendarPickerPanel panel() =>
          tester.widget<CalendarPickerPanel>(find.byType(CalendarPickerPanel));
      expect(panel().days.singleWhere((day) => day.isSelected).date, first);
      vm.emit(vm.state.copyWith(selectedDate: second));
      await tester.pumpAndSettle();
      expect(panel().days.singleWhere((day) => day.isSelected).date, second);
      vm.emit(vm.state.copyWith(days: [days.last]));
      await tester.pumpAndSettle();
      expect(panel().days.length, 1);
      expect(panel().days.single.date, second);
      panel().onToggleExpanded();
      await tester.pumpAndSettle();
      expect(panel().isExpanded, isTrue);
      expect(panel().days.length, greaterThan(1));
      expect(panel().days.singleWhere((day) => day.isSelected).date, second);
    },
  );

  testWidgets(
    'changing date leaves member widgets mounted without rebuilding',
    (tester) async {
      final vm = createFamilyCalendarViewModel();
      addTearDown(vm.close);
      await tester.pumpWidget(_app(FamilyDayMealsScreen(viewModel: vm)));
      await tester.pumpAndSettle();
      vm.emit(
        vm.state.copyWith(
          currentMemberName: 'Member',
          selectedDate: DateTime(2026, 10, 15),
        ),
      );
      await tester.pumpAndSettle();
      builds.clear();
      vm.emit(vm.state.copyWith(selectedDate: DateTime(2026, 10, 16)));
      await tester.pumpAndSettle();
      expect(builds[FamilyDayHeader], greaterThan(0));
      expect(builds[FamilyDayMemberSelector] ?? 0, 0);
      expect(builds[FamilyDayMemberCard] ?? 0, 0);
    },
  );

  testWidgets(
    'permission changes rebuild action without rebuilding meal cards',
    (tester) async {
      final vm = createFamilyCalendarViewModel();
      addTearDown(vm.close);
      await tester.pumpWidget(_app(FamilyMemberCalendarScreen(viewModel: vm)));
      await tester.pumpAndSettle();
      final date = DateTime(2026, 10, 15);
      final day = CalendarDayEntity(
        dayNumber: 15,
        weekday: 'Thu',
        date: date,
        canEdit: true,
        meals: const [
          CalendarMealEntity(
            id: 'meal',
            title: 'Lunch',
            mealType: 'Lunch',
            time: '',
            calories: '',
            protein: '',
            carbs: '',
            fat: '',
            ingredients: [],
            imageAsset: '',
            actionLabel: '',
          ),
        ],
      );
      vm.emit(
        vm.state.copyWith(
          currentSubscriptionId: 'sub',
          selectedDate: date,
          days: [day],
          selectedDay: day,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FamilyMemberSelectedMealsCard), findsOneWidget);
      builds.clear();
      vm.emit(
        vm.state.copyWith(
          currentUserCapabilities: const [
            FamilyCapabilityEntity(action: 'viewCalendar', allowed: true),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(builds[FamilyMemberCalendarPrimaryAction], greaterThan(0));
      expect(builds[FamilyMemberSelectedMealsCard] ?? 0, 0);
      vm.applyDaySnapshot(day.copyWith(meals: const []));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      final outgoingCards = tester.widgetList<FamilyMemberSelectedMealsCard>(
        find.byType(FamilyMemberSelectedMealsCard),
      );
      expect(outgoingCards, isNotEmpty);
      expect(outgoingCards.every((card) => card.meals.length == 1), isTrue);
      await tester.pumpAndSettle();
    },
  );

  testWidgets('review button ignores navigation-only member name changes', (
    tester,
  ) async {
    final vm = createFamilyCalendarViewModel();
    addTearDown(vm.close);
    await tester.pumpWidget(_app(FamilyDayMealsScreen(viewModel: vm)));
    await tester.pumpAndSettle();
    builds.clear();
    vm.emit(vm.state.copyWith(currentMemberName: 'Updated name'));
    await tester.pumpAndSettle();
    expect(builds[FamilyDayReviewButton] ?? 0, 0);
  });
}
