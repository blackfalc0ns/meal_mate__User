import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/wallet_entities.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_amount_text.dart';

class WalletTransactionTile extends StatelessWidget {
  const WalletTransactionTile({super.key, required this.transaction});

  final WalletTransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isCompleted = transaction.status == WalletTransactionStatus.completed;
    final statusLabel = isCompleted
        ? locale.wallet_status_completed
        : locale.wallet_status_processing;
    final statusColor = isCompleted ? color.primary : color.inversePrimary;

    return SizedBox(
      height: Spacing.walletActionHeight,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            child: SizedBox.square(
              dimension: Spacing.walletTransactionIconBox,
              child: Icon(
                transaction.icon,
                color: color.primary,
                size: Spacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  transaction.date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.lg),
          SizedBox(
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                WalletAmountText(
                  amount: transaction.amount,
                  currency: transaction.currency,
                  amountFontSize: FontSize.size15,
                  currencyFontSize: FontSize.size10,
                  color: color.primary,
                ),
                const SizedBox(height: Spacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(Spacing.radiusXs),
                  ),
                  child: Text(
                    statusLabel,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: statusColor,
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
