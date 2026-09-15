import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import '../manager/influencer_analytics_event.dart';
import '../manager/influencer_analytics_state.dart';
import '../manager/influencer_analytics_view_model.dart';
import '../models/influencer_analytics_view_data.dart';
import '../widgets/influencer_period_filter_strip.dart';
import '../widgets/influencer_statistics_chart_card.dart';
import '../widgets/influencer_statistics_summary_card.dart';
import '../widgets/influencer_top_product_card.dart';

class InfluencerStatisticsScreen extends StatelessWidget {
  const InfluencerStatisticsScreen({super.key});
  static const _periodValues = ['7d', '30d', '90d', 'all'];
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider(
      create: (_) =>
          getIt<InfluencerAnalyticsViewModel>()
            ..doIntent(const LoadInfluencerAnalyticsEvent()),
      child: BlocBuilder<InfluencerAnalyticsViewModel, InfluencerAnalyticsState>(
        builder: (context, state) {
          if (state.isLoading && state.analytics == null) {
            return Center(
              child: CircularProgressIndicator(color: color.primary),
            );
          }
          if (state.failure != null && state.analytics == null) {
            return ApiErrorWidget(
              exception: state.failure!.exception,
              onRetry: () =>
                  context.read<InfluencerAnalyticsViewModel>().doIntent(
                    LoadInfluencerAnalyticsEvent(
                      period: state.period,
                      forceRefresh: true,
                    ),
                  ),
            );
          }
          final analytics = state.analytics;
          if (analytics == null) return const SizedBox.shrink();
          final periods = [
            locale.influencer_period_7_days,
            locale.influencer_period_30_days,
            locale.influencer_period_90_days,
            locale.influencer_period_year,
          ];
          final selectedIndex = _periodValues
              .indexOf(state.period)
              .clamp(0, _periodValues.length - 1);
          final points = analytics.earningsChart
              .map(
                (item) => InfluencerAnalyticsPointViewData(
                  label: item.dateUtc?.toLocal().day.toString() ?? '',
                  value: item.amount,
                ),
              )
              .toList();
          final summary = InfluencerAnalyticsSummaryViewData(
            title: locale.influencer_total_earnings,
            value: analytics.totalEarnings.amount.toStringAsFixed(3),
            currency: analytics.currencyCode,
            gain: analytics.comparison.netCommissionChangePercentage
                .toStringAsFixed(1),
            growthPercent:
                '${analytics.comparison.netCommissionChangePercentage.toStringAsFixed(1)}%',
            comparisonLabel: locale.influencer_statistics_subtitle,
          );
          final top = analytics.topPackages.isEmpty
              ? null
              : analytics.topPackages.first;
          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.symmetric(
                vertical: Spacing.screenV,
                horizontal: Spacing.screenH,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.query_stats_rounded,
                        size: Spacing.influencerStatsTitleIconSize,
                        color: color.primary,
                      ),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: Text(
                          locale.influencer_statistics,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: color.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.lg),
                  InfluencerPeriodFilterStrip(
                    periods: periods,
                    selectedIndex: selectedIndex,
                    onSelected: (index) =>
                        context.read<InfluencerAnalyticsViewModel>().doIntent(
                          LoadInfluencerAnalyticsEvent(
                            period: _periodValues[index],
                          ),
                        ),
                  ),
                  const SizedBox(height: Spacing.md),
                  InfluencerStatisticsSummaryCard(
                    summary: summary,
                    points: points,
                  ),
                  const SizedBox(height: Spacing.lg),
                  InfluencerStatisticsChartCard(
                    title: locale.influencer_revenue_growth,
                    legendLabel: locale.influencer_earnings_label,
                    filterLabel: locale.influencer_daily,
                    bars: points,
                  ),
                  if (top != null) ...[
                    const SizedBox(height: Spacing.base),
                    InfluencerTopProductCard(
                      title: locale.influencer_top_products,
                      actionLabel: locale.influencer_view_all,
                      product: InfluencerTopProductViewData(
                        rank: '1',
                        name: top.nameAr.isNotEmpty ? top.nameAr : top.nameEn,
                        orders: top.orderCount.toString(),
                        ordersLabel: locale.influencer_orders_label,
                        revenueLabel: locale.influencer_product_revenue_label,
                        revenue:
                            '${top.totalCommission.toStringAsFixed(3)} ${analytics.currencyCode}',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
