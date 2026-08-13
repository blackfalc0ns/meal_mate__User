import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/wallet/data/wallet_fake_data_source.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_action_button.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_info_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_recent_transactions_section.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_security_note.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final wallet = const WalletFakeDataSource().loadWallet();

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.wallet_title,
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
                  title: locale.wallet_total_refundable_balance_title,
                  amount: wallet.totalBalance,
                  currency: wallet.currency,
                  subtitle: locale.wallet_total_refundable_balance_subtitle,
                ),
                const SizedBox(height: Spacing.lg),
                Row(
                  children: [
                   
                    Expanded(
                      child: WalletActionButton(
                        label: locale.wallet_refund_to_card,
                        icon: Icons.credit_card_rounded,
                        filled: true,
                        onTap: () => context.pushNamed(AppRoutes.walletRefund),
                      ),
                    ),
                    const SizedBox(width: Spacing.walletActionGap),

                     Expanded(
                      child: WalletActionButton(
                        label: locale.wallet_transactions_history,
                        icon: Icons.description_rounded,
                        onTap: () =>
                            context.pushNamed(AppRoutes.walletTransactions),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.lg),
                WalletInfoCard(
                  title: locale.wallet_important_info_title,
                  body: locale.wallet_important_info_body,
                ),
                const SizedBox(height: Spacing.lg),
                WalletRecentTransactionsSection(
                  transactions: wallet.transactions,
                ),
                const SizedBox(height: Spacing.lg),
                const WalletSecurityNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
