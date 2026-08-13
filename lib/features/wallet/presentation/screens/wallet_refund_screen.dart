import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/wallet/data/wallet_fake_data_source.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_card_option_tile.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_info_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_order_summary_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_primary_button.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_refund_amount_section.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_refund_hero_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_refund_mode_buttons.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_section_title.dart';

class WalletRefundScreen extends StatelessWidget {
  const WalletRefundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final wallet = const WalletFakeDataSource().loadWallet();
    final selectedCard = wallet.cards.firstWhere((card) => card.selected);

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.wallet_refund_to_card,
        titleFontSize: FontSize.size24,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: Spacing.xxxl),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.walletHorizontalPadding,
            ),
            child: Column(
              children: [
                WalletRefundHeroCard(
                  amount: wallet.refundableBalance,
                  currency: wallet.currency,
                ),
                const SizedBox(height: Spacing.xl),
                WalletSectionTitle(title: locale.wallet_select_card),
                const SizedBox(height: Spacing.sm),
                for (final card in wallet.cards) ...[
                  WalletCardOptionTile(card: card),
                  const SizedBox(height: Spacing.md),
                ],
                WalletRefundAmountSection(
                  amount: wallet.refundableBalance,
                  currency: wallet.currency,
                ),
                const SizedBox(height: Spacing.base),
                const WalletRefundModeButtons(),
                const SizedBox(height: Spacing.lg),
                WalletInfoCard(
                  title: '',
                  body: locale.wallet_refund_notice_body,
                  height: Spacing.walletNoticeHeight,
                ),
                const SizedBox(height: Spacing.lg),
                WalletSectionTitle(title: locale.wallet_order_summary_title),
                const SizedBox(height: Spacing.sm),
                WalletOrderSummaryCard(
                  amount: wallet.refundableBalance,
                  currency: wallet.currency,
                  cardDigits: selectedCard.lastDigits,
                ),
                const SizedBox(height: Spacing.base),
                WalletPrimaryButton(
                  label: locale.wallet_confirm_refund,
                  onPressed: () {},
                ),
                const SizedBox(height: Spacing.md),
                WalletPrimaryButton(
                  label: locale.wallet_cancel,
                  filled: false,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
