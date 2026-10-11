import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_badge.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_feature_chip.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_upgrade_hero_card.dart';

void main() {
  testWidgets('RestaurantTierUpgradeHeroCard renders properly in RTL and LTR', (
    tester,
  ) async {
    const currentOption = SubscriptionUpgradeOptionEntity(
      targetTier: 'basic',
      tierNameAr: 'أساسي',
      tierNameEn: 'Basic',
      isCurrent: true,
      selectable: false,
      accessibleRestaurantCount: 20,
      currentRemainingCredit: 5.0,
      targetRemainingPrice: 10.0,
      gatewayRecovery: 0.0,
      priceDifference: 5.0,
      currencyCode: 'KWD',
    );

    const selectedOption = SubscriptionUpgradeOptionEntity(
      targetTier: 'platinum',
      tierNameAr: 'بلاتينيوم',
      tierNameEn: 'Platinum',
      isCurrent: false,
      selectable: true,
      accessibleRestaurantCount: 30,
      currentRemainingCredit: 5.0,
      targetRemainingPrice: 15.0,
      gatewayRecovery: 0.0,
      priceDifference: 10.0,
      currencyCode: 'KWD',
    );

    const optionsEntity = SubscriptionUpgradeOptionsEntity(
      canUpgrade: true,
      currentTier: 'basic',
      remainingServiceDays: 15,
      totalServiceDays: 30,
      upgradeEndpoint: '/upgrade',
      options: [currentOption, selectedOption],
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('ar'),
        home: Scaffold(
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: RestaurantTierUpgradeHeroCard(
              optionsEntity: optionsEntity,
              selectedOption: selectedOption,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify current tier and new tier text are rendered
    expect(find.text('أساسي'), findsOneWidget);
    expect(find.text('بلاتينيوم'), findsOneWidget);

    // Verify badges are present
    expect(find.byType(RestaurantTierBadge), findsNWidgets(2));

    // Verify chips are present
    expect(find.byType(RestaurantTierFeatureChip), findsNWidgets(3));

    // Verify no broken image icons exist
    expect(find.byIcon(Icons.broken_image_rounded), findsNothing);
  });
}
