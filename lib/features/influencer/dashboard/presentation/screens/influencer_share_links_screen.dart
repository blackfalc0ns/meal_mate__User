import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import '../../domain/entities/influencer_dashboard_entity.dart';
import '../manager/influencer_dashboard_event.dart';
import '../manager/influencer_dashboard_state.dart';
import '../manager/influencer_dashboard_view_model.dart';
import '../widgets/influencer_share_banner.dart';
import '../widgets/influencer_share_discount_card.dart';
import '../widgets/influencer_share_quick_stats_card.dart';
import '../widgets/influencer_share_referral_card.dart';

class InfluencerShareLinksScreen extends StatelessWidget {
  const InfluencerShareLinksScreen({super.key, this.showScaffold = true});
  final bool showScaffold;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider(
      create: (_) =>
          getIt<InfluencerDashboardViewModel>()
            ..doIntent(const LoadInfluencerLinksEvent()),
      child:
          BlocBuilder<InfluencerDashboardViewModel, InfluencerDashboardState>(
            builder: (context, state) {
              final content = _content(context, state);
              if (!showScaffold) return content;
              return Scaffold(
                backgroundColor: color.surface,
                appBar: CustomAppBar(
                  title: locale.influencer_share_links_title,
                  titleFontSize: FontSize.size17,
                  backgroundColor: color.surface,
                  showShadow: false,
                ),
                body: content,
              );
            },
          ),
    );
  }

  Widget _content(BuildContext context, InfluencerDashboardState state) {
    final color = context.colorScheme;
    final locale = context.localization;
    if (state.isLoading && state.links == null) {
      return Center(child: CircularProgressIndicator(color: color.primary));
    }
    if (state.failure != null && state.links == null) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () => context.read<InfluencerDashboardViewModel>().doIntent(
          const LoadInfluencerLinksEvent(forceRefresh: true),
        ),
      );
    }
    final links = state.links;
    if (links == null) return const SizedBox.shrink();
    final view = InfluencerShareLinksEntity(
      title: locale.influencer_share_links_title,
      subtitle: locale.influencer_share_links_subtitle,
      bannerTitle: locale.influencer_share_links_header,
      bannerHighlight: '',
      bannerSubtitle: locale.influencer_share_links_body,
      bannerFooter: '',
      discountCodeTitle: locale.influencer_referral_code_title,
      discountCode: links.influencerCode,
      discountBadgePrefix: '',
      discountBadgeValue: '',
      discountBadgeSuffix: '',
      copyCodeLabel: locale.influencer_share_now,
      qrLabel: locale.influencer_share_now,
      referralLinkTitle: locale.influencer_share_links_title,
      referralLink: links.referralLink,
      copyLinkLabel: locale.influencer_share_now,
      shareNowTitle: locale.influencer_share_now,
      shareNowSubtitle: locale.influencer_share_links_subtitle,
      quickStatsTitle: locale.influencer_statistics,
      quickStatsSubtitle: locale.influencer_statistics_subtitle,
      socialPlatforms: const [],
      quickStats: [
        InfluencerShareQuickStatEntity(
          label: locale.influencer_referrals,
          value: links.kpis.registeredCustomers.toString(),
          iconAsset: AssetsFake.influencerQuickStatClicks,
        ),
        InfluencerShareQuickStatEntity(
          label: locale.influencer_completed_subscriptions,
          value: links.kpis.completedSubscriptions.toString(),
          iconAsset: AssetsFake.influencerQuickStatOrders,
        ),
        InfluencerShareQuickStatEntity(
          label: locale.influencer_conversion_rate,
          value: '${links.kpis.conversionRate.toStringAsFixed(2)}%',
          iconAsset: AssetsFake.influencerQuickStatConversion,
        ),
      ],
    );
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.screenH,
          top: Spacing.md,
          end: Spacing.screenH,
          bottom: Spacing.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfluencerShareBanner(
              shareLinks: view,
              imageAsset: AssetsFake.influencerShareBanner,
              trendIconAsset: AssetsFake.influencerTrendUp,
            ),
            const SizedBox(height: Spacing.base),
            InfluencerShareDiscountCard(
              shareLinks: view,
              qrAsset: AssetsFake.influencerQr,
              copyIconAsset: AssetsFake.influencerCopyIcon,
            ),
            const SizedBox(height: Spacing.base),
            InfluencerShareReferralCard(
              shareLinks: view,
              copyIconAsset: AssetsFake.influencerCopyIcon,
            ),
            const SizedBox(height: Spacing.lg),
            InfluencerShareQuickStatsCard(shareLinks: view),
          ],
        ),
      ),
    );
  }
}
