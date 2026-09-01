import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_dashboard_screen.dart';

void main() {
  testWidgets('influencer dashboard wallet action opens influencer wallet', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          AppRoutes.influencerWallet: (_) =>
              const Scaffold(body: Text('influencer wallet route')),
        },
        home: const InfluencerDashboardScreen(),
      ),
    );

    await tester.tap(find.text('Earnings wallet'));
    await tester.pumpAndSettle();

    expect(find.text('influencer wallet route'), findsOneWidget);
  });
}
