import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_picker_sheet.dart';

void main() {
  testWidgets('calendar source card fits its fixed height', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CalendarSourceCard(
              icon: Icons.eco_rounded,
              title: 'لحم ضاني',
              subtitle: 'مستوردة',
              country: 'مصر',
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('calendar source section shows more than four ingredients', (
    tester,
  ) async {
    const ingredients = [
      CalendarCoreIngredientEntity(
        id: '1',
        name: 'Ingredient 1',
        iconUrl: null,
        isLocal: true,
        originCountryCode: 'KW',
        originCountryName: 'Kuwait',
        flagEmoji: null,
      ),
      CalendarCoreIngredientEntity(
        id: '2',
        name: 'Ingredient 2',
        iconUrl: null,
        isLocal: true,
        originCountryCode: 'KW',
        originCountryName: 'Kuwait',
        flagEmoji: null,
      ),
      CalendarCoreIngredientEntity(
        id: '3',
        name: 'Ingredient 3',
        iconUrl: null,
        isLocal: true,
        originCountryCode: 'KW',
        originCountryName: 'Kuwait',
        flagEmoji: null,
      ),
      CalendarCoreIngredientEntity(
        id: '4',
        name: 'Ingredient 4',
        iconUrl: null,
        isLocal: true,
        originCountryCode: 'KW',
        originCountryName: 'Kuwait',
        flagEmoji: null,
      ),
      CalendarCoreIngredientEntity(
        id: '5',
        name: 'Ingredient 5',
        iconUrl: null,
        isLocal: true,
        originCountryCode: 'KW',
        originCountryName: 'Kuwait',
        flagEmoji: null,
      ),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CalendarSourceSection(coreIngredients: ingredients),
        ),
      ),
    );

    expect(find.text('Ingredient 5', skipOffstage: false), findsOneWidget);
  });

  testWidgets('meal ingredient chip uses API icon URL when available', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CalendarMealPickerIngredientChip(
            label: 'Broccoli',
            iconUrl:
                'https://ik.imagekit.io/f7h9cj23x/catalog/ingredient-photos/broccoli.webp',
          ),
        ),
      ),
    );

    final image = tester.widget<AppCachedNetworkImage>(
      find.byType(AppCachedNetworkImage),
    );

    expect(image.imageUrl, contains('broccoli.webp'));
    expect(find.byIcon(Icons.eco_rounded), findsNothing);
  });

  test('restaurant description stays below the header', () {
    final headerSource = File(
      'lib/features/calendar/presentation/widgets/'
      'calendar_meal_picker_restaurant_header.dart',
    ).readAsStringSync();
    final sheetSource = File(
      'lib/features/calendar/presentation/widgets/calendar_meal_picker_sheet.dart',
    ).readAsStringSync();

    expect(
      headerSource,
      isNot(contains('locale.calendar_restaurant_description')),
    );
    expect(
      sheetSource,
      contains('const CalendarMealPickerRestaurantDescription()'),
    );
  });
}
