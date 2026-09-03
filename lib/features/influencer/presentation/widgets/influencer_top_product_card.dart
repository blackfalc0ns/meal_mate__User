import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';

class InfluencerTopProductCard extends StatelessWidget {
  const InfluencerTopProductCard({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.product,
  });

  final String title;
  final String actionLabel;
  final InfluencerTopProductEntity product;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.influencerStatsTopProductHeight,
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.influencerStatsTopProductRadius,
        ),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                actionLabel,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size7,
                  color: color.primary,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Container(
            height: Spacing.influencerStatsTopProductInnerHeight,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(
                Spacing.influencerStatsTopProductInnerRadius,
              ),
              border: Border.all(color: color.outlineVariant),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.revenueLabel,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size7,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      product.revenue,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.onSurface,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.name,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size7,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      children: [
                        Text(
                          product.ordersLabel,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size6,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          product.orders,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size8,
                            color: color.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: Spacing.xxl),
                Container(
                  width: Spacing.influencerStatsTopProductRankSize,
                  height: Spacing.influencerStatsTopProductRankSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.primaryContainer,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                  child: Text(
                    product.rank,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
