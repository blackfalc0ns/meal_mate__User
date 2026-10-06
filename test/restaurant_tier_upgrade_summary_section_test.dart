import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_upgrade_restaurant_item.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_upgrade_summary_section.dart';

void main() {
  SubscriptionUpgradeRestaurantEntity buildRestaurant(String id, String name) {
    return SubscriptionUpgradeRestaurantEntity(
      id: id,
      nameAr: name,
      nameEn: name,
      logoUrl: 'https://example.com/logo-$id.png',
      rating: 4.5,
      tier: 'Platinum',
    );
  }

  SubscriptionUpgradeSummaryEntity buildSummary(
    List<SubscriptionUpgradeRestaurantEntity> restaurants,
  ) {
    return SubscriptionUpgradeSummaryEntity(
      subscriptionId: 'sub-1',
      currentTier: const SubscriptionUpgradeTierEntity(
        tier: 'Basic',
        tierNameAr: 'أساسي',
        tierNameEn: 'Basic',
        accessibleRestaurantCount: 2,
      ),
      targetTier: const SubscriptionUpgradeTierEntity(
        tier: 'Platinum',
        tierNameAr: 'بلاتينيوم',
        tierNameEn: 'Platinum',
        accessibleRestaurantCount: 3,
      ),
      currentTierRestaurants: const [],
      targetTierRestaurants: const [],
      newlyAddedRestaurants: restaurants,
      effectiveFromDate: '2026-10-31',
      effectiveNoticeAr: 'يبدأ تفعيل التصنيف الجديد',
      effectiveNoticeEn: 'New tier activation begins',
      restaurantRepetition: const SubscriptionUpgradeRestaurantRepetitionEntity(
        limit: 8,
        restaurantCount: 3,
        durationDays: 26,
      ),
      currentRemainingCredit: 111.25,
      targetRemainingPrice: 118.25,
      priceDifference: 7.0,
      currencyCode: 'KWD',
      remainingServiceDays: 26,
      totalServiceDays: 26,
      paymentMethods: const [],
      upgradeEndpoint: '/upgrade',
    );
  }

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  testWidgets(
    'displays single restaurant directly without view more button',
    (tester) async {
      final summary = buildSummary([
        buildRestaurant('1', '[تجربة] بروتين لاب'),
      ]);

      await tester.pumpWidget(
        createTestWidget(
          RestaurantTierUpgradeSummarySection(summary: summary),
        ),
      );
      await tester.pump();

      expect(find.byType(RestaurantTierUpgradeRestaurantItem), findsOneWidget);
      expect(find.text('[تجربة] بروتين لاب'), findsOneWidget);
      expect(find.text('عرض المزيد'), findsNothing);
    },
  );

  testWidgets(
    'caps display at 3 restaurants and shows view more button when more than 3',
    (tester) async {
      final summary = buildSummary([
        buildRestaurant('1', 'مطعم 1'),
        buildRestaurant('2', 'مطعم 2'),
        buildRestaurant('3', 'مطعم 3'),
        buildRestaurant('4', 'مطعم 4'),
        buildRestaurant('5', 'مطعم 5'),
      ]);

      await tester.pumpWidget(
        createTestWidget(
          RestaurantTierUpgradeSummarySection(summary: summary),
        ),
      );
      await tester.pump();

      // Exactly 3 items visible in the section
      expect(find.byType(RestaurantTierUpgradeRestaurantItem), findsNWidgets(3));
      expect(find.text('مطعم 1'), findsOneWidget);
      expect(find.text('مطعم 2'), findsOneWidget);
      expect(find.text('مطعم 3'), findsOneWidget);
      expect(find.text('مطعم 4'), findsNothing);

      // View more button is present
      expect(find.text('عرض المزيد'), findsOneWidget);
    },
  );
}
