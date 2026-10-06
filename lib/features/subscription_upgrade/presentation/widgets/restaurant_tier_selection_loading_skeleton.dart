import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class RestaurantTierSelectionLoadingSkeleton extends StatelessWidget {
  const RestaurantTierSelectionLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Semantics(
      label: locale.restaurant_tier_upgrade_title,
      child: Scaffold(
        appBar: CustomAppBar(
          elevation: Spacing.zero,
          title: locale.restaurant_tier_upgrade_title,
        ),
        body: const SafeArea(
          top: false,
          child: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    SizedBox(height: Spacing.lg),
                    // Current subscription card placeholder
                    ShimmerPlaceholder.rect(
                      height: 120,
                      borderRadius: Spacing.cardRadius,
                    ),
                    SizedBox(height: Spacing.xxl),
                    // Section title placeholder
                    ShimmerPlaceholder.rect(
                      width: 140,
                      height: 20,
                      borderRadius: Spacing.radiusSm,
                    ),
                    SizedBox(height: Spacing.md),
                    // 2 Tier option card placeholders
                    ShimmerPlaceholder.rect(
                      height: 170,
                      borderRadius: Spacing.cardRadius,
                    ),
                    SizedBox(height: Spacing.md),
                    ShimmerPlaceholder.rect(
                      height: 170,
                      borderRadius: Spacing.cardRadius,
                    ),
                    SizedBox(height: Spacing.xl),
                  ]),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.screenH,
              vertical: Spacing.md,
            ),
            child: ShimmerPlaceholder.rect(
              height: Spacing.buttonHeight,
              borderRadius: Spacing.radiusPill,
            ),
          ),
        ),
      ),
    );
  }
}
