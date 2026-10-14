import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_action_coordinator.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_active_freeze_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_freeze_notice_sheet.dart';

void main() {
  Widget buildApp({required Widget home, Locale locale = const Locale('en')}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
  }

  SubscriptionBillingSubscriptionEntity createTestSubscription({
    bool canFreeze = true,
    String? freezeNotice = 'Server freeze policy text for testing',
    String? freezeNoticeAr = 'سياسة التجميد من الخادم للاختبار',
    SubscriptionBillingPendingFreezeEntity? pendingFreeze,
    SubscriptionBillingActiveFreezeEntity? activeFreeze,
  }) {
    return SubscriptionBillingSubscriptionEntity(
      subscriptionId: 'sub-test-1',
      status: 'active',
      statusNameAr: 'نشط',
      programId: 'prog-1',
      programNameAr: 'برنامج',
      programNameEn: 'Program',
      bundleId: 'bundle-1',
      bundleNameAr: 'باقة',
      bundleNameEn: 'Bundle',
      tier: 'Basic',
      tierNameAr: 'أساسي',
      tierNameEn: 'Basic',
      tierLogoUrl: '',
      mealsPerDay: 2,
      imageUrl: '',
      startDate: '2026-10-01',
      endDate: '2026-10-30',
      nextRenewalDate: '2026-10-31',
      totalServiceDays: 30,
      completedServiceDays: 5,
      remainingServiceDays: 25,
      progressPercentage: 16.6,
      paidAmount: 100.0,
      currencyCode: 'KWD',
      restaurant: const SubscriptionBillingRestaurantEntity(
        restaurantId: 'rest-1',
        nameAr: 'مطعم',
        nameEn: 'Restaurant',
        logoUrl: '',
      ),
      actions: SubscriptionBillingActionsEntity(
        canRenew: true,
        canFreeze: canFreeze,
        canCancel: true,
        canUpgrade: true,
        renewUnavailableReason: '',
        freezeUnavailableReason: '',
        cancelUnavailableReason: '',
        upgradeUnavailableReason: '',
        freezeStartDelayDays: 3,
        maximumFreezeDays: 7,
        freezeExtendsSubscriptionEnd: true,
        earliestFreezeStartDate: '2026-10-05',
        renewalEndpoint: '/renew',
        freezeEndpoint: '/freeze',
        cancellationEndpoint: '/cancel',
        upgradeEndpoint: '/upgrade',
        cancellationQuoteEndpoint: '/quote',
        freezeNotice: freezeNotice,
        freezeNoticeAr: freezeNoticeAr,
      ),
      pendingFreeze: pendingFreeze,
      activeFreeze: activeFreeze,
    );
  }

  group('SubscriptionFreezeNoticeSheet direct widget tests', () {
    testWidgets('renders notice text and Agree/Cancel buttons', (tester) async {
      bool? result;

      await tester.pumpWidget(
        buildApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      result = await requestFreezeConsent(
                        context,
                        'Server detailed freeze terms and conditions.',
                      );
                    },
                    child: const Text('Open Consent'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Consent'));
      await tester.pumpAndSettle();

      expect(
        find.text('Server detailed freeze terms and conditions.'),
        findsOneWidget,
      );
      expect(find.byType(SubscriptionFreezeNoticeSheet), findsOneWidget);
      expect(find.text('Agree & Continue'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Tapping Cancel dismisses with false
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
      expect(find.byType(SubscriptionFreezeNoticeSheet), findsNothing);
    });

    testWidgets('agree button dismisses with true', (tester) async {
      bool? result;

      await tester.pumpWidget(
        buildApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      result = await requestFreezeConsent(
                        context,
                        'Terms notice text',
                      );
                    },
                    child: const Text('Open Consent'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Consent'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Agree & Continue'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
      expect(find.byType(SubscriptionFreezeNoticeSheet), findsNothing);
    });
  });

  group('SubscriptionBillingActionCoordinator freeze flow tests', () {
    testWidgets(
      'shows notice sheet first and cancelling prevents freeze request',
      (tester) async {
        SubscriptionBillingFreezeRequestEntity? emittedRequest;
        final coordinator = SubscriptionBillingActionCoordinator(
          onRenew: (_) {},
          onFreeze: (_, request) => emittedRequest = request,
          onCancelQuote: (_) {},
          onCancel: (_, reason) {},
          onResetAction: () {},
          onDeleteUncompleted: (_) {},
          onResumePreview: (_) {},
          onResume: (_, [paymentMethodId]) {},
          onResumeFamily: (_) {},
        );

        final subscription = createTestSubscription();

        await tester.pumpWidget(
          buildApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () => coordinator.confirmFreeze(
                      context: context,
                      subscription: subscription,
                    ),
                    child: const Text('Freeze Action'),
                  ),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Freeze Action'));
        await tester.pumpAndSettle();

        // Step 1: Notice sheet MUST be visible first
        expect(find.byType(SubscriptionFreezeNoticeSheet), findsOneWidget);
        expect(
          find.text('Server freeze policy text for testing'),
          findsOneWidget,
        );

        // Cancel it
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // No freeze request was made
        expect(emittedRequest, isNull);
        expect(coordinator.isFreezeFlowOpen, isFalse);
      },
    );

    testWidgets(
      'active freeze opens active freeze dialog without new freeze sheet',
      (tester) async {
        final coordinator = SubscriptionBillingActionCoordinator(
          onRenew: (_) {},
          onFreeze: (_, req) {},
          onCancelQuote: (_) {},
          onCancel: (_, reason) {},
          onResetAction: () {},
          onDeleteUncompleted: (_) {},
          onResumePreview: (_) {},
          onResume: (_, [paymentMethodId]) {},
          onResumeFamily: (_) {},
        );

        const activeFreeze = SubscriptionBillingActiveFreezeEntity(
          requestId: 'act-1',
          startDate: '2026-10-10',
          endDate: '2026-10-15',
          freezeDays: 5,
          frozenServiceDaysCount: 5,
          status: 'Active',
          statusNameAr: 'نشط',
          isCurrentlyActive: true,
          isUpcoming: false,
          reason: 'Holiday',
          createdAtUtc: '2026-10-01T00:00:00Z',
          processedAtUtc: '2026-10-01T00:00:00Z',
          frozenServiceDates: [],
          compensationDates: [],
          subscriptionEndDate: '2026-11-05',
          summaryAr: '',
          summaryEn: '',
        );

        final subscription = createTestSubscription(activeFreeze: activeFreeze);

        await tester.pumpWidget(
          buildApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () => coordinator.confirmFreeze(
                      context: context,
                      subscription: subscription,
                    ),
                    child: const Text('Freeze Action'),
                  ),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Freeze Action'));
        await tester.pumpAndSettle();

        // Should NOT show new freeze notice sheet
        expect(find.byType(SubscriptionFreezeNoticeSheet), findsNothing);
        expect(
          find.byType(SubscriptionBillingActiveFreezeCard),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'handleConfirmOverwriteSelections emits freeze request with acknowledgeLostSelections: true',
      (tester) async {
        SubscriptionBillingFreezeRequestEntity? capturedRequest;
        String? capturedSubId;

        final coordinator = SubscriptionBillingActionCoordinator(
          onRenew: (_) {},
          onFreeze: (subId, request) {
            capturedSubId = subId;
            capturedRequest = request;
          },
          onCancelQuote: (_) {},
          onCancel: (_, reason) {},
          onResetAction: () {},
          onDeleteUncompleted: (_) {},
          onResumePreview: (_) {},
          onResume: (_, [paymentMethodId]) {},
          onResumeFamily: (_) {},
        );

        const pendingRequest = SubscriptionBillingFreezeRequestEntity(
          startDate: '2026-10-10',
          endDate: '2026-10-15',
          reason: 'Travel',
          acknowledgeLostSelections: false,
        );

        await tester.pumpWidget(
          buildApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () =>
                        coordinator.handleConfirmOverwriteSelections(
                          context: context,
                          pendingRequest: pendingRequest,
                          pendingSubscriptionId: 'sub-test-1',
                        ),
                    child: const Text('Trigger Overwrite Dialog'),
                  ),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Trigger Overwrite Dialog'));
        await tester.pumpAndSettle();

        expect(
          find.text('Confirm Meal Selections Cancellation'),
          findsOneWidget,
        );

        // Confirm
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(capturedSubId, 'sub-test-1');
        expect(capturedRequest, isNotNull);
        expect(capturedRequest?.acknowledgeLostSelections, isTrue);
        expect(capturedRequest?.startDate, '2026-10-10');
        expect(capturedRequest?.endDate, '2026-10-15');
      },
    );
  });
}
