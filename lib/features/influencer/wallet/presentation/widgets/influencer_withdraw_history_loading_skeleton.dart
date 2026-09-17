import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class InfluencerWithdrawHistoryLoadingSkeleton extends StatelessWidget {
  const InfluencerWithdrawHistoryLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.screenH,
        top: Spacing.md,
        end: Spacing.screenH,
        bottom: Spacing.xxxl,
      ),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: Spacing.sm),
      itemBuilder: (_, _) => const ShimmerPlaceholder.rect(
        height: 72,
        borderRadius: Spacing.cardRadius,
      ),
    );
  }
}
