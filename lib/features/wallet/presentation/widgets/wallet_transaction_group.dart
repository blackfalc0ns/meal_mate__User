import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/wallet_entities.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_transaction_tile.dart';

class WalletTransactionGroup extends StatelessWidget {
  const WalletTransactionGroup({
    super.key,
    required this.title,
    required this.transactions,
  });

  final String title;
  final List<WalletTransactionEntity> transactions;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size16,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(
              Spacing.walletTransactionGroupRadius,
            ),
            border: Border.all(color: color.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.08),
                offset: const Offset(0, Spacing.xs),
                blurRadius: Spacing.sm,
              ),
            ],
          ),
          child: Column(
            children: [
              for (var index = 0; index < transactions.length; index++)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.base,
                      ),
                      child: WalletTransactionTile(
                        transaction: transactions[index],
                      ),
                    ),
                    if (index != transactions.length - 1)
                      Divider(height: Spacing.border, color: color.outline),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
