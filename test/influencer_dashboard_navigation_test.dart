import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/bottom_nav_bar.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_dashboard_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_share_links_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_social_connections_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_wallet_screen.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_activity_tile.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_header_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_hero_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_share_prompt_card.dart';

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

  testWidgets(
    'influencer dashboard keeps figma physical left and right positions in rtl',
    (tester) async {
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

      final screenCenter =
          tester.getSize(find.byType(Scaffold).first).width / 2;
      final notificationCenter = tester.getCenter(
        find
            .descendant(
              of: find.byType(InfluencerHeaderCard),
              matching: find.byType(SvgPicture),
            )
            .first,
      );
      final profileTabCenter = tester.getCenter(
        find.byKey(const ValueKey('influencer-tab-profile')),
      );
      final homeTabCenter = tester.getCenter(
        find.byKey(const ValueKey('influencer-tab-home')),
      );

      expect(notificationCenter.dx, lessThan(screenCenter));
      expect(profileTabCenter.dx, lessThan(screenCenter));
      expect(homeTabCenter.dx, greaterThan(screenCenter));
    },
  );

  testWidgets(
    'influencer activity tile keeps amount left avatar right and verified badge in rtl',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 359,
                child: InfluencerActivityTile(
                  activity: InfluencerActivityEntity(
                    title: 'User #gdf55',
                    subtitle: 'subscribed to monthly package',
                    amount: '+5 KWD',
                    time: '2 hours ago',
                    avatarAsset: AssetsFake.influencerDashboardAvatar,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final tileCenter = tester.getCenter(find.byType(InfluencerActivityTile));
      final amountCenter = tester.getCenter(find.text('+5 KWD'));
      final avatarCenter = tester.getCenter(find.byType(Image));

      expect(amountCenter.dx, lessThan(tileCenter.dx));
      expect(avatarCenter.dx, greaterThan(tileCenter.dx));
      expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'influencer share prompt matches figma positions and circular share action in rtl',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 359,
                child: InfluencerSharePromptCard(
                  title: 'Share your link and code',
                  subtitle: 'Earn more commissions',
                  codeTitle: 'Your discount code',
                  code: 'AMMAR20',
                  shareIconAsset: AssetsFake.influencerShareIcon,
                  copyIconAsset: AssetsFake.influencerCopyIcon,
                ),
              ),
            ),
          ),
        ),
      );

      final cardCenter = tester.getCenter(
        find.byType(InfluencerSharePromptCard),
      );
      final codeCenter = tester.getCenter(find.text('AMMAR20'));
      final titleCenter = tester.getCenter(
        find.text('Share your link and code'),
      );
      final shareCircle = tester.widget<Container>(
        find.byKey(const ValueKey('influencer-share-action-circle')),
      );
      final shareCircleCenter = tester.getCenter(
        find.byKey(const ValueKey('influencer-share-action-circle')),
      );
      final shareCircleDecoration = shareCircle.decoration as BoxDecoration;

      expect(codeCenter.dx, lessThan(cardCenter.dx));
      expect(titleCenter.dx, greaterThan(cardCenter.dx));
      expect(shareCircleCenter.dx, greaterThan(titleCenter.dx));
      expect(shareCircleDecoration.shape, BoxShape.circle);
    },
  );
}
