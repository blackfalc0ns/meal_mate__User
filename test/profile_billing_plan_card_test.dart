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

  testWidgets('renew freeze and cancel actions call callbacks when available', (
    tester,
  ) async {
    var renewed = false;
    var frozen = false;
    var cancelled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ProfileBillingPlanCard(
            subscription: _subscription(
              canRenew: true,
              canFreeze: true,
              canCancel: true,
            ),
            onRenew: () => renewed = true,
            onFreeze: () => frozen = true,
            onCancel: () => cancelled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Renew'));
    await tester.tap(find.text('Freeze'));
    await tester.tap(find.text('Cancel'));

    expect(renewed, isTrue);
    expect(frozen, isTrue);
    expect(cancelled, isTrue);
  });

  testWidgets(
    'freeze action opens active freeze details when freeze is active',
    (tester) async {
      var frozen = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ProfileBillingPlanCard(
              subscription: _subscription(
                canFreeze: false,
                activeFreeze: _activeFreeze(),
              ),
              onFreeze: () => frozen = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Freeze'));

      expect(frozen, isTrue);
    },
  );

  testWidgets('tapping unavailable action shows custom snackbar message', (
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
            body: ProfileBillingPlanCard(
              subscription: _subscription(canFreeze: false),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('تجميد'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('هذا الإجراء غير متاح حالياً.'), findsOneWidget);
  });
}

ProfileBillingSubscriptionEntity _subscription({
  bool canRenew = false,
  bool canFreeze = false,
  bool canCancel = false,
  ProfileBillingActiveFreezeEntity? activeFreeze,
}) {
  return ProfileBillingSubscriptionEntity(
    subscriptionId: 'subscription-1',
    status: 'active',
    programId: 'program-1',
    statusNameAr: 'مجدول',
    programNameAr: 'متوازنة',
    programNameEn: 'Balanced',
    bundleId: 'bundle-1',
    bundleNameAr: 'باقة متوازنة خفيفة',
    bundleNameEn: 'Light balanced package',
    tier: 'select',
    tierNameAr: 'أساسي',
    tierNameEn: 'Basic',
    tierLogoUrl: '',
    mealsPerDay: 2,
    imageUrl: '',
    startDate: '2026-09-01',
    endDate: '2026-09-12',
    nextRenewalDate: '2026-09-11',
    totalServiceDays: 12,
    completedServiceDays: 0,
    remainingServiceDays: 12,
    progressPercentage: 0,
    paidAmount: 65,
    currencyCode: 'KWD',
    restaurant: const ProfileBillingRestaurantEntity(
      restaurantId: 'restaurant-1',
      nameAr: 'دايت كير',
      nameEn: 'Diet Care',
      logoUrl: '',
    ),
    actions: ProfileBillingActionsEntity(
      canRenew: canRenew,
      canFreeze: canFreeze,
      canCancel: canCancel,
      canUpgrade: false,
      renewUnavailableReason: '',
      freezeUnavailableReason: '',
      cancelUnavailableReason: '',
      upgradeUnavailableReason: '',
      freezeStartDelayDays: 0,
      maximumFreezeDays: 0,
      freezeExtendsSubscriptionEnd: false,
      earliestFreezeStartDate: '',
      renewalEndpoint: '',
      freezeEndpoint: '',
      cancellationEndpoint: '',
      upgradeEndpoint: '',
      cancellationQuoteEndpoint: '',
    ),
    activeFreeze: activeFreeze,
  );
}

ProfileBillingActiveFreezeEntity _activeFreeze() {
  return const ProfileBillingActiveFreezeEntity(
    requestId: 'freeze-1',
    startDate: '2026-09-07',
    endDate: '2026-09-12',
    freezeDays: 6,
    frozenServiceDaysCount: 6,
    status: 'Approved',
    statusNameAr: 'Approved and applied',
    isCurrentlyActive: true,
    isUpcoming: false,
    reason: '',
    createdAtUtc: '2026-09-03T14:18:47.743613Z',
    processedAtUtc: '2026-09-03T14:18:47.743302Z',
    frozenServiceDates: [
      '2026-09-07',
      '2026-09-08',
      '2026-09-09',
      '2026-09-10',
      '2026-09-11',
      '2026-09-12',
    ],
    compensationDates: [
      '2026-09-19',
      '2026-09-20',
      '2026-09-21',
      '2026-09-22',
      '2026-09-23',
      '2026-09-24',
    ],
    subscriptionEndDate: '2026-09-24',
    summaryAr: '',
    summaryEn: '',
  );
}
