import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_dashboard_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_share_links_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_social_connections_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_wallet_screen.dart';

void main() {
  testWidgets('influencer dashboard matches figma sections and opens wallet', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          AppRoutes.influencerWallet: (_) =>
              const Scaffold(body: Text('influencer wallet route')),
        },
        home: const InfluencerDashboardScreen(),
      ),
    );

    expect(find.text('إجمالي العمولات'), findsOneWidget);
    expect(find.text('845'), findsOneWidget);
    expect(find.text('AMMAR20'), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.text('آخر النشاطات'), findsOneWidget);

    await tester.tap(find.text('المحفظة'));
    await tester.pumpAndSettle();

    expect(find.text('influencer wallet route'), findsOneWidget);
  });

  testWidgets('influencer bottom tabs navigate only influencer routes', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          AppRoutes.influencerDashboard: (_) =>
              const InfluencerDashboardScreen(),
          AppRoutes.influencerShareLinks: (_) =>
              const InfluencerShareLinksScreen(),
          AppRoutes.influencerSocialConnections: (_) =>
              const InfluencerSocialConnectionsScreen(),
          AppRoutes.influencerWallet: (_) => const InfluencerWalletScreen(),
        },
        home: const InfluencerDashboardScreen(),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('influencer-tab-links')));
    await tester.pumpAndSettle();
    expect(find.byType(InfluencerShareLinksScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('influencer-tab-profile')));
    await tester.pumpAndSettle();
    expect(find.byType(InfluencerSocialConnectionsScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('influencer-tab-wallet')));
    await tester.pumpAndSettle();
    expect(find.byType(InfluencerWalletScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('influencer-tab-home')));
    await tester.pumpAndSettle();
    expect(find.byType(InfluencerDashboardScreen), findsOneWidget);
  });
}
