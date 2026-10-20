import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_meal_selection_bottom_bar.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_meal_selection_card.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_meal_selection_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/widgets/family_meal_selection_macros_card.dart';

void main() {
  Widget buildTestable(Widget child) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  testWidgets('FamilyMealSelectionLoadingSkeleton renders correctly', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestable(const FamilyMealSelectionLoadingSkeleton()),
    );

    expect(
      find.byKey(const ValueKey('family-meal-selection-loading-skeleton')),
      findsOneWidget,
    );
  });

  testWidgets(
    'FamilyMealSelectionCard renders unselected and selected states',
    (tester) async {
      const mealUnselected = CalendarMealEntity(
        id: 'meal_1',
        title: 'دجاج مشوي بالأعشاب',
        description: 'دجاج مشوي متبل بالأعشاب مع أرز بني وخضار مشكلة',
        calories: '480',
        carbs: '48',
        protein: '42',
        fat: '12',
        mealType: 'غداء',
        time: '12:00',
        actionLabel: 'اختيار',
        imageAsset: '',
        ingredients: [],
        allergens: [
          CalendarMealAllergenEntity(
            code: 'gluten_free',
            label: 'خالي من الجلوتين',
          ),
        ],
        selected: false,
      );

      bool tapped = false;
      await tester.pumpWidget(
        buildTestable(
          FamilyMealSelectionCard(
            meal: mealUnselected,
            onSelect: () => tapped = true,
          ),
        ),
      );

      expect(find.text('دجاج مشوي بالأعشاب'), findsOneWidget);
      expect(find.text('خالي من الجلوتين'), findsOneWidget);
      expect(find.text('اختيار الوجبة'), findsOneWidget);

      await tester.tap(find.text('اختيار الوجبة'));
      expect(tapped, isTrue);

      final mealSelected = mealUnselected.copyWith(selected: true);
      await tester.pumpWidget(
        buildTestable(
          FamilyMealSelectionCard(meal: mealSelected, onSelect: () {}),
        ),
      );

      expect(find.text('تم الاختيار'), findsOneWidget);
    },
  );

  testWidgets('FamilyMealSelectionMacrosCard renders macros correctly', (
    tester,
  ) async {
    const macros = CalendarNutritionTotalsEntity(
      calories: 1440,
      carbsG: 142,
      proteinG: 120,
      fatG: 36,
    );

    await tester.pumpWidget(
      buildTestable(const FamilyMealSelectionMacrosCard(macros: macros)),
    );

    expect(find.text('ملخص الماكروز'), findsOneWidget);
    expect(find.text('من وجبات مختارة'), findsOneWidget);
    expect(find.text('1440 سعرة'), findsOneWidget);
    expect(find.text('120 جم'), findsOneWidget);
    expect(find.text('142 جم'), findsOneWidget);
    expect(find.text('36 جم'), findsOneWidget);
  });

  testWidgets(
    'FamilyMealSelectionBottomBar renders counters and continue button',
    (tester) async {
      bool continued = false;
      await tester.pumpWidget(
        buildTestable(
          FamilyMealSelectionBottomBar(
            selectedCount: 3,
            totalCount: 4,
            slotAndDateLabel: 'الغداء • الأثنين 26 مايو',
            onContinue: () => continued = true,
          ),
        ),
      );

      expect(find.text('تم اختيار 3 من 4 وجبات'), findsOneWidget);
      expect(find.text('الغداء'), findsOneWidget);
      expect(find.text('الأثنين 26 مايو'), findsOneWidget);
      expect(find.text('متابعة المراجعة'), findsOneWidget);

      await tester.tap(find.text('متابعة المراجعة'));
      expect(continued, isTrue);
    },
  );
}
