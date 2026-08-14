import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class MonthlyPlanRestaurantsLoadingSkeleton extends StatelessWidget {
  const MonthlyPlanRestaurantsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Spacing.sm,
        crossAxisSpacing: Spacing.sm,
        childAspectRatio: 0.78,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return const ShimmerPlaceholder.rect(
          height: Spacing.xxxl * 3,
          borderRadius: Spacing.monthlyRestaurantCardRadius,
        );
      },
    );
  }
}
