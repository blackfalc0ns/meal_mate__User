import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_empty_invoices_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_empty_subscription_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_invoice_history_card.dart';

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
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  group('SubscriptionBillingEmptySubscriptionCard', () {
    testWidgets('renders kit illustration when hasUncompletedSubscriptions is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const SubscriptionBillingEmptySubscriptionCard(
            hasUncompletedSubscriptions: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('لا يوجد اشتراك نشط'), findsOneWidget);
      expect(
        find.text(
          'لم تشترك في أي باقة حتى الآن.\nاختر الباقة المناسبة لك وابدأ رحلتك الصحية.',
        ),
        findsOneWidget,
      );
      expect(find.text('استعرض الاشتراكات'), findsOneWidget);

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final imageWidget = tester.widget<Image>(imageFinder);
      expect(
        (imageWidget.image as AssetImage).assetName,
        Assets.billingEmptySubscriptionKit,
      );
    });

    testWidgets('calls onBrowseSubscriptions when browse button is tapped', (
      tester,
    ) async {
      var browsed = false;
      await tester.pumpWidget(
        buildTestWidget(
          child: SubscriptionBillingEmptySubscriptionCard(
            hasUncompletedSubscriptions: false,
            onBrowseSubscriptions: () => browsed = true,
          ),
        ),
      );

      await tester.tap(find.text('استعرض الاشتراكات'));
      await tester.pumpAndSettle();
      expect(browsed, isTrue);
    });

    testWidgets('renders box illustration when hasUncompletedSubscriptions is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const SubscriptionBillingEmptySubscriptionCard(
            hasUncompletedSubscriptions: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('لا يوجد اشتراك نشط'), findsOneWidget);

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final imageWidget = tester.widget<Image>(imageFinder);
      expect(
        (imageWidget.image as AssetImage).assetName,
        Assets.billingEmptySubscriptionBox,
      );
    });

    testWidgets('renders English strings correctly in LTR', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('en'),
          textDirection: TextDirection.ltr,
          child: const SubscriptionBillingEmptySubscriptionCard(
            hasUncompletedSubscriptions: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No active subscription'), findsOneWidget);
      expect(
        find.text(
          "You haven't subscribed to any package yet.\nChoose the right package and start your healthy journey.",
        ),
        findsOneWidget,
      );
      expect(find.text('Explore Subscriptions'), findsOneWidget);
    });
  });

  group('SubscriptionBillingEmptyInvoicesCard', () {
    testWidgets('renders invoice illustration and texts', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(child: const SubscriptionBillingEmptyInvoicesCard()),
      );
      await tester.pumpAndSettle();

      expect(find.text('لا يوجد فواتير بعد'), findsOneWidget);
      expect(
        find.text('ستظهر فواتير اشتراكك هنا بعد إتمام أول عملية دفع.'),
        findsOneWidget,
      );

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final imageWidget = tester.widget<Image>(imageFinder);
      expect(
        (imageWidget.image as AssetImage).assetName,
        Assets.billingEmptyInvoices,
      );
    });
  });

  group('SubscriptionBillingInvoiceHistoryCard integration', () {
    testWidgets('renders empty card when invoices list is empty', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const SubscriptionBillingInvoiceHistoryCard(invoices: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الفواتير'), findsOneWidget);
      expect(find.byType(SubscriptionBillingEmptyInvoicesCard), findsOneWidget);
      expect(find.text('لا يوجد فواتير بعد'), findsOneWidget);
    });

    testWidgets('renders invoice rows when invoices list is not empty', (
      tester,
    ) async {
      const invoice = SubscriptionBillingInvoiceEntity(
        receiptId: 'REC-1',
        subscriptionId: 'SUB-1',
        invoiceNumber: 'INV-1001',
        paymentId: 'PAY-1',
        issuedAtUtc: '2025-05-15T12:00:00Z',
        amount: 29.99,
        currencyCode: 'KWD',
        status: 'paid',
        statusNameAr: 'مدفوع',
        gateway: 'knet',
        maskedCardNumber: '**** 1234',
        canDownload: true,
        downloadUnavailableReason: '',
      );

      await tester.pumpWidget(
        buildTestWidget(
          child: const SubscriptionBillingInvoiceHistoryCard(invoices: [invoice]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الفواتير'), findsOneWidget);
      expect(find.byType(SubscriptionBillingEmptyInvoicesCard), findsNothing);
      expect(find.text('INV-1001'), findsOneWidget);
      expect(find.text('29.99 KWD'), findsOneWidget);
      expect(find.text('مدفوع'), findsOneWidget);
    });
  });
}
