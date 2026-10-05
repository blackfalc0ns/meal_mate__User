import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/screens/meal_details_screen.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/widgets/restaurant_menu_view.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/screens/restaurant_menu_screen.dart';

void main() {
  testWidgets('standalone menu selects meals and returns to its caller', (
    tester,
  ) async {
    String? selectedMeal;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => RestaurantMenuScreen(
                    mode: RestaurantMenuMode.selection,
                    menuData: _menuData(),
                    onMealToggled: (id) => selectedMeal = id,
                  ),
                ),
              ),
              child: const Text('Open menu'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(RestaurantMenuScreen), findsOneWidget);
    expect(find.byType(RestaurantMenuSheetHandle), findsNothing);
    await tester.ensureVisible(_selectButtons);
    await tester.tap(_selectButtons);
    await tester.pump();
    expect(selectedMeal, 'meal-1');
    await tester.tap(find.byType(BackButtonIcon));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Open menu'), findsOneWidget);
    expect(find.byType(RestaurantMenuScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview restaurant menu hides meal selection controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RestaurantMenuView(
            mode: RestaurantMenuMode.preview,
            menuData: _menuData(selectedMealIds: const ['meal-1']),
            onMealToggled: (_) {},
          ),
        ),
      ),
    );

    expect(_selectButtons, findsNothing);
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('selection restaurant menu shows meal selection controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RestaurantMenuView(
            mode: RestaurantMenuMode.selection,
            menuData: _menuData(selectedMealIds: const ['meal-1']),
            onMealToggled: (_) {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(_selectButtons, findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('selected meal details hide selection controls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.mealDetails) {
            return MaterialPageRoute<void>(
              builder: (_) => Scaffold(
                body: MealDetailsScreen(
                  meal: settings.arguments! as MealDetailsEntity,
                ),
              ),
            );
          }
          return null;
        },
        home: Scaffold(
          body: RestaurantMenuView(
            mode: RestaurantMenuMode.selection,
            menuData: _menuData(selectedMealIds: const ['meal-1']),
            onMealToggled: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('meal-1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Optional notes'), findsNothing);
    expect(find.text('Select this meal'), findsNothing);
  });

  testWidgets('blocked meal details hide selection button and prevent toggle', (
    tester,
  ) async {
    var toggled = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.mealDetails) {
            return MaterialPageRoute<void>(
              builder: (_) => Scaffold(
                body: MealDetailsScreen(
                  meal: settings.arguments! as MealDetailsEntity,
                ),
              ),
            );
          }
          return null;
        },
        home: Scaffold(
          body: RestaurantMenuView(
            mode: RestaurantMenuMode.selection,
            menuData: const RestaurantMenuData(
              tabs: [
                RestaurantMenuTab(
                  key: 'lunch',
                  label: 'Lunch',
                  options: [
                    RestaurantMenuOption(
                      id: 'meal-blocked',
                      slot: 'lunch',
                      title: 'Blocked Meal',
                      blockReason: 'Contains allergen',
                    ),
                  ],
                ),
              ],
            ),
            onMealToggled: (_) => toggled = true,
          ),
        ),
      ),
    );

    expect(find.text('Contains allergen'), findsOneWidget);

    await tester.tap(find.text('Blocked Meal'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Select this meal'), findsNothing);
    expect(toggled, isFalse);
  });
}

Finder get _selectButtons {
  return find.byWidgetPredicate(
    (widget) => widget.runtimeType.toString() == 'RestaurantMenuSelectButton',
  );
}

RestaurantMenuData _menuData({List<String> selectedMealIds = const []}) {
  return RestaurantMenuData(
    tabs: [
      RestaurantMenuTab(
        key: 'lunch',
        label: 'Lunch',
        options: [
          RestaurantMenuOption(
            id: 'meal-1',
            slot: 'lunch',
            title: 'meal-1',
            selected: selectedMealIds.contains('meal-1'),
          ),
        ],
      ),
    ],
  );
}
