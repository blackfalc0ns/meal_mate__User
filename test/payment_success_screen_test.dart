import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_success_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_next_step_banner.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_payment_confirmed_banner.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_action_buttons.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_hero_header.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_summary_card.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_top_bar.dart';

void main() {
  const testArgs = PaymentSuccessArgs(
    subscriptionId: 'sub-12345',
    packageName: 'باقة نمط حياة متوازن',
    durationDays: 30,
    durationLabel: '30 يوم',
    restaurantTier: 'المستوى الذهبي',
    paymentDate: '2024/09/20',
    startDate: '2024/09/21',
    endDate: '2024/10/21',
  );

  Widget createSubject({
    PaymentSuccessArgs? args,
    Locale locale = const Locale('ar'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PaymentSuccessScreen(args: args),
    );
  }

  group('PaymentSuccessScreen Tests', () {
    testWidgets('renders all Figma sections with provided arguments', (
      tester,
    ) async {
      await tester.pumpWidget(createSubject(args: testArgs));
      await tester.pumpAndSettle();

      // Top bar
      expect(find.byType(SubscriptionSuccessTopBar), findsOneWidget);

      // Hero header
      expect(find.byType(SubscriptionSuccessHeroHeader), findsOneWidget);

      // Summary card with details
      expect(find.byType(SubscriptionSuccessSummaryCard), findsOneWidget);
      expect(find.text('باقة نمط حياة متوازن'), findsOneWidget);
      expect(find.text('30 يوم'), findsOneWidget);
      expect(find.text('المستوى الذهبي'), findsOneWidget);
      expect(find.text('2024/09/20'), findsOneWidget);
      expect(find.text('2024/09/21'), findsOneWidget);
      expect(find.text('2024/10/21'), findsOneWidget);

      // Banners
      expect(find.byType(SubscriptionPaymentConfirmedBanner), findsOneWidget);
      expect(find.byType(SubscriptionNextStepBanner), findsOneWidget);

      // Action buttons
      expect(find.byType(SubscriptionSuccessActionButtons), findsOneWidget);
    });

    testWidgets('renders fallback localized content when args are null', (
      tester,
    ) async {
      await tester.pumpWidget(createSubject(args: null));
      await tester.pumpAndSettle();

      expect(find.byType(PaymentSuccessScreen), findsOneWidget);
      expect(find.byType(SubscriptionSuccessSummaryCard), findsOneWidget);
      expect(find.byType(SubscriptionSuccessActionButtons), findsOneWidget);
    });

    testWidgets('renders properly in English locale', (tester) async {
      await tester.pumpWidget(
        createSubject(args: testArgs, locale: const Locale('en')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PaymentSuccessScreen), findsOneWidget);
      expect(find.byType(SubscriptionSuccessTopBar), findsOneWidget);
      expect(find.byType(SubscriptionSuccessSummaryCard), findsOneWidget);
    });
  });
}
