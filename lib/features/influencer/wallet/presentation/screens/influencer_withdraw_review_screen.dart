import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/dashboard/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_primary_button.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_review_details_card.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_review_hero_card.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_review_note_card.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_review_summary_card.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_title_block.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_top_bar.dart';

class InfluencerWithdrawReviewScreen extends StatelessWidget {
  const InfluencerWithdrawReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dashboard = InfluencerFakeDataSource(locale).loadDashboard();
    final wallet = dashboard.wallet;

    final formattedAmount = '${wallet.availableBalance}.000';
    final amountWithCurrency = '$formattedAmount ${wallet.currency}';

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.screenV,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfluencerWithdrawTopBar(
                userName: dashboard.userName,
                partnerLabel: dashboard.partnerLabel,
                avatarAsset: dashboard.avatarAsset,
                onBackTap: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: Spacing.base),
              InfluencerWithdrawTitleBlock(
                title: locale.influencer_withdraw_review_title,
                subtitle: locale.influencer_withdraw_review_subtitle,
              ),
              const SizedBox(height: Spacing.base),
              InfluencerWithdrawReviewHeroCard(
                title: locale.influencer_available_for_withdraw,
                amount: formattedAmount,
                currency: locale.currency,
              ),
              const SizedBox(height: Spacing.base),
              InfluencerWithdrawReviewDetailsCard(
                title: locale.influencer_transfer_details,
                methodLabel: locale.influencer_withdraw_method,
                methodValue: locale.influencer_bank_transfer,
                bankLabel: locale.influencer_bank_label,
                bankValue: wallet.bankAccount.bankName,
                accountHolderLabel: locale.influencer_bank_account_holder,
                accountHolderValue: wallet.bankAccount.accountHolder,
                accountNumberLabel: locale.influencer_account_number,
                accountNumberValue: locale.influencer_account_number_sample,
                ibanLabel: locale.influencer_iban_with_label,
                ibanValue: wallet.bankAccount.iban,
              ),
              const SizedBox(height: Spacing.base),
              InfluencerWithdrawReviewSummaryCard(
                title: locale.influencer_operation_summary,
                requestedAmountLabel:
                    locale.influencer_requested_withdraw_amount,
                requestedAmountValue: amountWithCurrency,
                transferFeesLabel: locale.influencer_transfer_fees,
                transferFeesValue: locale.influencer_transfer_fees_value,
                finalAmountLabel: locale.influencer_final_received_amount,
                finalAmountValue: amountWithCurrency,
              ),
              const SizedBox(height: Spacing.base),
              InfluencerWithdrawReviewNoteCard(
                title: locale.influencer_important_info,
                message: locale.influencer_important_info_message,
              ),
              const SizedBox(height: Spacing.xl),
              InfluencerPrimaryButton(
                label: locale.influencer_confirm_withdraw,
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.influencerWallet,
                  ModalRoute.withName(AppRoutes.influencerDashboard),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              InfluencerPrimaryButton(
                label: locale.influencer_back_button,
                filled: false,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: Spacing.base),
            ],
          ),
        ),
      ),
    );
  }
}
