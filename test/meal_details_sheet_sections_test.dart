import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/screens/meal_details_screen.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_content.dart';
import 'package:meal_meat_user/features/meal_details/presentation/widgets/meal_details_header_image.dart';

void main() {
  for (final language in ['en', 'ar']) {
    testWidgets('meal details header scrolls with content in $language', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: Locale(language),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MealDetailsScreen(meal: _meal()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      final header = find.byType(MealDetailsHeaderImage);
      final before = tester.getTopLeft(header).dy;
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -250));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.getTopLeft(header).dy, lessThan(before));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('meal details shows allergens without selection controls', (
    tester,
  ) async {
    await _pumpMealDetails(tester, _meal());

    expect(find.text('Lactose'), findsOneWidget);
    expect(find.text('Nuts'), findsOneWidget);
    expect(find.text('Optional notes'), findsNothing);
    expect(find.text('Select this meal'), findsNothing);
  });

  testWidgets(
    'meal details shows selection controls when selection is allowed',
    (tester) async {
      var selected = false;

      await _pumpMealDetails(
        tester,
        _meal(
          onSelectMeal: () {
            selected = true;
          },
        ),
      );

      expect(find.text('Optional notes'), findsOneWidget);
      expect(find.text('Select this meal'), findsOneWidget);

      await tester.ensureVisible(find.text('Select this meal'));
      await tester.tap(find.text('Select this meal'));
      await tester.pump();

      expect(selected, isTrue);
    },
  );
}

Future<void> _pumpMealDetails(WidgetTester tester, MealDetailsEntity meal) {
  tester.view.physicalSize = const Size(800, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(child: MealDetailsContent(meal: meal)),
      ),
    ),
  );
}

MealDetailsEntity _meal({void Function()? onSelectMeal}) {
  return MealDetailsEntity(
    title: 'Keto cheese',
    description: 'Cheddar, cucumber, and greens.',
    restaurantName: 'Green Bowl',
    restaurantLogo: 'GB',
    ratingTitle: 'Restaurant rating',
    ratingValue: '',
    programLabel: 'Meal type',
    programValue: 'Snack',
    deliveryLabel: 'Delivery time',
    deliveryValue: '',
    ingredientsTitle: 'Ingredients',
    ingredients: const [],
    nutritionTitle: 'Nutrition facts',
    nutritionItems: const [
      MealDetailsNutritionEntity(
        value: '210',
        label: 'Calories',
        type: MealDetailsNutritionType.calories,
      ),
    ],
    macroDistributionTitle: 'Macro distribution',
    macroItems: const [],
    allergensTitle: 'Allergens',
    allergens: const [
      MealDetailsAllergenEntity(
        label: 'Lactose',
        type: MealDetailsAllergenType.lactose,
      ),
      MealDetailsAllergenEntity(
        label: 'Nuts',
        type: MealDetailsAllergenType.nuts,
      ),
    ],
    onSelectMeal: onSelectMeal,
  );
}
