import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/dashboard/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/screens/influencer_share_links_screen.dart';
import 'package:meal_meat_user/features/influencer/social_links/presentation/screens/influencer_social_connections_screen.dart';
import 'package:meal_meat_user/features/influencer/analytics/presentation/screens/influencer_statistics_screen.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/screens/influencer_wallet_screen.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_dashboard_bottom_tabs.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_header_card.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_hero_card.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_metrics_grid.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_recent_activities_section.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_share_prompt_card.dart';

class InfluencerDashboardScreen extends StatefulWidget {
  const InfluencerDashboardScreen({super.key});

  @override
  State<InfluencerDashboardScreen> createState() =>
      _InfluencerDashboardScreenState();
}

class _InfluencerDashboardScreenState extends State<InfluencerDashboardScreen> {
  var _selectedTab = InfluencerDashboardTabItem.home;

  void _selectTab(InfluencerDashboardTabItem tab) {
    if (tab == _selectedTab) return;
    setState(() => _selectedTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dashboard = InfluencerFakeDataSource(locale).loadDashboard();
    final homeTab = _buildHomeTab(context);
    final screens = [
      const InfluencerSocialConnectionsScreen(showScaffold: false),
      const InfluencerStatisticsScreen(),
      const InfluencerWalletScreen(showScaffold: false),
      const InfluencerShareLinksScreen(showScaffold: false),
      homeTab,
    ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: InfluencerHeaderCard(
        userName: dashboard.userName,
        partnerLabel: dashboard.partnerLabel,
        avatarAsset: dashboard.avatarAsset,
        logoAsset: dashboard.logoAsset,
      ),
      bottomNavigationBar: InfluencerDashboardBottomTabs(
        selectedTab: _selectedTab,
        onTabSelected: _selectTab,
      ),
      body: screens[_selectedTab.index],
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.screenH,
          top: Spacing.md,
          end: Spacing.screenH,
          bottom: Spacing.xxxl,
        ),
        child: _buildHomeContent(context),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    final locale = context.localization;
    final dashboard = InfluencerFakeDataSource(locale).loadDashboard();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfluencerHeroCard(
          imageAsset: dashboard.heroImageAsset,
          trendIconAsset: dashboard.trendIconAsset,
        ),
        const SizedBox(height: Spacing.influencerMetricsTopGap),
        InfluencerMetricsGrid(metrics: dashboard.metrics),
        const SizedBox(height: Spacing.base),
        InfluencerSharePromptCard(
          title: locale.influencer_share_code_title,
          subtitle: locale.influencer_referral_code_subtitle,
          codeTitle: locale.influencer_referral_code_title,
          code: locale.influencer_referral_code_value,
          shareIconAsset: dashboard.shareIconAsset,
          copyIconAsset: dashboard.copyIconAsset,
        ),
        const SizedBox(height: Spacing.sm),
        InfluencerRecentActivitiesSection(
          title: locale.influencer_recent_activities,
          actionLabel: locale.influencer_view_all,
          activities: dashboard.activities,
        ),
      ],
    );
  }
}
