import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class SubscriptionRestaurantCardSkeleton extends StatelessWidget {
  const SubscriptionRestaurantCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final placeholderColor = color.surfaceContainerHighest;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.monthlyRestaurantCardRadius,
        ),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.monthlyRestaurantCardBorderWidth,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardHeight = constraints.maxHeight;
          final logoSize = (cardHeight * 0.32).clamp(30.0, 48.0);
          final isCompact = cardHeight < 128;

          return ShimmerWidget(
            baseColor: placeholderColor,
            highlightColor: color.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  height: isCompact ? 20 : 24,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 7,
                        decoration: BoxDecoration(
                          color: placeholderColor,
                          borderRadius: BorderRadius.circular(
                            Spacing.radiusXs,
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.xxs),
                      Container(
                        width: 38,
                        height: 7,
                        decoration: BoxDecoration(
                          color: placeholderColor,
                          borderRadius: BorderRadius.circular(
                            Spacing.radiusXs,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36,
                  height: 8,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(Spacing.radiusXs),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: placeholderColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: Spacing.xxs),
                    Container(
                      width: 16,
                      height: 6,
                      decoration: BoxDecoration(
                        color: placeholderColor,
                        borderRadius: BorderRadius.circular(
                          Spacing.radiusXs,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: isCompact
                      ? 16.0
                      : Spacing.monthlyRestaurantCardMetaHeight,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
