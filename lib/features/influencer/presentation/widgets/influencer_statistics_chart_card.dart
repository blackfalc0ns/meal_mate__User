import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';

class InfluencerStatisticsChartCard extends StatelessWidget {
  const InfluencerStatisticsChartCard({
    super.key,
    required this.title,
    required this.legendLabel,
    required this.filterLabel,
    required this.bars,
  });

  final String title;
  final String legendLabel;
  final String filterLabel;
  final List<InfluencerChartPointEntity> bars;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.end,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Container(
          height: Spacing.influencerStatsChartCardHeight,
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(
              Spacing.influencerStatsChartCardRadius,
            ),
            border: Border.all(color: color.outlineVariant),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: Spacing.influencerStatsChartLegendDot,
                        height: Spacing.influencerStatsChartLegendDot,
                        decoration: BoxDecoration(
                          color: color.primary,
                          borderRadius: BorderRadius.circular(Spacing.radiusXs),
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        legendLabel,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size7,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: Spacing.influencerStatsChartFilterWidth,
                    height: Spacing.influencerStatsChartFilterHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(
                        Spacing.influencerStatsChartFilterRadius,
                      ),
                      border: Border.all(color: color.outlineVariant),
                    ),
                    child: Text(
                      filterLabel,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size7,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              Expanded(
                child: BarChart(
                  _chartData(color),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BarChartData _chartData(ColorScheme color) {
    return BarChartData(
      minY: 0,
      maxY: 300,
      alignment: BarChartAlignment.spaceAround,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 100,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: color.outlineVariant, strokeWidth: Spacing.hairline),
      ),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: Spacing.lg,
            interval: 100,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size6,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: Spacing.lg,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= bars.length) {
                return const SizedBox.shrink();
              }
              return Text(
                bars[index].label,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size6,
                  color: color.onSurfaceVariant,
                ),
              );
            },
          ),
        ),
      ),
      barGroups: [
        for (var index = 0; index < bars.length; index++)
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: bars[index].value,
                width: Spacing.xxl,
                color: color.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Spacing.radiusXs),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
