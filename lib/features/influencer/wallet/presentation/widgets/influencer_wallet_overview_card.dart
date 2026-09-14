import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerWalletOverviewCard extends StatelessWidget {
  const InfluencerWalletOverviewCard({
    super.key,
    required this.availableTitle,
    required this.availableAmount,
    required this.totalTitle,
    required this.totalAmount,
    required this.currency,
  });

  final String availableTitle;
  final String availableAmount;
  final String totalTitle;
  final String totalAmount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Spacing.influencerHeroRadius),
      child: Container(
        height: Spacing.influencerWalletBalanceCardHeight,
        width: double.infinity,
        decoration: BoxDecoration(
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
            Positioned(
              left: Spacing.base,
              top: Spacing.md,
              child: SvgPicture.asset(
                AssetsFake.influencerWalletIcon,
                width: Spacing.influencerWalletBalanceIconSize,
                height: Spacing.influencerWalletBalanceIconSize,
              ),
            ),
            Positioned(
              right: Spacing.lg,
              bottom: Spacing.base,
              child: SvgPicture.asset(
                AssetsFake.influencerWalletContactless,
                width: Spacing.influencerWalletBalanceDecorationWidth,
                height: Spacing.influencerWalletBalanceDecorationHeight,
              ),
            ),
            Positioned(
              left: Spacing.xl,
              top: Spacing.influencerWalletBalanceInnerTop,
              right: Spacing.influencerWalletBalanceInnerTop * 2.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.ltr,
                    children: [
                      Flexible(
                        child: Text(
                          availableTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: color.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      SvgPicture.asset(
                        AssetsFake.influencerWalletEye,
                        width: Spacing.iconMd,
                        height: Spacing.iconMd,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Spacing.influencerWalletBalanceAmountHeight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        textDirection: TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            currency,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size25,
                              color: color.onPrimary,
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          Text(
                            availableAmount,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size69,
                              color: color.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: Spacing.xl,
              bottom: Spacing.base,
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  Text(
                    currency,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onPrimary,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    totalAmount,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size17,
                      color: color.onPrimary,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    totalTitle,
                    style: getLightStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onPrimary,
                    ),
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
