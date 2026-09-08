import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergy_choice_tile.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergy_selection_section.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_catalog_entity.dart';

void main() {
  testWidgets('shows six choices initially and expands to show all choices', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(items: _items(8)));

    expect(find.byType(FamilyAllergyChoiceTile), findsNWidgets(6));
    expect(find.text('Show more'), findsOneWidget);

    await tester.tap(find.text('Show more'));
    await tester.pumpAndSettle();

    expect(find.byType(FamilyAllergyChoiceTile), findsNWidgets(8));
    expect(find.text('Show less'), findsOneWidget);
  });

  testWidgets('does not show an expansion control for six choices', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(items: _items(6)));

    expect(find.byType(FamilyAllergyChoiceTile), findsNWidgets(6));
    expect(find.text('Show more'), findsNothing);
    expect(find.text('Show less'), findsNothing);
  });
}

Widget _testApp({required List<FoodPreferenceCatalogItemEntity> items}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(
        child: FamilyAllergySelectionSection(
          title: 'Allergies',
          searchHint: 'Search',
          items: items,
          selected: const {},
          onSearch: (_) {},
          onToggle: (_) {},
        ),
      ),
    ),
  );
}

List<FoodPreferenceCatalogItemEntity> _items(int count) {
  return List.generate(
    count,
    (index) => FoodPreferenceCatalogItemEntity(
      code: 'item-$index',
      nameAr: 'عنصر $index',
      nameEn: 'Item $index',
    ),
  );
}
