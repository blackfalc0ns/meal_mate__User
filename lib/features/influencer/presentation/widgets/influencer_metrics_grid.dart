import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_metric_card.dart';

class InfluencerMetricsGrid extends StatelessWidget {
  const InfluencerMetricsGrid({super.key, required this.metrics});

  final List<InfluencerMetricEntity> metrics;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 88,
        crossAxisSpacing: Spacing.sm,
        mainAxisSpacing: Spacing.sm,
      ),
      itemBuilder: (context, index) =>
          InfluencerMetricCard(metric: metrics[index]),
    );
  }
}
