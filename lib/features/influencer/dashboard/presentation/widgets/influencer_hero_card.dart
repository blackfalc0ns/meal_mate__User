import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerHeroCard extends StatelessWidget {
  const InfluencerHeroCard({
    super.key,
    required this.imageAsset,
    required this.trendIconAsset,
    required this.totalEarnings,
    required this.currency,
    required this.weeklyGain,
  });

  final String imageAsset;
  final String trendIconAsset;
  final String totalEarnings;
  final String currency;
  final String weeklyGain;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Spacing.influencerHeroRadius),
      child: SizedBox(
        height: Spacing.influencerHeroHeight,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(imageAsset, fit: BoxFit.cover)),
            Positioned(
              left: Spacing.influencerHeroContentStart,
              top: Spacing.influencerHeroContentTop,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.influencer_total_earnings,
                    textAlign: TextAlign.end,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.onPrimary,
                    ),
                  ),
                  const SizedBox(height: Spacing.xss),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: Spacing.influencerHeroCurrencyTop,
                        ),
                        child: Text(
                          currency,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size13,
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),

                      Text(
                        totalEarnings,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size30,
                          color: color.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  Row(
                    children: [
                      Container(
                        width: Spacing.influencerHeroGainWidth,
                        height: Spacing.influencerHeroGainHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color.primary,
                          borderRadius: BorderRadius.circular(
                            Spacing.influencerHeroGainRadius,
                          ),
                        ),
                        child: Text(
                          weeklyGain,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Text(
                        locale.influencer_this_week,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size8,
                          color: color.onPrimary,
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),
                      SvgPicture.asset(
                        trendIconAsset,
                        width: Spacing.influencerHeroTrendIconSize,
                        height: Spacing.influencerHeroTrendIconSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: Spacing.lg,
              bottom: Spacing.sm,
              child: Container(
                width: Spacing.influencerHeroDetailsWidth,
                height: Spacing.influencerHeroDetailsHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(
                    Spacing.influencerHeroDetailsRadius,
                  ),
                ),
                child: Text(
                  locale.influencer_view_details,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size8,
                    color: color.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
