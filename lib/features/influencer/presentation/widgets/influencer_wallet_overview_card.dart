import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
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
          gradient: LinearGradient(colors: [color.primary, color.tertiary]),
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
            Positioned(
              left: Spacing.base,
              top: Spacing.influencerWalletBalanceInnerTop,
              child: SizedBox(
                width: Spacing.influencerWalletBalanceInnerWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            availableTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size14,
                              color: color.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Icon(
                          Icons.visibility_outlined,
                          color: color.onPrimary,
                          size: Spacing.influencerWalletBalanceIconSize,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Spacing.influencerWalletBalanceAmountHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              availableAmount,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size69,
                                color: color.onPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            currency,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size25,
                              color: color.onPrimary,
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
              left: Spacing.xxl,
              top: Spacing.influencerWalletBalanceTotalTop,
              child: Row(
                children: [
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
                    currency,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
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
            Positioned(
              right: Spacing.xxl,
              bottom: Spacing.sm,
              child: Icon(
                Icons.payments_outlined,
                color: color.onPrimary,
                size: Spacing.influencerWalletBalanceDecorationHeight,
              ),
            ),
            Positioned(
              left: Spacing.base,
              top: Spacing.md,
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: color.onPrimary,
                size: Spacing.influencerWalletBalanceIconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
