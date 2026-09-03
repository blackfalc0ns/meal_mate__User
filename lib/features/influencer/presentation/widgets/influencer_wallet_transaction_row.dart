import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';

class InfluencerWalletTransactionRow extends StatelessWidget {
  const InfluencerWalletTransactionRow({super.key, required this.transaction});

  final InfluencerTransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: Spacing.influencerWalletTransactionRowHeight,
      child: Row(
        children: [
          Container(
            width: Spacing.influencerWalletTransactionIconSize,
            height: Spacing.influencerWalletTransactionIconSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: transaction.isDebit
                  ? color.errorContainer
                  : color.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction.isDebit
                  ? Icons.download_rounded
                  : Icons.account_tree_rounded,
              color: transaction.isDebit ? color.error : color.primary,
              size: Spacing.iconSm,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: transaction.isDebit ? color.error : color.primary,
                ),
              ),
              Text(
                transaction.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size7,
                  color: color.onSurfaceVariant,
                ),
              ),
              Text(
                transaction.date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size7,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
