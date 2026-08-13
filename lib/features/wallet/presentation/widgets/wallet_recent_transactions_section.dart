import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/wallet_entities.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_transaction_tile.dart';

class WalletRecentTransactionsSection extends StatelessWidget {
  const WalletRecentTransactionsSection({
    super.key,
    required this.transactions,
  });

  final List<WalletTransactionEntity> transactions;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final visibleTransactions = transactions.take(3).toList();

    return Column(
      children: [
        Row(
          children: [
            Text(
              locale.wallet_recent_transactions,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => context.pushNamed(AppRoutes.walletTransactions),
              child: Text(
                locale.wallet_view_all,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.surface,
            border: Border.all(color: color.outlineVariant),
            borderRadius: BorderRadius.circular(Spacing.walletRecentCardRadius),
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
              for (var index = 0; index < visibleTransactions.length; index++)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.base,
                      ),
                      child: WalletTransactionTile(
                        transaction: visibleTransactions[index],
                      ),
                    ),
                    if (index != visibleTransactions.length - 1)
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
