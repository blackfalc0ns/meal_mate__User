import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_dashboard_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_share_links_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_social_connections_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_wallet_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_hero_card.dart';

void main() {
  testWidgets(
    'influencer dashboard matches figma sections and switches wallet tab',
    (tester) async {
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

      expect(find.byType(InfluencerDashboardScreen), findsOneWidget);
      expect(find.byType(InfluencerWalletScreen), findsOneWidget);
      expect(find.text('influencer wallet route'), findsNothing);
    },
  );

  testWidgets(
    'influencer bottom tabs switch local screens without navigation',
    (tester) async {
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
    },
  );

  testWidgets('influencer selected bottom tab uses influencer colors', (
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
        home: const InfluencerDashboardScreen(),
      ),
    );

    final selectedTab = find.byKey(const ValueKey('influencer-tab-home'));
    final selectedBackground = tester.widget<AnimatedContainer>(
      find.descendant(
        of: selectedTab,
        matching: find.byType(AnimatedContainer),
      ),
    );
    final selectedDecoration = selectedBackground.decoration as BoxDecoration;

    expect(selectedDecoration.color, AppTheme.lightTheme.colorScheme.primary);

    final selectedLabels = tester.widgetList<Text>(
      find.descendant(of: selectedTab, matching: find.byType(Text)),
    );
    expect(
      selectedLabels.any(
        (label) =>
            label.style?.color == AppTheme.lightTheme.colorScheme.onPrimary,
      ),
      isTrue,
    );
  });

  testWidgets(
    'influencer hero keeps physical content positions in ltr and rtl',
    (tester) async {
      Future<Offset> pumpHeroAndReadAmountOffset(Locale locale) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: Center(
                child: SizedBox(
                  width: 359,
                  child: InfluencerHeroCard(
                    imageAsset: AssetsFake.influencerDashboardHero,
                    trendIconAsset: AssetsFake.influencerTrendUp,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        return tester.getTopLeft(find.text('845'));
      }

      final rtlOffset = await pumpHeroAndReadAmountOffset(const Locale('ar'));
      final ltrOffset = await pumpHeroAndReadAmountOffset(const Locale('en'));

      expect(ltrOffset.dx, closeTo(rtlOffset.dx, 3));
      expect(ltrOffset.dy, rtlOffset.dy);
    },
  );
}
