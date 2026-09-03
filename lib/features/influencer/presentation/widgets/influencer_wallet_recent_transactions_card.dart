import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_wallet_transaction_row.dart';

class InfluencerWalletRecentTransactionsCard extends StatelessWidget {
  const InfluencerWalletRecentTransactionsCard({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.transactions,
    required this.onActionTap,
  });

  final String title;
  final String actionLabel;
  final List<InfluencerTransactionEntity> transactions;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.influencerWalletRecentTransactionsHeight,
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.influencerWalletRecentTransactionsPaddingH,
        top: Spacing.influencerWalletRecentTransactionsPaddingTop,
        end: Spacing.influencerWalletRecentTransactionsPaddingH,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.influencerWalletSectionCardRadius,
        ),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            blurRadius: Spacing.lg,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onActionTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.primary,
                      ),
                    ),

                    Icon(
                      Icons.chevron_right_rounded,
                      color: color.primary,
                      size: Spacing.iconSm,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Divider(color: color.outlineVariant, height: Spacing.hairline),
          const SizedBox(height: Spacing.sm),
          for (var index = 0; index < transactions.length; index++) ...[
            InfluencerWalletTransactionRow(transaction: transactions[index]),
            if (index < transactions.length - 1) ...[
              const SizedBox(height: Spacing.sm),
              Divider(color: color.outlineVariant, height: Spacing.hairline),
              const SizedBox(height: Spacing.sm),
            ],
          ],
        ],
      ),
    );
  }
}
