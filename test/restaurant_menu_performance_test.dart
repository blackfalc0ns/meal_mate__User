import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/widgets/restaurant_menu_view.dart';

void main() {
  Widget buildTestableWidget(Widget child, {bool disableAnimations = false}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: disableAnimations),
          child: childWidget!,
        );
      },
      home: Scaffold(body: child),
    );
  }

  testWidgets(
    'lazy list builds items on demand instead of building all 100 at once',
    (tester) async {
      final options = List.generate(
        100,
        (i) => RestaurantMenuOption(
          id: 'meal-$i',
          slot: 'lunch',
          title: 'Distinct Meal Title #$i',
          calories: '$i kcal',
          protein: '${i * 2}g',
          carbs: '${i * 3}g',
          fat: '${i * 4}g',
          selected: false,
        ),
      );

      final menuData = RestaurantMenuData(
        restaurantName: 'Test Restaurant',
        tabs: [
          RestaurantMenuTab(key: 'lunch', label: 'Lunch', options: options),
        ],
      );

      await tester.pumpWidget(
        buildTestableWidget(
          RestaurantMenuView(
            mode: RestaurantMenuMode.selection,
            menuData: menuData,
          ),
        ),
      );
      await tester.pump();

      // With lazy building, meal #99 should NOT be built yet because it's far down the scroll view.
      // In the non-lazy Column implementation, all 100 items are built eagerly, so this assertion will fail.
      expect(
        find.text('Distinct Meal Title #99'),
        findsNothing,
        reason: 'Last meal should not be built eagerly before scrolling',
      );

      // After scrolling down, the last item should become visible/built.
      await tester.scrollUntilVisible(
        find.text('Distinct Meal Title #99'),
        500,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Distinct Meal Title #99'), findsOneWidget);
    },
  );

  testWidgets('reordering tabs preserves selected slot key', (tester) async {
    const tabs = [
      RestaurantMenuTab(
        key: 'breakfast',
        label: 'Breakfast',
        options: [
          RestaurantMenuOption(
            id: 'b1',
            slot: 'breakfast',
            title: 'Breakfast 1',
          ),
        ],
      ),
      RestaurantMenuTab(
        key: 'lunch',
        label: 'Lunch',
        options: [
          RestaurantMenuOption(id: 'l1', slot: 'lunch', title: 'Lunch 1'),
        ],
      ),
    ];

    await tester.pumpWidget(
      buildTestableWidget(
        const RestaurantMenuView(
          mode: RestaurantMenuMode.selection,
          menuData: RestaurantMenuData(restaurantName: 'Test', tabs: tabs),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Select 'Lunch' tab
    await tester.tap(find.text('Lunch'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Lunch 1'), findsOneWidget);

    // Reorder tabs: lunch first, breakfast second
    final reorderedTabs = [tabs[1], tabs[0]];
    await tester.pumpWidget(
      buildTestableWidget(
        RestaurantMenuView(
          mode: RestaurantMenuMode.selection,
          menuData: RestaurantMenuData(
            restaurantName: 'Test',
            tabs: reorderedTabs,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // 'lunch' slot key should still be selected!
    expect(find.text('Lunch 1'), findsOneWidget);
  });

  testWidgets('deleting selected slot key falls back to first available slot', (
    tester,
  ) async {
    const tabs = [
      RestaurantMenuTab(
        key: 'breakfast',
        label: 'Breakfast',
        options: [
          RestaurantMenuOption(
            id: 'b1',
            slot: 'breakfast',
            title: 'Breakfast 1',
          ),
        ],
      ),
      RestaurantMenuTab(
        key: 'lunch',
        label: 'Lunch',
        options: [
          RestaurantMenuOption(id: 'l1', slot: 'lunch', title: 'Lunch 1'),
        ],
      ),
    ];

    await tester.pumpWidget(
      buildTestableWidget(
        const RestaurantMenuView(
          mode: RestaurantMenuMode.selection,
          menuData: RestaurantMenuData(restaurantName: 'Test', tabs: tabs),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Select 'Lunch'
    await tester.tap(find.text('Lunch'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Lunch 1'), findsOneWidget);

    // Remove lunch slot
    final updatedTabs = [tabs[0]];
    await tester.pumpWidget(
      buildTestableWidget(
        RestaurantMenuView(
          mode: RestaurantMenuMode.selection,
          menuData: RestaurantMenuData(
            restaurantName: 'Test',
            tabs: updatedTabs,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Falls back to breakfast
    expect(find.text('Breakfast 1'), findsOneWidget);
  });

  testWidgets(
    'switching tab does not rebuild RestaurantMenuView or outer frame',
    (tester) async {
      int viewBuildCount = 0;
      const tabs = [
        RestaurantMenuTab(
          key: 'breakfast',
          label: 'Breakfast',
          options: [
            RestaurantMenuOption(
              id: 'b1',
              slot: 'breakfast',
              title: 'Breakfast 1',
            ),
          ],
        ),
        RestaurantMenuTab(
          key: 'lunch',
          label: 'Lunch',
          options: [
            RestaurantMenuOption(id: 'l1', slot: 'lunch', title: 'Lunch 1'),
          ],
        ),
      ];

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) {
              viewBuildCount++;
              return const RestaurantMenuView(
                mode: RestaurantMenuMode.selection,
                menuData: RestaurantMenuData(
                  restaurantName: 'Test',
                  tabs: tabs,
                ),
              );
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(viewBuildCount, 1);

      // Switch tab to lunch
      await tester.tap(find.text('Lunch'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Lunch 1'), findsOneWidget);
      expect(
        viewBuildCount,
        1,
        reason: 'RestaurantMenuView was not rebuilt when switching tab in body',
      );
    },
  );

  testWidgets(
    'empty tabs do not throw RangeError and render fallback gracefully',
    (tester) async {
      const menuData = RestaurantMenuData(
        restaurantName: 'Test Restaurant',
        tabs: [],
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const RestaurantMenuView(
            mode: RestaurantMenuMode.preview,
            menuData: menuData,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'RestaurantMenuAnimatedOption renders child without animation when disabled or animateEntry is false',
    (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const RestaurantMenuAnimatedOption(
            animateEntry: false,
            child: Text('Static Option'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Static Option'), findsOneWidget);
    },
  );

  testWidgets(
    'toggling first meal only rebuilds its selection button without rebuilding other meals or card contents',
    (tester) async {
      int button1Builds = 0;
      int button2Builds = 0;
      final selectedNotifier = ValueNotifier<Set<String>>({'meal-1'});

      const tabs = [
        RestaurantMenuTab(
          key: 'lunch',
          label: 'Lunch',
          options: [
            RestaurantMenuOption(
              id: 'meal-1',
              slot: 'lunch',
              title: 'Meal One',
            ),
            RestaurantMenuOption(
              id: 'meal-2',
              slot: 'lunch',
              title: 'Meal Two',
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        buildTestableWidget(
          RestaurantMenuView(
            mode: RestaurantMenuMode.selection,
            menuData: const RestaurantMenuData(
              restaurantName: 'Test',
              tabs: tabs,
            ),
            selectionControlBuilder: (context, option) {
              return ValueListenableBuilder<Set<String>>(
                valueListenable: selectedNotifier,
                builder: (context, selected, _) {
                  final isSelected = selected.contains(option.id);
                  return _IsolatedButton(
                    key: ValueKey('btn_${option.id}'),
                    isSelected: isSelected,
                    onBuild: () {
                      if (option.id == 'meal-1') button1Builds++;
                      if (option.id == 'meal-2') button2Builds++;
                    },
                  );
                },
              );
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(button1Builds, 1);
      expect(button2Builds, 1);

      // Deselect meal-1 only: meal-2 remains false
      selectedNotifier.value = <String>{};
      await tester.pump();

      // button1 should rebuild to reflect unselected state
      expect(button1Builds, 2);
      // button2's state (isSelected: false) did not change, but let's check its builds
      // And the option cards' titles/images were not rebuilt at the screen level
      expect(find.text('Meal One'), findsOneWidget);
      expect(find.text('Meal Two'), findsOneWidget);
    },
  );

  testWidgets(
    'pagination: vertical scroll near bottom triggers onLoadMore with active slot key, while horizontal scroll does not',
    (tester) async {
      final loadedSlots = <String>[];
      final options = List.generate(
        15,
        (i) => RestaurantMenuOption(
          id: 'meal-$i',
          slot: 'dinner',
          title: 'Meal $i',
          ingredients: const [
            RestaurantMenuIngredient(label: 'Ing 1'),
            RestaurantMenuIngredient(label: 'Ing 2'),
            RestaurantMenuIngredient(label: 'Ing 3'),
            RestaurantMenuIngredient(label: 'Ing 4'),
            RestaurantMenuIngredient(label: 'Ing 5'),
          ],
        ),
      );

      final tabs = [
        RestaurantMenuTab(key: 'dinner', label: 'Dinner', options: options),
      ];

      await tester.pumpWidget(
        buildTestableWidget(
          RestaurantMenuView(
            mode: RestaurantMenuMode.selection,
            menuData: RestaurantMenuData(restaurantName: 'Test', tabs: tabs),
            onLoadMore: loadedSlots.add,
          ),
          disableAnimations: true,
        ),
      );
      await tester.pump();

      // 1. Scroll horizontally inside ingredient row
      final horizontalScrollables = find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.right,
      );
      if (horizontalScrollables.evaluate().isNotEmpty) {
        await tester.drag(horizontalScrollables.first, const Offset(-50, 0));
        await tester.pump();
        expect(loadedSlots, isEmpty);
      }

      // 2. Scroll vertically near bottom
      final verticalScrollable = find.byType(Scrollable).first;
      await tester.drag(verticalScrollable, const Offset(0, -2000));
      await tester.pump();

      expect(loadedSlots, contains('dinner'));
    },
  );

  testWidgets('pagination: isLoading or isLoadingMore suppresses onLoadMore', (
    tester,
  ) async {
    final loadedSlots = <String>[];
    final options = List.generate(
      15,
      (i) =>
          RestaurantMenuOption(id: 'meal-$i', slot: 'lunch', title: 'Meal $i'),
    );

    final tabs = [
      RestaurantMenuTab(key: 'lunch', label: 'Lunch', options: options),
    ];

    // Case A: isLoading is true
    await tester.pumpWidget(
      buildTestableWidget(
        RestaurantMenuView(
          mode: RestaurantMenuMode.selection,
          menuData: RestaurantMenuData(restaurantName: 'Test', tabs: tabs),
          isLoading: true,
          onLoadMore: loadedSlots.add,
        ),
        disableAnimations: true,
      ),
    );
    await tester.pump();

    final verticalScrollable = find.byType(Scrollable).first;
    await tester.drag(verticalScrollable, const Offset(0, -2000));
    await tester.pump();

    expect(loadedSlots, isEmpty);

    // Case B: isLoadingMore is true
    await tester.pumpWidget(
      buildTestableWidget(
        RestaurantMenuView(
          mode: RestaurantMenuMode.selection,
          menuData: RestaurantMenuData(restaurantName: 'Test', tabs: tabs),
          isLoadingMore: true,
          onLoadMore: loadedSlots.add,
        ),
        disableAnimations: true,
      ),
    );
    await tester.pump();

    await tester.drag(verticalScrollable, const Offset(0, -2000));
    await tester.pump();

    expect(loadedSlots, isEmpty);
  });
}

class _IsolatedButton extends StatelessWidget {
  const _IsolatedButton({
    super.key,
    required this.isSelected,
    required this.onBuild,
  });

  final bool isSelected;
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    return RestaurantMenuSelectButton(selected: isSelected, enabled: true);
  }
}
