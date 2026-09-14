import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerWithdrawReviewHeroCard extends StatelessWidget {
  const InfluencerWithdrawReviewHeroCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
  });

  final String title;
  final String amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Spacing.influencerHeroRadius),
      child: Container(
        height: Spacing.influencerHeroHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.primary,
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.07),
              blurRadius: Spacing.xxl,
              offset: const Offset(0, Spacing.xs),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                AssetsFake.influencerWalletCardBg,
                fit: BoxFit.fill,
              ),
            ),
            PositionedDirectional(
              end: Spacing.base,
              top: Spacing.md,
              child: SvgPicture.asset(
                AssetsFake.influencerWalletIcon,
                width: Spacing.iconLg,
                height: Spacing.iconLg,
              ),
            ),
            PositionedDirectional(
              end: Spacing.lg,
              bottom: Spacing.base,
              child: SvgPicture.asset(
                AssetsFake.influencerWalletContactless,
                width: Spacing.influencerWalletBalanceDecorationWidth,
                height: Spacing.influencerWalletBalanceDecorationHeight,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: Spacing.xl,
                vertical: Spacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.onPrimary,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        amount,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size33,
                          color: color.onPrimary,
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        currency,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size18,
                          color: color.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
