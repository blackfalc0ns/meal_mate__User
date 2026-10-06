import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_day_content.dart';

Widget _buildTestApp({
  required CalendarDayEntity day,
  Locale locale = const Locale('ar'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: CalendarDayContent(
        selectedDay: day,
        showBottomSpace: false,
        onSelectRestaurant: () {},
        onChangeMeal: () {},
        onMealTap: (_, _) {},
      ),
    ),
  );
}

const _testMeal = CalendarMealEntity(
  id: 'm-1',
  title: 'وجبة دجاج مشوي',
  imageUrl: '',
  time: '1:00 م',
  calories: '450',
  protein: '35',
  carbs: '40',
  fat: '12',
  mealType: 'غداء',
  slot: 'lunch',
  ingredients: [],
  imageAsset: '',
  actionLabel: '',
  selected: true,
);

const _testRestaurant = CalendarRestaurantEntity(
  id: 'r-1',
  name: 'مطبخ دايت كير',
  category: 'وجبات صحية',
  deliveryDuration: 'أساسي',
  deliveryWindow: '12:00 م - 1:00 م',
  rating: '4.8',
  ratingCount: 15,
);

void main() {
  group('CalendarDayContent status presentation', () {
    testWidgets(
      'renders awaiting restaurant confirmation header with hourglass when status is SentToRestaurant',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.reset);

        final day = CalendarDayEntity(
          id: 'day-1',
          dayNumber: 6,
          weekday: 'الثلاثاء',
          date: DateTime(2026, 10, 6),
          status: 'SentToRestaurant',
          uiStatus: 'awaiting_restaurant',
          restaurant: _testRestaurant,
          meals: const [_testMeal],
          selectedMealIds: const ['m-1'],
        );

        await tester.pumpWidget(_buildTestApp(day: day));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('في انتظار تأكيد المطعم'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('awaiting_hourglass_lottie')),
          findsOneWidget,
        );
        expect(find.text('مؤكد'), findsNothing);
        expect(find.text('تأكيد اختيار الوجبات'), findsNothing);
      },
    );

    testWidgets(
      'renders confirmed header with checkmark when status is ConfirmedByRestaurant',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.reset);

        final day = CalendarDayEntity(
          id: 'day-2',
          dayNumber: 6,
          weekday: 'الثلاثاء',
          date: DateTime(2026, 10, 6),
          status: 'ConfirmedByRestaurant',
          uiStatus: 'locked',
          restaurant: _testRestaurant,
          meals: const [_testMeal],
          selectedMealIds: const ['m-1'],
        );

        await tester.pumpWidget(_buildTestApp(day: day));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('تأكيد اختيار الوجبات'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
        expect(
          find.byKey(const ValueKey('awaiting_hourglass_lottie')),
          findsNothing,
        );
        expect(find.text('في انتظار تأكيد المطعم'), findsNothing);
      },
    );

    testWidgets(
      'renders confirm selection header when meals exist but not sent or confirmed',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.reset);

        final day = CalendarDayEntity(
          id: 'day-3',
          dayNumber: 7,
          weekday: 'الأربعاء',
          date: DateTime(2026, 10, 7),
          status: 'Draft',
          canEdit: true,
          restaurant: _testRestaurant,
          meals: const [_testMeal],
          selectedMealIds: const ['m-1'],
        );

        await tester.pumpWidget(_buildTestApp(day: day));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('تأكيد اختيار الوجبات'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
        expect(
          find.byKey(const ValueKey('awaiting_hourglass_lottie')),
          findsNothing,
        );
        expect(find.text('في انتظار تأكيد المطعم'), findsNothing);
        expect(find.text('مؤكد'), findsNothing);
      },
    );

    testWidgets(
      'renders English localized strings in en locale',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.reset);

        final day = CalendarDayEntity(
          id: 'day-4',
          dayNumber: 6,
          weekday: 'Tuesday',
          date: DateTime(2026, 10, 6),
          status: 'ConfirmedByRestaurant',
          uiStatus: 'locked',
          restaurant: _testRestaurant,
          meals: const [_testMeal],
          selectedMealIds: const ['m-1'],
        );

        await tester.pumpWidget(
          _buildTestApp(day: day, locale: const Locale('en')),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Confirm Meal Selection'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
        expect(
          find.byKey(const ValueKey('awaiting_hourglass_lottie')),
          findsNothing,
        );
      },
    );
  });
}
