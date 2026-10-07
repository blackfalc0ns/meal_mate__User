import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_active_freeze_card.dart';

void main() {
  testWidgets('active freeze card shows backend freeze details', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SubscriptionBillingActiveFreezeCard(
            activeFreeze: const SubscriptionBillingActiveFreezeEntity(
              requestId: 'freeze-1',
              startDate: '2026-09-07',
              endDate: '2026-09-12',
              freezeDays: 6,
              frozenServiceDaysCount: 5,
              status: 'Approved',
              statusNameAr: 'Approved and applied',
              isCurrentlyActive: false,
              isUpcoming: true,
              reason: 'Travel',
              createdAtUtc: '2026-09-03T14:18:47.743613Z',
              processedAtUtc: '2026-09-03T14:18:47.743302Z',
              frozenServiceDates: [
                '2026-09-07',
                '2026-09-08',
                '2026-09-09',
                '2026-09-10',
                '2026-09-12',
              ],
              compensationDates: [
                '2026-09-20',
                '2026-09-21',
                '2026-09-22',
                '2026-09-23',
                '2026-09-24',
              ],
              subscriptionEndDate: '2026-09-24',
              summaryAr: 'Arabic summary',
              summaryEn:
                  '5 service days frozen and compensated at subscription end.',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Subscription Freeze Details'), findsOneWidget);
    expect(find.text('Approved and applied'), findsOneWidget);
    expect(find.text('Duration: 6 days'), findsOneWidget);
    expect(find.text('Frozen service days: 5'), findsOneWidget);
    expect(find.text('Compensation days: 5'), findsOneWidget);
    expect(find.text('New end date: Sep 24, 2026'), findsOneWidget);
    expect(
      find.text('5 service days frozen and compensated at subscription end.'),
      findsOneWidget,
    );
  });
}
