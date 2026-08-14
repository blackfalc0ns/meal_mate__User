import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionRestaurantDetailsLoadingSkeleton extends StatelessWidget {
  const SubscriptionRestaurantDetailsLoadingSkeleton({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final height = MediaQuery.sizeOf(context).height;

    return Semantics(
      label: locale.refresh,
      child: Scaffold(
        backgroundColor: color.surface,
        body: Stack(
          children: [
            const PositionedDirectional(
              top: Spacing.zero,
              start: Spacing.zero,
              end: Spacing.zero,
              height: Spacing.restaurantDetailsHeroHeight,
              child: ShimmerPlaceholder.rect(
                height: Spacing.restaurantDetailsHeroHeight,
                borderRadius: Spacing.zero,
              ),
            ),
            CustomBackButton(onPressed: onBack),
            PositionedDirectional(
              top: Spacing.restaurantDetailsSheetTop,
              start: Spacing.zero,
              end: Spacing.zero,
              bottom: Spacing.zero,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Spacing.restaurantDetailsSheetRadius),
                ),
                child: ColoredBox(
                  color: color.surface,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: height - Spacing.restaurantDetailsSheetTop,
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: Spacing.xl + Spacing.md,
                          end: Spacing.xl + Spacing.md,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: Spacing.lg),
                            const Center(
                              child: ShimmerPlaceholder.rect(
                                width: Spacing.restaurantDetailsHandleWidth,
                                height: Spacing.restaurantDetailsHandleHeight,
                                borderRadius: Spacing.radiusPill,
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            _restaurantHeader(),
                            const SizedBox(height: Spacing.lg),
                            const Divider(height: Spacing.border),
                            const SizedBox(height: Spacing.md),
                            _sourceSection(),
                            const SizedBox(height: Spacing.xxl),
                            _tabs(),
                            const SizedBox(height: Spacing.lg),
                            _mealCard(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _restaurantHeader() {
    return const Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerPlaceholder.circle(
          size: Spacing.restaurantDetailsHeaderLogoSize,
        ),
        SizedBox(width: Spacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerPlaceholder.rect(
                width: Spacing.xxxl * 3,
                height: Spacing.xl,
                borderRadius: Spacing.radiusPill,
              ),
              SizedBox(height: Spacing.sm),
              ShimmerPlaceholder.rect(
                height: Spacing.md,
                borderRadius: Spacing.radiusPill,
              ),
              SizedBox(height: Spacing.xs),
              ShimmerPlaceholder.rect(
                width: Spacing.xxxl * 4,
                height: Spacing.md,
                borderRadius: Spacing.radiusPill,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sourceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Align(
          alignment: AlignmentDirectional.centerEnd,
          child: ShimmerPlaceholder.rect(
            width: Spacing.xxxl * 3,
            height: Spacing.lg,
            borderRadius: Spacing.radiusPill,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (_) => const ShimmerPlaceholder.rect(
              width: Spacing.restaurantDetailsSourceCardWidth,
              height: Spacing.restaurantDetailsSourceCardHeight,
              borderRadius: Spacing.radiusSm,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerPlaceholder.rect(
              width: Spacing.xxxl * 1.4,
              height: Spacing.lg,
              borderRadius: Spacing.radiusPill,
            ),
            ShimmerPlaceholder.rect(
              width: Spacing.xxxl * 1.4,
              height: Spacing.lg,
              borderRadius: Spacing.radiusPill,
            ),
            ShimmerPlaceholder.rect(
              width: Spacing.xxxl * 1.4,
              height: Spacing.lg,
              borderRadius: Spacing.radiusPill,
            ),
          ],
        ),
        SizedBox(height: Spacing.xs),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: ShimmerPlaceholder.rect(
            width: Spacing.xxxl * 2,
            height: Spacing.border,
            borderRadius: Spacing.radiusPill,
          ),
        ),
      ],
    );
  }

  Widget _mealCard() {
    return const SizedBox(
      height: Spacing.restaurantDetailsMealCardHeight,
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          ShimmerPlaceholder.circle(size: Spacing.iconLg),
          SizedBox(width: Spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ShimmerPlaceholder.rect(
                  width: Spacing.xxxl * 3,
                  height: Spacing.xl,
                  borderRadius: Spacing.radiusPill,
                ),
                SizedBox(height: Spacing.md),
                ShimmerPlaceholder.rect(
                  height: Spacing.md,
                  borderRadius: Spacing.radiusPill,
                ),
                Spacer(),
                ShimmerPlaceholder.rect(
                  width: Spacing.xxxl * 3,
                  height: Spacing.lg,
                  borderRadius: Spacing.radiusPill,
                ),
              ],
            ),
          ),
          SizedBox(width: Spacing.md),
          ShimmerPlaceholder.rect(
            width: Spacing.restaurantDetailsMealImageSize,
            height: Spacing.restaurantDetailsMealImageSize,
            borderRadius: Spacing.radiusLg,
          ),
        ],
      ),
    );
  }
}
