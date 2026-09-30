import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tiers_section.dart';

void main() {
  Widget buildTestWidget({
    required Widget child,
    Locale locale = const Locale('ar'),
    TextDirection textDirection = TextDirection.rtl,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  final samplePackages = [
    const RestaurantPackageTierUiModel(
      title: 'سيلكت',
      iconName: 'heart',
      restaurantCount: 25,
      price: '6.500',
      currency: 'د.ك',
      priceSubtitle: 'حتى نهاية الاشتراك',
      restaurantLogoUrls: [],
    ),
    const RestaurantPackageTierUiModel(
      title: 'بلس',
      iconName: 'crown',
      restaurantCount: 50,
      price: '6.500',
      currency: 'د.ك',
      priceSubtitle: 'حتى نهاية الاشتراك',
      restaurantLogoUrls: [],
    ),
    const RestaurantPackageTierUiModel(
      title: 'ماكس',
      iconName: 'diamond',
      restaurantCount: 100,
      price: '6.500',
      currency: 'د.ك',
      priceSubtitle: 'حتى نهاية الاشتراك',
      restaurantLogoUrls: [],
    ),
  ];

  group('RestaurantPackageTiersSection', () {
    testWidgets('renders header, titles, prices, and logos', (tester) async {
      int? selected;
      int? browsed;

      await tester.pumpWidget(
        buildTestWidget(
          child: RestaurantPackageTiersSection(
            packages: samplePackages,
            selectedIndex: 0,
            onSelected: (i) => selected = i,
            onBrowseRestaurants: (i) => browsed = i,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header
      expect(find.text('استعراض التصنيفات'), findsOneWidget);
      expect(
        find.text('كل تصنيف يضم مجموعة مختارة من المطاعم المميزة.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);

      // Check tier titles
      expect(find.text('سيلكت'), findsOneWidget);
      expect(find.text('بلس'), findsOneWidget);
      expect(find.text('ماكس'), findsOneWidget);

      // Check counts
      expect(find.text('+25'), findsOneWidget);
      expect(find.text('+50'), findsOneWidget);
      expect(find.text('+100'), findsOneWidget);

      // Check browse buttons
      expect(find.text('استعراض المطاعم'), findsNWidgets(3));

      // Check selection indicator (only card 0 is selected -> 1 checkmark)
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      // Check prices
      expect(find.text('6.5'), findsNWidgets(3));
      expect(find.text('د.ك'), findsNWidgets(3));
      expect(find.text('حتى نهاية الاشتراك'), findsNWidgets(3));

      // Tap card 1 to select
      await tester.tap(find.text('بلس'));
      expect(selected, 1);

      // Tap browse restaurants on card 2
      final browseButtons = find.text('استعراض المطاعم');
      await tester.tap(browseButtons.at(2));
      expect(browsed, 2);
    });

    testWidgets('renders fallback price when price is empty and does not hide it', (tester) async {
      const packageWithEmptyPrice = [
        RestaurantPackageTierUiModel(
          title: 'سيلكت',
          iconName: 'heart',
          restaurantCount: 10,
          price: '',
          currency: '',
          priceSubtitle: '',
          restaurantLogoUrls: [],
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(
          child: RestaurantPackageTiersSection(
            packages: packageWithEmptyPrice,
            selectedIndex: 0,
            onSelected: (_) {},
            onBrowseRestaurants: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('د.ك'), findsOneWidget);
      expect(find.text('حتى نهاية الاشتراك'), findsOneWidget);
    });

    testWidgets('renders in English (LTR) correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('en'),
          textDirection: TextDirection.ltr,
          child: RestaurantPackageTiersSection(
            packages: samplePackages,
            selectedIndex: 1,
            onSelected: (_) {},
            onBrowseRestaurants: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Browse categories'), findsOneWidget);
      expect(
        find.text('Each category includes a curated selection of featured restaurants.'),
        findsOneWidget,
      );
      expect(find.text('Select'), findsOneWidget);
      expect(find.text('Plus'), findsOneWidget);
      expect(find.text('Max'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });
  });
}
