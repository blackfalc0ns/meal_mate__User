import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionSummarySkeletonCard extends StatelessWidget {
  const SubscriptionSummarySkeletonCard({
    super.key,
    required this.height,
    this.width,
  });

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ShimmerWidget(
      baseColor: color.surfaceContainerHighest,
      highlightColor: color.surface,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(Spacing.radiusLg),
        ),
      ),
    );
  }
}
