import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/influencer/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_action_tile.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_header_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_hero_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_metrics_grid.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_share_card.dart';

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
      ),
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
              ),
              const SizedBox(height: Spacing.base),
              InfluencerHeroCard(imageAsset: dashboard.heroImageAsset),
              const SizedBox(height: Spacing.base),
              Text(
                locale.influencer_statistics,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              InfluencerMetricsGrid(metrics: dashboard.metrics),
              const SizedBox(height: Spacing.base),
              Text(
                locale.influencer_tools,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              ...dashboard.actions.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: InfluencerActionTile(
                    action: action,
                    onTap: () =>
                        Navigator.of(context).pushNamed(action.routeName),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              InfluencerShareCard(
                title: locale.influencer_referral_code_title,
                subtitle: locale.influencer_referral_code_subtitle,
                code: locale.influencer_referral_code_value,
                imageAsset: dashboard.shareBannerAsset,
                qrAsset: dashboard.qrAsset,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
