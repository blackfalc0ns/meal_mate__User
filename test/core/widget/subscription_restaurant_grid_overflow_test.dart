import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurants_grid.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

void main() {
  final sampleRestaurants = [
    const MonthlyRestaurantPlanEntity(
      programId: 'program-1',
      bundleId: 'bundle-1',
      restaurantId: 'rest-1',
      name: '[تجربة] بروتين لاب',
      subtitle: 'وجبة واحدة',
      tierName: 'أساسي',
      meals: 'وجبة واحدة',
      bundleMeals: '0',
      rating: '4.8',
      brandColor: Color(0xFF0D986A),
    ),
    const MonthlyRestaurantPlanEntity(
      programId: 'program-1',
      bundleId: 'bundle-1',
      restaurantId: 'rest-2',
      name: '[تجربة] جرين بول',
      subtitle: 'وجبة واحدة',
      tierName: 'أساسي',
      meals: 'وجبة واحدة',
      bundleMeals: '0',
      rating: '4.9',
      brandColor: Color(0xFF0D986A),
    ),
    const MonthlyRestaurantPlanEntity(
      programId: 'program-1',
      bundleId: 'bundle-1',
      restaurantId: 'rest-3',
      name: '[تجربة] مطبخ دايت كير',
      subtitle: 'وجبة واحدة',
      tierName: 'أساسي',
      meals: 'وجبة واحدة',
      bundleMeals: '0',
      rating: '4.7',
      brandColor: Color(0xFF0D986A),
    ),
  ];

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

  testWidgets('SubscriptionRestaurantsGrid does not overflow on standard screen (360px)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildTestWidget(
        child: SubscriptionRestaurantsGrid(
          restaurants: sampleRestaurants,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('[تجربة] بروتين لاب'), findsOneWidget);
    expect(find.text('[تجربة] جرين بول'), findsOneWidget);
    expect(find.text('[تجربة] مطبخ دايت كير'), findsOneWidget);
  });

  testWidgets('SubscriptionRestaurantsGrid does not overflow on narrow screen (320px)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildTestWidget(
        child: SubscriptionRestaurantsGrid(
          restaurants: sampleRestaurants,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
