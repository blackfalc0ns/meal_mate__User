import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_failed_args.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_failed_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/failed/payment_failed_action_buttons.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/failed/payment_failed_card.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/failed/payment_failed_hero_header.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/failed/payment_failed_info_box.dart';

void main() {
  Widget createSubject({
    PaymentFailedArgs? args,
    Locale locale = const Locale('ar'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PaymentFailedScreen(args: args),
    );
  }

  group('PaymentFailedScreen Tests', () {
    testWidgets('renders all Figma sections and components in Arabic', (
      tester,
    ) async {
      var retryCalled = false;
      var changeMethodCalled = false;
      var supportCalled = false;

      final testArgs = PaymentFailedArgs(
        onRetry: () => retryCalled = true,
        onChangePaymentMethod: () => changeMethodCalled = true,
        onContactSupport: () => supportCalled = true,
      );

      await tester.pumpWidget(createSubject(args: testArgs));
      await tester.pumpAndSettle();

      // Top bar
      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.text('فشل الدفع'), findsOneWidget);

      // Hero header
      expect(find.byType(PaymentFailedHeroHeader), findsOneWidget);

      // Card & Info box
      expect(find.byType(PaymentFailedCard), findsOneWidget);
      expect(find.text('تعذر إتمام الدفع'), findsOneWidget);
      expect(
        find.text(
          'فشل الدفع لسبب ما. يرجى إعادة المحاولة أو تغيير وسيلة الدفع',
        ),
        findsOneWidget,
      );
      expect(find.byType(PaymentFailedInfoBox), findsOneWidget);
      expect(find.text('لم تكتمل العملية'), findsOneWidget);
      expect(find.text('لم يتم خصم أي مبلغ من حسابك'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);

      // Action buttons
      expect(find.byType(PaymentFailedActionButtons), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
      expect(find.text('تغيير وسيلة الدفع'), findsOneWidget);
      expect(find.text('اتصل بالدعم'), findsOneWidget);

      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      expect(find.byIcon(Icons.credit_card_rounded), findsOneWidget);
      expect(find.byIcon(Icons.headset_mic_rounded), findsOneWidget);

      // Tap buttons to verify callbacks
      await tester.tap(find.text('إعادة المحاولة'));
      await tester.pumpAndSettle();
      expect(retryCalled, isTrue);

      await tester.tap(find.text('تغيير وسيلة الدفع'));
      await tester.pumpAndSettle();
      expect(changeMethodCalled, isTrue);

      await tester.tap(find.text('اتصل بالدعم'));
      await tester.pumpAndSettle();
      expect(supportCalled, isTrue);
    });

    testWidgets('renders properly in English locale', (tester) async {
      await tester.pumpWidget(createSubject(locale: const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.byType(PaymentFailedScreen), findsOneWidget);
      expect(find.text('Payment Failed'), findsOneWidget);
      expect(find.text('Payment Incomplete'), findsOneWidget);
      expect(find.text('Transaction Not Completed'), findsOneWidget);
      expect(
        find.text('No amount was deducted from your account'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Change Payment Method'), findsOneWidget);
      expect(find.text('Contact Support'), findsOneWidget);
    });
  });
}
