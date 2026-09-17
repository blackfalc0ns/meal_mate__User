import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import '../../../dashboard/presentation/widgets/influencer_primary_button.dart';
import '../../domain/entities/influencer_wallet_entity.dart';
import '../manager/influencer_wallet_event.dart';
import '../manager/influencer_wallet_state.dart';
import '../manager/influencer_wallet_view_model.dart';
import '../widgets/influencer_withdraw_review_details_card.dart';
import '../widgets/influencer_withdraw_review_hero_card.dart';
import '../widgets/influencer_withdraw_review_note_card.dart';
import '../widgets/influencer_withdraw_review_summary_card.dart';
import '../widgets/influencer_withdraw_title_block.dart';

class InfluencerWithdrawReviewScreen extends StatelessWidget {
  const InfluencerWithdrawReviewScreen({
    super.key,
    this.wallet,
    this.amount,
    this.bankName,
    this.accountHolderName,
    this.iban,
  });
  final InfluencerWalletEntity? wallet;
  final double? amount;
  final String? bankName, accountHolderName, iban;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    if (wallet == null || amount == null) {
      return Scaffold(
        backgroundColor: color.surface,
        appBar: AppBar(backgroundColor: color.surface),
        body: Center(child: Text(locale.influencer_withdraw_screen_title)),
      );
    }
    final formattedAmount = amount!.toStringAsFixed(3);
    final amountWithCurrency = '$formattedAmount ${wallet!.currencyCode}';
    return BlocProvider(
      create: (_) => getIt<InfluencerWalletViewModel>(),
      child: BlocConsumer<InfluencerWalletViewModel, InfluencerWalletState>(
        listenWhen: (previous, current) =>
            (previous.isSubmitting &&
                !current.isSubmitting &&
                current.failure == null) ||
            (previous.failure != current.failure && current.failure != null),
        listener: (context, state) {
          if (state.failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.failure!,
              ),
            );
            return;
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.influencerWallet,
            ModalRoute.withName(AppRoutes.influencerDashboard),
          );
        },
        builder: (context, state) => Scaffold(
          backgroundColor: color.surface,
          appBar: AppBar(backgroundColor: color.surface),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: Spacing.screenH,
                vertical: Spacing.screenV,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InfluencerWithdrawTitleBlock(
                    title: locale.influencer_withdraw_review_title,
                    subtitle: locale.influencer_withdraw_review_subtitle,
                  ),
                  const SizedBox(height: Spacing.base),
                  InfluencerWithdrawReviewHeroCard(
                    title: locale.influencer_available_for_withdraw,
                    amount: formattedAmount,
                    currency: wallet!.currencyCode,
                  ),
                  const SizedBox(height: Spacing.base),
                  InfluencerWithdrawReviewDetailsCard(
                    title: locale.influencer_transfer_details,
                    methodLabel: locale.influencer_withdraw_method,
                    methodValue: locale.influencer_bank_transfer,
                    bankLabel: locale.influencer_bank_label,
                    bankValue: bankName ?? '',
                    accountHolderLabel: locale.influencer_bank_account_holder,
                    accountHolderValue: accountHolderName ?? '',
                    accountNumberLabel: locale.influencer_account_number,
                    accountNumberValue: '',
                    ibanLabel: locale.influencer_iban_with_label,
                    ibanValue: wallet!.bankInfo.isConfigured
                        ? wallet!.bankInfo.maskedIban
                        : iban ?? '',
                  ),
                  const SizedBox(height: Spacing.base),
                  InfluencerWithdrawReviewSummaryCard(
                    title: locale.influencer_operation_summary,
                    requestedAmountLabel:
                        locale.influencer_requested_withdraw_amount,
                    requestedAmountValue: amountWithCurrency,
                    transferFeesLabel: locale.influencer_transfer_fees,
                    transferFeesValue: '',
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
                    isLoading: state.isSubmitting,
                    onPressed: state.isSubmitting
                        ? null
                        : () => context
                              .read<InfluencerWalletViewModel>()
                              .doIntent(
                                SubmitInfluencerWithdrawalEvent(
                                  amount: amount!,
                                  correlationId: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                  saveAsDefaultBank:
                                      !wallet!.bankInfo.isConfigured,
                                  bankName: wallet!.bankInfo.isConfigured
                                      ? null
                                      : bankName,
                                  accountHolderName:
                                      wallet!.bankInfo.isConfigured
                                      ? null
                                      : accountHolderName,
                                  iban: wallet!.bankInfo.isConfigured
                                      ? null
                                      : iban,
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
