import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import '../../domain/entities/influencer_dashboard_entity.dart';
import '../manager/influencer_dashboard_event.dart';
import '../manager/influencer_dashboard_state.dart';
import '../manager/influencer_dashboard_view_model.dart';
import '../widgets/influencer_share_banner.dart';
import '../widgets/influencer_share_discount_card.dart';
import '../widgets/influencer_share_links_loading_skeleton.dart';
import '../widgets/influencer_share_quick_stats_card.dart';
import '../widgets/influencer_share_referral_card.dart';
import '../widgets/influencer_share_social_tile.dart';
import '../../../social_links/presentation/manager/influencer_social_links_event.dart';
import '../../../social_links/presentation/manager/influencer_social_links_state.dart';
import '../../../social_links/presentation/manager/influencer_social_links_view_model.dart';
import '../../../social_links/presentation/widgets/influencer_social_title_section.dart';

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
          BlocConsumer<InfluencerDashboardViewModel, InfluencerDashboardState>(
            listenWhen: (previous, current) =>
                previous.failure != current.failure &&
                current.failure != null &&
                current.links != null,
            listener: (context, state) => CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.failure!,
              ),
            ),
            builder: (context, state) {
              return BlocProvider(
                create: (_) =>
                    getIt<InfluencerSocialLinksViewModel>()
                      ..doIntent(const LoadInfluencerSocialLinksEvent()),
                child:
                    BlocBuilder<
                      InfluencerSocialLinksViewModel,
                      InfluencerSocialLinksState
                    >(
                      builder: (context, socialState) {
                        final content = _content(context, state, socialState);
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
            },
          ),
    );
  }

  Widget _content(
    BuildContext context,
    InfluencerDashboardState state,
    InfluencerSocialLinksState socialState,
  ) {
    final locale = context.localization;
    if (state.isLoading && state.links == null) {
      return const InfluencerShareLinksLoadingSkeleton();
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
    final socialPlatforms = _socialPlatforms(context, socialState);
    final hasSocialLinks = socialPlatforms.isNotEmpty;
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
              qrData: links.qrCodeData.isNotEmpty
                  ? links.qrCodeData
                  : links.referralLink,
              copyIconAsset: AssetsFake.influencerCopyIcon,
            ),
            const SizedBox(height: Spacing.base),
            InfluencerShareReferralCard(
              shareLinks: view,
              copyIconAsset: AssetsFake.influencerCopyIcon,
            ),
            const SizedBox(height: Spacing.lg),
            if (socialPlatforms.isNotEmpty) ...[
              InfluencerSocialTitleSection(
                title: locale.influencer_share_now,
                subtitle: locale.influencer_share_links_body,
              ),
              const SizedBox(height: Spacing.sm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (
                      var index = 0;
                      index < socialPlatforms.length;
                      index++
                    ) ...[
                      InfluencerShareSocialTile(
                        platform: socialPlatforms[index],
                      ),
                      if (index < socialPlatforms.length - 1)
                        const SizedBox(width: Spacing.md),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: Spacing.lg),
            ],
            AppButton(
              height: 40,
              fontSize: FontSize.size12,
              text: hasSocialLinks
                  ? '${locale.influencer_social_edit} ${locale.influencer_social_connections_title}'
                  : locale.influencer_add_social_accounts,
              onPressed: () async {
                await Navigator.of(
                  context,
                ).pushNamed(AppRoutes.influencerSocialConnections);
                if (!context.mounted) return;
                context.read<InfluencerSocialLinksViewModel>().doIntent(
                  const LoadInfluencerSocialLinksEvent(forceRefresh: true),
                );
              },
            ),
            const SizedBox(height: Spacing.lg),
            InfluencerShareQuickStatsCard(shareLinks: view),
          ],
        ),
      ),
    );
  }

  List<InfluencerShareSocialPlatformEntity> _socialPlatforms(
    BuildContext context,
    InfluencerSocialLinksState state,
  ) {
    final locale = context.localization;
    final links = state.profile?.links;
    if (links == null) return const [];

    final platforms = <InfluencerShareSocialPlatformEntity>[];
    void addIfPresent(String? value, String label, String iconAsset) {
      if (value?.trim().isEmpty ?? true) return;
      platforms.add(
        InfluencerShareSocialPlatformEntity(label: label, iconAsset: iconAsset),
      );
    }

    addIfPresent(
      links.tiktok,
      locale.influencer_tiktok,
      AssetsFake.influencerSocialTiktok,
    );
    addIfPresent(
      links.instagram,
      locale.influencer_instagram,
      AssetsFake.influencerSocialInstagram,
    );
    addIfPresent(
      links.whatsapp,
      locale.influencer_whatsapp,
      AssetsFake.influencerSocialWhatsapp,
    );
    addIfPresent(
      links.telegram,
      locale.influencer_telegram,
      AssetsFake.influencerSocialTelegram,
    );
    addIfPresent(
      links.youtube,
      locale.influencer_youtube,
      AssetsFake.influencerSocialYoutube,
    );
    addIfPresent(
      links.snapchat,
      locale.influencer_snapchat,
      AssetsFake.influencerSocialSnapchat,
    );
    return platforms;
  }
}
