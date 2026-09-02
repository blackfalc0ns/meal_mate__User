import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/influencer/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_dashboard_bottom_tabs.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_header_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_hero_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_metrics_grid.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_recent_activities_section.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_share_prompt_card.dart';

class InfluencerDashboardScreen extends StatelessWidget {
  const InfluencerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dashboard = InfluencerFakeDataSource(locale).loadDashboard();

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.influencer_dashboard_title,
        titleFontSize: FontSize.size17,
        backgroundColor: color.surface,
        showShadow: false,
        showBackButton: false,
      ),
      bottomNavigationBar: const InfluencerDashboardBottomTabs(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.screenH,
            top: Spacing.md,
            end: Spacing.screenH,
            bottom: Spacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfluencerHeaderCard(
                userName: dashboard.userName,
                partnerLabel: dashboard.partnerLabel,
                avatarAsset: dashboard.avatarAsset,
                logoAsset: dashboard.logoAsset,
              ),
              const SizedBox(height: Spacing.md),
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
          ),
        ),
      ),
    );
  }
}
