import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_deal_countdown_bar.dart';

Widget buildTestApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('ar'),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('OfferDealCountdownBar displays and counts down', (tester) async {
    final now = DateTime.now().toUtc();
    final endsAt = now.add(const Duration(seconds: 10));

    await tester.pumpWidget(
      buildTestApp(
        OfferDealCountdownBar(
          endsAt: endsAt,
          serverNowUtc: now,
          serverObservedAtUtc: now,
          accentColor: Colors.green,
          onAccentColor: Colors.white,
        ),
      ),
    );

    expect(find.text('ينتهي خلال'), findsOneWidget);
    expect(find.text('00:00:10'), findsOneWidget);

    // Advance 1 second
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:00:09'), findsOneWidget);

    // Advance another 2 seconds
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:00:07'), findsOneWidget);
  });

  testWidgets('OfferDealCountdownBar displays promo code when no timer', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const OfferDealCountdownBar(
          endsAt: null,
          promoCode: 'SAVE20',
          accentColor: Colors.orange,
          onAccentColor: Colors.white,
        ),
      ),
    );

    expect(find.text('كود الخصم'), findsOneWidget);
    expect(find.text('SAVE20'), findsOneWidget);
  });

  testWidgets('OfferDealCountdownBar displays days and hours when duration >= 1 day', (tester) async {
    final now = DateTime.now().toUtc();
    final endsAt = now.add(const Duration(days: 29, hours: 4));

    await tester.pumpWidget(
      buildTestApp(
        OfferDealCountdownBar(
          endsAt: endsAt,
          serverNowUtc: now,
          serverObservedAtUtc: now,
          accentColor: Colors.green,
          onAccentColor: Colors.white,
        ),
      ),
    );

    expect(find.text('ينتهي خلال'), findsOneWidget);
    expect(find.text('29 يوم : 04 س'), findsOneWidget);
  });
}
