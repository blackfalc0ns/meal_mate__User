import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/wallet/data/wallet_fake_data_source.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_filter_chip.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_info_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_search_filter_row.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_transaction_group.dart';

class WalletTransactionsScreen extends StatelessWidget {
  const WalletTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    const fakeDataSource = WalletFakeDataSource();
    final wallet = fakeDataSource.loadWallet();
    final today = wallet.transactions.take(3).toList();
    final week = fakeDataSource.loadWeeklyTransactions();
    final april = fakeDataSource.loadAprilTransactions();

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.wallet_transactions_history,
        titleFontSize: FontSize.size17,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: Spacing.xxxl),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            child: Column(
              children: [
                WalletBalanceCard(
                  title: locale.wallet_refundable_balance,
                  amount: wallet.refundableBalance,
                  currency: wallet.currency,
                  subtitle: locale.wallet_last_updated(wallet.lastUpdated),
                ),
                const SizedBox(height: Spacing.base),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      WalletFilterChip(
                        label: locale.wallet_filter_all,
                        selected: true,
                      ),
                      const SizedBox(width: Spacing.sm),
                      WalletFilterChip(
                        label: locale.wallet_filter_refunds,
                        selected: false,
                      ),
                      const SizedBox(width: Spacing.sm),
                      WalletFilterChip(
                        label: locale.wallet_filter_card_refund,
                        selected: false,
                      ),
                      const SizedBox(width: Spacing.sm),
                      WalletFilterChip(
                        label: locale.wallet_filter_settlements,
                        selected: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.base),
                const WalletSearchFilterRow(),
                const SizedBox(height: Spacing.lg),
                WalletTransactionGroup(
                  title: locale.wallet_group_today,
                  transactions: today,
                ),
                const SizedBox(height: Spacing.lg),
                WalletTransactionGroup(
                  title: locale.wallet_group_this_week,
                  transactions: week,
                ),
                const SizedBox(height: Spacing.lg),
                WalletTransactionGroup(
                  title: locale.wallet_group_april_2026,
                  transactions: april,
                ),
                const SizedBox(height: Spacing.lg),
                WalletInfoCard(
                  title: '',
                  body: locale.wallet_transactions_notice,
                  height: Spacing.walletNoticeHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
