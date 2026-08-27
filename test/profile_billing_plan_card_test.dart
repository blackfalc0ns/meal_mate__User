import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_plan_card.dart';

void main() {
  testWidgets('upgrade tier action opens restaurant tier upgrade screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          AppRoutes.restaurantTierUpgrade: (_) =>
              const Scaffold(body: Text('restaurant tier upgrade route')),
        },
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: ProfileBillingPlanCard(subscription: _subscription()),
          ),
        ),
      ),
    );

    await tester.tap(find.text('ترقية التصنيف'));
    await tester.pumpAndSettle();

    expect(find.text('restaurant tier upgrade route'), findsOneWidget);
  });
}

ProfileBillingSubscriptionEntity _subscription() {
  return const ProfileBillingSubscriptionEntity(
    subscriptionId: 'subscription-1',
    status: 'active',
    statusNameAr: 'مجدول',
    programNameAr: 'متوازنة',
    programNameEn: 'Balanced',
    bundleNameAr: 'باقة متوازنة خفيفة',
    bundleNameEn: 'Light balanced package',
    tier: 'select',
    tierNameAr: 'أساسي',
    tierNameEn: 'Basic',
    tierLogoUrl: '',
    imageUrl: '',
    nextRenewalDate: '2026-09-11',
    totalServiceDays: 12,
    completedServiceDays: 0,
    remainingServiceDays: 12,
    progressPercentage: 0,
    paidAmount: 65,
    currencyCode: 'KWD',
    restaurant: ProfileBillingRestaurantEntity(
      restaurantId: 'restaurant-1',
      nameAr: 'دايت كير',
      nameEn: 'Diet Care',
      logoUrl: '',
    ),
    actions: ProfileBillingActionsEntity(
      canRenew: false,
      canFreeze: false,
      canCancel: false,
      canUpgrade: false,
      renewUnavailableReason: '',
      freezeUnavailableReason: '',
      cancelUnavailableReason: '',
      upgradeUnavailableReason: '',
      freezeStartDelayDays: 0,
      maximumFreezeDays: 0,
      freezeExtendsSubscriptionEnd: false,
    ),
  );
}
