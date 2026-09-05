import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerWithdrawBalanceCard extends StatelessWidget {
  const InfluencerWithdrawBalanceCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    this.iconAsset,
  });

  final String title;
  final String amount;
  final String currency;
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final icon = iconAsset;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      amount,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size20,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      currency,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: Spacing.avatarSm + Spacing.sm,
            height: Spacing.avatarSm + Spacing.sm,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.primaryContainer,
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
            ),
            child: icon != null
                ? SvgPicture.asset(
                    icon,
                    width: Spacing.iconMd,
                    height: Spacing.iconMd,
                    colorFilter: ColorFilter.mode(
                      color.primary,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    Icons.account_balance_wallet_rounded,
                    color: color.primary,
                    size: Spacing.iconMd,
                  ),
          ),
        ],
      ),
    );
  }
}
