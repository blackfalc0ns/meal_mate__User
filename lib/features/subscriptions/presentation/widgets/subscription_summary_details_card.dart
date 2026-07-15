import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_summary_value_tile.dart';

class SubscriptionSummaryDetailsCard extends StatelessWidget {
  const SubscriptionSummaryDetailsCard({super.key, required this.plan});

  final MonthlyPlanDetailsEntity plan;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final bulletTexts = [
      locale.subscription_summary_daily_meals,
      locale.subscription_summary_restaurants,
      locale.subscription_summary_quality,
      locale.subscription_summary_variety,
    ];
    final bulletTops = [
      Spacing.subscriptionSummaryBulletOneTop,
      Spacing.subscriptionSummaryBulletTwoTop,
      Spacing.subscriptionSummaryBulletThreeTop,
      Spacing.subscriptionSummaryBulletFourTop,
    ];

    return Semantics(
      label: locale.subscription_summary_title,
      child: SizedBox(
        width: Spacing.subscriptionSummaryDetailsWidth,
        height: Spacing.subscriptionSummaryDetailsHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: Spacing.subscriptionSummaryTitleLeft,
              top: Spacing.subscriptionSummaryTitleTop,
              width: Spacing.subscriptionSummaryTitleWidth,
              height: Spacing.subscriptionSummaryTitleHeight,
              child: Text(
                locale.subscription_summary_title,
                textAlign: TextAlign.center,
                style:
                    getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: Spacing.subscriptionSummaryTitleFontSize,
                      color: color.onSurface,
                    ).copyWith(
                      height:
                          Spacing.subscriptionSummaryTitleLineHeight /
                          Spacing.subscriptionSummaryTitleFontSize,
                    ),
              ),
            ),
            Positioned(
              left: 0,
              top: Spacing.subscriptionSummaryTopTileTop,
              child: SubscriptionSummaryValueTile(
                width: Spacing.subscriptionSummaryTileWidth,
                height: Spacing.subscriptionSummaryTopTileHeight,
                label: locale.subscription_summary_package_label,
                value: locale.subscription_four_meals_package,
                labelTop: Spacing.subscriptionSummaryTileLabelTop,
                valueTop: Spacing.subscriptionSummaryTileValueTop,
              ),
            ),
            Positioned(
              left: Spacing.subscriptionSummaryRightTileLeft,
              top: Spacing.subscriptionSummaryTopTileTop,
              child: SubscriptionSummaryValueTile(
                width: Spacing.subscriptionSummaryTileWidth,
                height: Spacing.subscriptionSummaryTopTileHeight,
                label: locale.subscription_summary_duration_label,
                value: locale.subscription_summary_duration_value,
                labelTop: Spacing.subscriptionSummaryTileLabelTop,
                valueTop: Spacing.subscriptionSummaryTileValueTop,
              ),
            ),
            Positioned(
              left: 0,
              top: Spacing.subscriptionSummaryClassificationTop,
              child: SubscriptionSummaryValueTile(
                width: Spacing.subscriptionSummaryDetailsWidth,
                height: Spacing.subscriptionSummaryTopTileHeight,
                label: locale.subscription_summary_restaurant_tier_label,
                value: locale.subscription_summary_restaurant_tier_value,
                labelTop: Spacing.subscriptionSummaryClassificationLabelTop,
                valueTop: Spacing.subscriptionSummaryClassificationValueTop,
              ),
            ),
            Positioned(
              left: 0,
              top: Spacing.subscriptionSummaryIncludesTop,
              width: Spacing.subscriptionSummaryDetailsWidth,
              height: Spacing.subscriptionSummaryIncludesHeight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color.outlineVariant,
                    width: Spacing.subscriptionSummaryCardBorder,
                  ),
                  borderRadius: BorderRadius.circular(
                    Spacing.subscriptionSummaryCardRadius,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: Spacing.subscriptionSummaryIncludesLabelTop,
                      left: 0,
                      right: 0,
                      height: Spacing.subscriptionSummaryLabelHeight,
                      child: Text(
                        locale.subscription_summary_includes_label,
                        textAlign: TextAlign.center,
                        style:
                            getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize:
                                  Spacing.subscriptionSummaryLabelFontSize,
                              color: color.onSurface,
                            ).copyWith(
                              height:
                                  Spacing.subscriptionSummaryLabelLineHeight /
                                  Spacing.subscriptionSummaryLabelFontSize,
                            ),
                      ),
                    ),
                    for (var index = 0; index < bulletTexts.length; index++)
                      Positioned(
                        top: bulletTops[index],
                        left: Spacing.subscriptionSummaryBulletLeft,
                        right: Spacing.subscriptionSummaryBulletRight,
                        height: Spacing.subscriptionSummaryBulletHeight,
                        child: Row(
                          children: [
                            Container(
                              width: Spacing.subscriptionSummaryBulletSize,
                              height: Spacing.subscriptionSummaryBulletSize,
                              decoration: BoxDecoration(
                                color: color.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(
                              width: Spacing.subscriptionSummaryBulletGap,
                            ),
                            Expanded(
                              child: Text(
                                bulletTexts[index],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    getRegularStyle(
                                      fontFamily:
                                          FontConstant.ibmPlexSansArabic,
                                      fontSize: Spacing
                                          .subscriptionSummaryBodyFontSize,
                                      color: color.inverseSurface,
                                    ).copyWith(
                                      height:
                                          Spacing
                                              .subscriptionSummaryBodyLineHeight /
                                          Spacing
                                              .subscriptionSummaryBodyFontSize,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: Spacing.subscriptionSummaryPriceTop,
              width: Spacing.subscriptionSummaryDetailsWidth,
              height: Spacing.subscriptionSummaryPriceHeight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color.outlineVariant,
                    width: Spacing.subscriptionSummaryCardBorder,
                  ),
                  borderRadius: BorderRadius.circular(
                    Spacing.subscriptionSummaryCardRadius,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: Spacing.subscriptionSummaryPriceLabelTop,
                      left: 0,
                      right: 0,
                      height: Spacing.subscriptionSummaryLabelHeight,
                      child: Text(
                        locale.subscription_summary_total_price_label,
                        textAlign: TextAlign.center,
                        style:
                            getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize:
                                  Spacing.subscriptionSummaryLabelFontSize,
                              color: color.onSurface,
                            ).copyWith(
                              height:
                                  Spacing.subscriptionSummaryLabelLineHeight /
                                  Spacing.subscriptionSummaryLabelFontSize,
                            ),
                      ),
                    ),
                    Positioned(
                      top: Spacing.subscriptionSummaryPriceValueTop,
                      left: Spacing.subscriptionSummaryPriceNumberLeft,
                      width: Spacing.subscriptionSummaryPriceNumberWidth,
                      height: Spacing.subscriptionSummaryPriceValueHeight,
                      child: Text(
                        plan.price,
                        textAlign: TextAlign.center,
                        style:
                            getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize:
                                  Spacing.subscriptionSummaryPriceFontSize,
                              color: color.primary,
                            ).copyWith(
                              height:
                                  Spacing.subscriptionSummaryPriceLineHeight /
                                  Spacing.subscriptionSummaryPriceFontSize,
                            ),
                      ),
                    ),
                    Positioned(
                      top: Spacing.subscriptionSummaryCurrencyTop,
                      left: Spacing.subscriptionSummaryCurrencyLeft,
                      width: Spacing.subscriptionSummaryCurrencyWidth,
                      height: Spacing.subscriptionSummaryLabelHeight,
                      child: Text(
                        plan.currency,
                        textAlign: TextAlign.center,
                        style:
                            getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize:
                                  Spacing.subscriptionSummaryLabelFontSize,
                              color: color.onSurface,
                            ).copyWith(
                              height:
                                  Spacing.subscriptionSummaryLabelLineHeight /
                                  Spacing.subscriptionSummaryLabelFontSize,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
