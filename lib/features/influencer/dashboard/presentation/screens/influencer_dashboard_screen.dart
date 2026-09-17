import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import '../../domain/entities/influencer_dashboard_entity.dart';
import '../manager/influencer_dashboard_event.dart';
import '../manager/influencer_dashboard_state.dart';
import '../manager/influencer_dashboard_view_model.dart';
import '../widgets/influencer_dashboard_bottom_tabs.dart';
import '../widgets/influencer_dashboard_loading_skeleton.dart';
import '../widgets/influencer_header_card.dart';
import '../widgets/influencer_hero_card.dart';
import '../widgets/influencer_metrics_grid.dart';
import '../widgets/influencer_recent_activities_section.dart';
import '../widgets/influencer_share_prompt_card.dart';
import '../../../analytics/presentation/screens/influencer_statistics_screen.dart';
import '../../../social_links/presentation/screens/influencer_social_connections_screen.dart';
import '../../../wallet/presentation/screens/influencer_wallet_screen.dart';
import 'influencer_share_links_screen.dart';

class InfluencerDashboardScreen extends StatefulWidget {
  const InfluencerDashboardScreen({super.key});
  @override
  State<InfluencerDashboardScreen> createState() =>
      _InfluencerDashboardScreenState();
}

class _InfluencerDashboardScreenState extends State<InfluencerDashboardScreen> {
  var _selectedTab = InfluencerDashboardTabItem.home;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider(
      create: (_) =>
          getIt<InfluencerDashboardViewModel>()
            ..doIntent(const LoadInfluencerDashboardEvent()),
      child:
          BlocConsumer<InfluencerDashboardViewModel, InfluencerDashboardState>(
            listenWhen: (previous, current) =>
                previous.failure != current.failure &&
                current.failure != null &&
                current.home != null,
            listener: (context, state) => CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.failure!,
              ),
            ),
            builder: (context, state) {
              final home = state.home;
              return Scaffold(
                backgroundColor: color.surface,
                appBar: InfluencerHeaderCard(
                  userName: home?.influencerCode ?? '',
                  partnerLabel: locale.influencer_partner_label,
                  avatarAsset: AssetsFake.influencerDashboardAvatar,
                  logoAsset: AssetsFake.influencerLogo,
                ),
                bottomNavigationBar: InfluencerDashboardBottomTabs(
                  selectedTab: _selectedTab,
                  onTabSelected: (tab) {
                    if (tab != _selectedTab) setState(() => _selectedTab = tab);
                  },
                ),
                body: [
                  const InfluencerSocialConnectionsScreen(showScaffold: false),
                  const InfluencerStatisticsScreen(),
                  const InfluencerWalletScreen(showScaffold: false),
                  const InfluencerShareLinksScreen(showScaffold: false),
                  _home(context, state),
                ][_selectedTab.index],
              );
            },
          ),
    );
  }

  Widget _home(BuildContext context, InfluencerDashboardState state) {
    final locale = context.localization;
    if (state.isLoading && state.home == null) {
      return const InfluencerDashboardLoadingSkeleton();
    }
    if (state.failure != null && state.home == null) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () => context.read<InfluencerDashboardViewModel>().doIntent(
          const LoadInfluencerDashboardEvent(forceRefresh: true),
        ),
      );
    }
    final home = state.home;
    if (home == null) return const SizedBox.shrink();
    String formatDiff(num diff, {bool isPercent = false}) {
      final sign = diff >= 0 ? '+' : '';
      final formattedNumber = isPercent
          ? diff.toStringAsFixed(1)
          : diff.toString();
      final percentSuffix = isPercent ? '%' : '';
      return '${locale.influencer_this_week} $sign$formattedNumber$percentSuffix';
    }

    final metrics = [
      InfluencerMetricEntity(
        title: locale.influencer_referrals,
        value: home.kpis.registeredCustomers.toString(),
        subtitle: formatDiff(home.kpis.registeredCustomersDiff),
        iconAsset: AssetsFake.influencerMetricUsers,
        trendIconAsset: AssetsFake.influencerTrendUp,
      ),
      InfluencerMetricEntity(
        title: locale.influencer_completed_subscriptions,
        value: home.kpis.completedSubscriptions.toString(),
        subtitle: formatDiff(home.kpis.completedSubscriptionsDiff),
        iconAsset: AssetsFake.influencerMetricSubscriptions,
        trendIconAsset: AssetsFake.influencerTrendUp,
      ),
      InfluencerMetricEntity(
        title: locale.influencer_pending_withdrawals,
        value: home.kpis.linkClicks.toString(),
        subtitle: formatDiff(home.kpis.linkClicksDiff),
        iconAsset: AssetsFake.influencerMetricClicks,
        trendIconAsset: AssetsFake.influencerTrendUp,
      ),
      InfluencerMetricEntity(
        title: locale.influencer_conversion_rate,
        value: '${home.kpis.conversionRate.toStringAsFixed(2)}%',
        subtitle: formatDiff(home.kpis.conversionRateDiff, isPercent: true),
        iconAsset: AssetsFake.influencerMetricConversion,
        trendIconAsset: AssetsFake.influencerTrendUp,
      ),
    ];
    final activities = home.recentActivities
        .map(
          (item) => InfluencerActivityEntity(
            title: item.code,
            subtitle: item.referenceId ?? '',
            amount:
                '${item.commissionAmount.amount.toStringAsFixed(3)} ${item.commissionAmount.currency}',
            time: item.occurredAtUtc?.toLocal().toString() ?? '',
            avatarAsset: AssetsFake.influencerDashboardAvatar,
          ),
        )
        .toList();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfluencerHeroCard(
              imageAsset: AssetsFake.influencerDashboardHero,
              trendIconAsset: AssetsFake.influencerTrendUp,
              totalEarnings: home.totalCommissions.amount.toStringAsFixed(3),
              currency: home.totalCommissions.currency,
              weeklyGain:
                  '${home.thisWeekCommissionsDiff.amount >= 0 ? '+' : ''}${home.thisWeekCommissionsDiff.amount.toStringAsFixed(3)}',
            ),
            const SizedBox(height: Spacing.influencerMetricsTopGap),
            InfluencerMetricsGrid(metrics: metrics),
            const SizedBox(height: Spacing.base),
            InfluencerSharePromptCard(
              title: locale.influencer_share_code_title,
              subtitle: locale.influencer_referral_code_subtitle,
              codeTitle: locale.influencer_referral_code_title,
              code: home.influencerCode,
              shareIconAsset: AssetsFake.influencerShareIcon,
              copyIconAsset: AssetsFake.influencerCopyIcon,
            ),
            const SizedBox(height: Spacing.sm),
            InfluencerRecentActivitiesSection(
              title: locale.influencer_recent_activities,
              actionLabel: locale.influencer_view_all,
              activities: activities,
            ),
          ],
        ),
      ),
    );
  }
}
