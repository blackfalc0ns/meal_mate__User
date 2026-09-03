import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/data/influencer_fake_data_source.dart';
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
    final selectedPeriodData =
        statistics.periodData[_selectedPeriodIndex.clamp(
          0,
          statistics.periodData.length - 1,
        )];

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.influencer_statistics,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
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
              summary: selectedPeriodData.summary,
              points: selectedPeriodData.revenuePoints,
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              locale.influencer_overview,

              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.md),
            InfluencerMetricsGrid(metrics: selectedPeriodData.overviewMetrics),
            const SizedBox(height: Spacing.lg),
            InfluencerStatisticsChartCard(
              title: locale.influencer_revenue_growth,
              legendLabel: locale.influencer_earnings_label,
              filterLabel: locale.influencer_daily,
              bars: selectedPeriodData.revenueBars,
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
