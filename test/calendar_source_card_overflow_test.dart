import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations_en.dart';
import 'package:meal_meat_user/features/calendar/presentation/mapper/calendar_menu_mapper.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/widgets/restaurant_menu_view.dart';

void main() {
  testWidgets('calendar source card fits its fixed height', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: RestaurantMenuSourceCard(
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
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RestaurantMenuSourceSection(
            origins: ingredients
                .map(
                  (i) => RestaurantMenuOrigin(
                    title: i.name,
                    subtitle: 'Local',
                    country: i.originCountryName,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );

    expect(find.text('Ingredient 5', skipOffstage: false), findsOneWidget);
  });

  testWidgets('meal picker nutrition row fits option card content width', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SizedBox(
              width: 160,
              child: RestaurantMenuNutritionRow(
                option: RestaurantMenuOption(
                  id: 'meal-1',
                  slot: 'lunch',
                  title: 'meal',
                  calories: '210',
                  protein: '14',
                  carbs: '3',
                  fat: '16',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('meal picker option card fits nutrition and ingredient chips', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SizedBox(
              width: 390,
              child: RestaurantMenuOptionCard(
                option: const RestaurantMenuOption(
                  id: 'meal-1',
                  slot: 'lunch',
                  title: 'دجاج مشوي مع أرز',
                  imageAsset:
                      'assets/images/calendar/figma/meal_picker_hero-47a8dd.png',
                  calories: '620',
                  protein: '38',
                  carbs: '5',
                  fat: '50',
                  ingredients: [
                    RestaurantMenuIngredient(label: 'سبانخ'),
                    RestaurantMenuIngredient(label: 'قرنبيط'),
                  ],
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('meal ingredient chip uses API icon URL when available', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RestaurantMenuIngredientChip(
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

  testWidgets(
    'meal picker uses local selected IDs over stale API selected flag',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: RestaurantMenuView(
              mode: RestaurantMenuMode.selection,
              menuData: CalendarMenuMapper.toMenuData(
                availableMeals: CalendarAvailableMealsEntity(
                  restaurant: null,
                  meals: [
                    _meal(id: 'meal-1', selected: true),
                    _meal(id: 'meal-2'),
                  ],
                  slotRequirements: const [
                    CalendarSlotRequirementEntity(
                      slot: 'lunch',
                      displayName: 'Lunch',
                      slotNameAr: 'الغداء',
                      slotNameEn: 'Lunch',
                      count: 1,
                    ),
                  ],
                ),
                selectedMealIds: const ['meal-2'],
                locale: AppLocalizationsEn(),
              ),
              onMealToggled: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
    },
  );

  test('restaurant description stays below the header', () {
    final headerSource = File(
      'lib/features/restaurant_menu/presentation/widgets/'
      'restaurant_menu_header.dart',
    ).readAsStringSync();
    final sheetSource = File(
      'lib/features/restaurant_menu/presentation/widgets/restaurant_menu_content.dart',
    ).readAsStringSync();

    expect(
      headerSource,
      isNot(contains('locale.calendar_restaurant_description')),
    );
    expect(sheetSource, contains('const RestaurantMenuDescription()'));
  });

  test('full page meal picker keeps rounded sheet border over hero image', () {
    final sheetSource = File(
      'lib/features/restaurant_menu/presentation/widgets/restaurant_menu_frame.dart',
    ).readAsStringSync();

    expect(sheetSource, contains('top: Spacing.restaurantDetailsSheetTop,'));
    expect(
      sheetSource,
      contains('Radius.circular(Spacing.restaurantDetailsSheetRadius)'),
    );
    expect(sheetSource, isNot(contains('BorderRadius.zero')));
  });
}

CalendarMealEntity _meal({required String id, bool selected = false}) {
  return CalendarMealEntity(
    id: id,
    slot: 'lunch',
    selected: selected,
    mealType: 'Lunch',
    title: id,
    time: '',
    calories: '',
    protein: '',
    carbs: '',
    fat: '',
    ingredients: const [],
    imageAsset: '',
    actionLabel: '',
  );
}
