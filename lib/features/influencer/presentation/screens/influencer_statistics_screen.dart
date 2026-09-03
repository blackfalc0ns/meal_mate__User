import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_header_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_period_filter_strip.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_statistics_chart_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_statistics_summary_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_top_product_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_metrics_grid.dart';

class InfluencerStatisticsScreen extends StatefulWidget {
  const InfluencerStatisticsScreen({super.key});

  @override
  State<InfluencerStatisticsScreen> createState() =>
      _InfluencerStatisticsScreenState();
}

class _InfluencerStatisticsScreenState
    extends State<InfluencerStatisticsScreen> {
  late int _selectedPeriodIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedPeriodIndex = InfluencerFakeDataSource(
      context.localization,
    ).loadDashboard().statistics.selectedPeriodIndex;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dashboard = InfluencerFakeDataSource(locale).loadDashboard();
    final statistics = dashboard.statistics;

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
            InfluencerHeaderCard(
              userName: dashboard.userName,
              partnerLabel: dashboard.partnerLabel,
              avatarAsset: dashboard.avatarAsset,
              logoAsset: dashboard.logoAsset,
            ),
            const SizedBox(height: Spacing.lg),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        locale.influencer_statistics,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        locale.influencer_statistics_subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Icon(
                  Icons.query_stats_rounded,
                  size: Spacing.influencerStatsTitleIconSize,
                  color: color.primary,
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            InfluencerPeriodFilterStrip(
              periods: statistics.periods,
              selectedIndex: _selectedPeriodIndex,
              onSelected: (index) {
                setState(() => _selectedPeriodIndex = index);
              },
            ),
            const SizedBox(height: Spacing.md),
            InfluencerStatisticsSummaryCard(
              summary: statistics.summary,
              points: statistics.revenuePoints,
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              locale.influencer_overview,
              textAlign: TextAlign.end,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.md),
            InfluencerMetricsGrid(metrics: statistics.overviewMetrics),
            const SizedBox(height: Spacing.lg),
            InfluencerStatisticsChartCard(
              title: locale.influencer_revenue_growth,
              legendLabel: locale.influencer_earnings_label,
              filterLabel: locale.influencer_daily,
              bars: statistics.revenueBars,
            ),
            const SizedBox(height: Spacing.base),
            InfluencerTopProductCard(
              title: locale.influencer_top_products,
              actionLabel: locale.influencer_view_all,
              product: statistics.topProduct,
            ),
          ],
        ),
      ),
    );
  }
}
