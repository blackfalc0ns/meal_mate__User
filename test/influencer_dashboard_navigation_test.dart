import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations_ar.dart';
import 'package:meal_meat_user/features/influencer/analytics/presentation/widgets/influencer_period_filter_strip.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_activity_tile.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_hero_card.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_share_prompt_card.dart';

void main() {
  testWidgets('influencer hero renders provided backend values', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 300));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: InfluencerHeroCard(
            imageAsset: AssetsFake.influencerDashboardHero,
            trendIconAsset: AssetsFake.influencerTrendUp,
            totalEarnings: '917.250',
            currency: 'KWD',
            weeklyGain: '+42.500',
          ),
        ),
      ),
    );
    expect(find.text('917.250'), findsOneWidget);
    expect(find.text('KWD'), findsOneWidget);
    expect(find.text('+42.500'), findsOneWidget);
  });

  testWidgets('influencer period filters follow inherited direction', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: InfluencerPeriodFilterStrip(
            periods: [
              AppLocalizationsAr().influencer_period_year,
              AppLocalizationsAr().influencer_period_7_days,
            ],
            selectedIndex: 0,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    final first = tester.getCenter(
      find.text(AppLocalizationsAr().influencer_period_year),
    );
    final last = tester.getCenter(
      find.text(AppLocalizationsAr().influencer_period_7_days),
    );
    expect(first.dx, greaterThan(last.dx));
  });

  testWidgets('influencer activity tile preserves rtl visual positions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: InfluencerActivityTile(
            activity: InfluencerActivityEntity(
              title: 'CommissionEarned',
              subtitle: 'subscription-42',
              amount: '+5 KWD',
              time: '2026-09-14',
              avatarAsset: AssetsFake.influencerDashboardAvatar,
            ),
          ),
        ),
      ),
    );
    final center = tester.getCenter(find.byType(InfluencerActivityTile));
    expect(tester.getCenter(find.text('+5 KWD')).dx, lessThan(center.dx));
    expect(tester.getCenter(find.byType(Image)).dx, greaterThan(center.dx));
    expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
  });

  testWidgets('influencer share prompt preserves rtl visual positions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: InfluencerSharePromptCard(
            title: 'Share',
            subtitle: 'Earn',
            codeTitle: 'Code',
            code: 'SERVER20',
            shareIconAsset: AssetsFake.influencerShareIcon,
            copyIconAsset: AssetsFake.influencerCopyIcon,
          ),
        ),
      ),
    );
    final card = tester.getCenter(find.byType(InfluencerSharePromptCard));
    final action = find.byKey(const ValueKey('influencer-share-action-circle'));
    final decoration = tester.widget<Container>(action).decoration;
    expect(tester.getCenter(find.text('SERVER20')).dx, lessThan(card.dx));
    expect(tester.getCenter(find.text('Share')).dx, greaterThan(card.dx));
    expect((decoration as BoxDecoration).shape, BoxShape.circle);
  });
}
