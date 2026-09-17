import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import '../models/influencer_analytics_view_data.dart';

class InfluencerStatisticsSummaryCard extends StatelessWidget {
  const InfluencerStatisticsSummaryCard({
    super.key,
    required this.summary,
    required this.points,
  });

  final InfluencerAnalyticsSummaryViewData summary;
  final List<InfluencerAnalyticsPointViewData> points;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.influencerStatsSummaryHeight,
      padding: const EdgeInsets.all(
        Spacing.influencerStatsSummaryContentPadding,
      ),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(
          Spacing.influencerStatsSummaryRadius,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: LineChart(
              _chartData(color),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: Spacing.influencerStatsSummaryPillWidth,
                  height: Spacing.influencerStatsSummaryPillHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.onPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(
                      Spacing.influencerStatsSummaryPillRadius,
                    ),
                    border: Border.all(
                      color: color.onPrimary.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    summary.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onPrimary,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Spacing.xs),
                        child: Text(
                          summary.currency,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size16,
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: Spacing.xs),

                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          summary.value,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size33,
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        summary.growthPercent,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.inversePrimary,
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),
                      SvgPicture.asset(
                        AssetsFake.influencerTrendUp,
                        width: Spacing.influencerHeroTrendIconSize,
                        height: Spacing.influencerHeroTrendIconSize,
                      ),

                      const SizedBox(width: Spacing.sm),

                      Container(
                        width: Spacing.influencerStatsSummaryGainWidth,
                        height: Spacing.influencerStatsSummaryGainHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color.tertiary,
                          borderRadius: BorderRadius.circular(
                            Spacing.influencerStatsSummaryGainRadius,
                          ),
                        ),
                        child: Text(
                          summary.gain,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  summary.comparisonLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _chartData(ColorScheme color) {
    return LineChartData(
      minY: 0,
      maxY: 300,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 100,
        getDrawingHorizontalLine: (_) => FlLine(
          color: color.onPrimary.withValues(alpha: 0.16),
          strokeWidth: Spacing.hairline,
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: Spacing.xxl,
            interval: 100,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              meta: meta,
              space: Spacing.xs,
              child: Text(
                value.toInt().toString(),
                maxLines: 1,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onPrimary,
                ),
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: Spacing.xxl,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= points.length) {
                return const SizedBox.shrink();
              }

              final step = (points.length / 4).ceil().clamp(1, points.length);
              final isReadableInterval =
                  index % step == 0 || index == points.length - 1;
              if (!isReadableInterval) {
                return const SizedBox.shrink();
              }

              return SideTitleWidget(
                meta: meta,
                space: Spacing.xs,
                child: Text(
                  points[index].label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onPrimary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      lineTouchData: const LineTouchData(enabled: false),
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (var index = 0; index < points.length; index++)
              FlSpot(index.toDouble(), points[index].value),
          ],
          isCurved: true,
          barWidth: Spacing.xs,
          color: color.inversePrimary,
          dotData: FlDotData(
            show: points.length <= 7,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: Spacing.xs,
                color: color.onPrimary,
                strokeWidth: Spacing.xs,
                strokeColor: color.inversePrimary,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: color.inversePrimary.withValues(alpha: 0.14),
          ),
        ),
      ],
    );
  }
}
