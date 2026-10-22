import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/custom_app_button.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_hold_clock.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_hold_notice.dart';

void main() {
  for (final locale in [const Locale('en'), const Locale('ar')]) {
    testWidgets(
      'hold expiry blocks payment and offers renewal in ${locale.languageCode}',
      (tester) async {
        var elapsed = Duration.zero;
        var blocked = false;
        var renewals = 0;
        final clock = PaymentHoldClock(
          expiresAtUtc: DateTime.utc(2026, 10, 21, 12, 15),
          serverTimeUtc: DateTime.utc(2026, 10, 21, 12),
          elapsed: () => elapsed,
        );
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: PaymentHoldNotice(
                clock: clock,
                onExpired: () => blocked = true,
                onRenew: () => renewals++,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(CustomAppButton), findsNothing);
        elapsed = const Duration(minutes: 15);
        await tester.pump(const Duration(seconds: 1));
        expect(blocked, true);
        expect(find.byType(CustomAppButton), findsOneWidget);
        await tester.tap(find.byType(CustomAppButton));
        expect(renewals, 1);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
