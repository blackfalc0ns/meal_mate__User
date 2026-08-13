import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/wallet_entities.dart';

class WalletCardOptionTile extends StatelessWidget {
  const WalletCardOptionTile({super.key, required this.card});

  final WalletCardEntity card;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.walletPaymentCardHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.walletPaymentCardRadius),
        border: Border.all(
          color: card.selected ? color.primary : color.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          if (card.selected)
            Icon(Icons.check_circle_rounded, color: color.primary)
          else
            const SizedBox(width: Spacing.iconMd),
          const SizedBox(width: Spacing.md),
          Text(
            card.brand == 'Visa' ? 'VISA' : '••',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size20,
              color: card.brand == 'Visa' ? color.primary : color.error,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '••••  ${card.lastDigits}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size20,
                    color: color.onSurface,
                  ),
                ),
                Text(
                  card.brand,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                locale.wallet_card_expires_at,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: card.selected ? color.primary : color.onSurface,
                ),
              ),
              Text(
                card.expiresAt,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
