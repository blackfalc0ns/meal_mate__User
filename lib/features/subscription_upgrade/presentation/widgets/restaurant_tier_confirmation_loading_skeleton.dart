import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class RestaurantTierConfirmationLoadingSkeleton extends StatelessWidget {
  const RestaurantTierConfirmationLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Semantics(
      label: locale.restaurant_tier_upgrade_confirm_title,
      child: Scaffold(
        appBar: CustomAppBar(
          elevation: Spacing.zero,
          title: locale.restaurant_tier_upgrade_confirm_title,
        ),
        body: const SafeArea(
          top: false,
          child: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.screenH),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    SizedBox(height: Spacing.lg),
                    // Hero card placeholder
                    ShimmerPlaceholder.rect(
                      height: 120,
                      borderRadius: Spacing.cardRadius,
                    ),
                    SizedBox(height: Spacing.lg),
                    // Quick comparison table placeholder
                    ShimmerPlaceholder.rect(
                      height: 140,
                      borderRadius: Spacing.cardRadius,
                    ),
                    SizedBox(height: Spacing.lg),
                    // Summary / Details card placeholder
                    ShimmerPlaceholder.rect(
                      height: 150,
                      borderRadius: Spacing.cardRadius,
                    ),
                    SizedBox(height: Spacing.lg),
                    // Payment selection placeholder
                    ShimmerPlaceholder.rect(
                      height: 90,
                      borderRadius: Spacing.cardRadius,
                    ),
                    SizedBox(height: Spacing.lg),
                    // Action buttons placeholder
                    ShimmerPlaceholder.rect(
                      height: Spacing.buttonHeight,
                      borderRadius: Spacing.radiusPill,
                    ),
                    SizedBox(height: Spacing.sm),
                    ShimmerPlaceholder.rect(
                      height: Spacing.buttonHeight,
                      borderRadius: Spacing.radiusPill,
                    ),
                    SizedBox(height: Spacing.xl),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
