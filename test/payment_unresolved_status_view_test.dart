import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_unresolved_status_view.dart';

void main() {
  Widget buildTestWidget({
    required Widget child,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('PaymentUnresolvedStatusView Tests', () {
    testWidgets('renders review state copy and contact support in English', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const PaymentUnresolvedStatusView(
            isReviewRequired: true,
            attemptHandle: 'pz-track-test-1',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Payment Under Review'), findsOneWidget);
      expect(
        find.text(
          'Payment requires support review. Do not start another payment for this request until the result is confirmed.',
        ),
        findsOneWidget,
      );
      expect(find.text('Reference: pz-track-test-1'), findsOneWidget);
      expect(find.text('Contact Support'), findsOneWidget);
    });

    testWidgets('renders review state copy and contact support in Arabic', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('ar'),
          child: const PaymentUnresolvedStatusView(
            isReviewRequired: true,
            attemptHandle: 'pz-track-test-ar',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('عملية الدفع قيد المراجعة'), findsOneWidget);
      expect(
        find.text(
          'عملية الدفع تحتاج مراجعة من الدعم. لا تبدأ عملية دفع أخرى لهذا الطلب حتى يتم تأكيد النتيجة.',
        ),
        findsOneWidget,
      );
      expect(find.text('المرجع: pz-track-test-ar'), findsOneWidget);
      expect(find.text('تواصل مع الدعم'), findsOneWidget);
    });

    testWidgets('renders pending state copy and check status button', (tester) async {
      bool statusChecked = false;
      await tester.pumpWidget(
        buildTestWidget(
          child: PaymentUnresolvedStatusView(
            isReviewRequired: false,
            attemptHandle: 'pz-track-pending-1',
            onCheckStatus: () {
              statusChecked = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Payment Pending'), findsOneWidget);
      expect(
        find.text(
          'Payment result is not confirmed yet. You can check the request status.',
        ),
        findsOneWidget,
      );
      expect(find.text('Reference: pz-track-pending-1'), findsOneWidget);
      expect(find.text('Check Status'), findsOneWidget);

      await tester.tap(find.text('Check Status'));
      expect(statusChecked, isTrue);
    });
  });
}
