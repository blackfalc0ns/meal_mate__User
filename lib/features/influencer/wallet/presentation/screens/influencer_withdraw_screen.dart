import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import '../../../dashboard/presentation/widgets/influencer_primary_button.dart';
import '../../domain/entities/influencer_wallet_entity.dart';
import '../manager/influencer_wallet_event.dart';
import '../manager/influencer_wallet_state.dart';
import '../manager/influencer_wallet_view_model.dart';
import '../widgets/influencer_withdraw_balance_card.dart';
import '../widgets/influencer_withdraw_input_field.dart';
import '../widgets/influencer_withdraw_loading_skeleton.dart';
import '../widgets/influencer_withdraw_notice_banner.dart';
import '../widgets/influencer_withdraw_title_block.dart';
import 'influencer_withdraw_review_screen.dart';

class InfluencerWithdrawScreen extends StatefulWidget {
  const InfluencerWithdrawScreen({super.key});
  @override
  State<InfluencerWithdrawScreen> createState() =>
      _InfluencerWithdrawScreenState();
}

class _InfluencerWithdrawScreenState extends State<InfluencerWithdrawScreen> {
  late final InfluencerWalletViewModel _viewModel;
  late final TextEditingController _accountHolderController;
  late final TextEditingController _ibanController;
  late final TextEditingController _bankNameController;
  late final TextEditingController _amountController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _viewModel = getIt<InfluencerWalletViewModel>()
      ..doIntent(const LoadInfluencerWalletEvent());
    _accountHolderController = TextEditingController();
    _ibanController = TextEditingController();
    _bankNameController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _viewModel.close();
    _accountHolderController.dispose();
    _ibanController.dispose();
    _bankNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(title: (locale.influencer_withdraw_screen_title)),
        body: BlocConsumer<InfluencerWalletViewModel, InfluencerWalletState>(
          listenWhen: (previous, current) =>
              (previous.wallet == null && current.wallet != null) ||
              (previous.failure != current.failure &&
                  current.failure != null &&
                  current.wallet != null),
          listener: (context, state) {
            if (state.wallet != null && _amountController.text.isEmpty) {
              _amountController.text = state.wallet!.availableBalance.amount
                  .toStringAsFixed(3);
            }
            if (state.failure != null && state.wallet != null) {
              CustomSnackbar.showError(
                context: context,
                message: ErrorMessagePresenter.fromFailure(
                  context,
                  state.failure!,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading && state.wallet == null) {
              return const InfluencerWithdrawLoadingSkeleton();
            }
            if (state.failure != null && state.wallet == null) {
              return ApiErrorWidget(
                exception: state.failure!.exception,
                onRetry: () => _viewModel.doIntent(
                  const LoadInfluencerWalletEvent(forceRefresh: true),
                ),
              );
            }
            final wallet = state.wallet;
            if (wallet == null) return const SizedBox.shrink();
            return SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: Spacing.screenH,
                    vertical: Spacing.screenV,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InfluencerWithdrawTitleBlock(
                        title: locale.influencer_withdraw_screen_title,
                        subtitle: locale.influencer_withdraw_screen_subtitle,
                      ),
                      const SizedBox(height: Spacing.base),
                      InfluencerWithdrawBalanceCard(
                        title: locale.influencer_available_for_withdraw,
                        amount: wallet.availableBalance.amount.toStringAsFixed(
                          3,
                        ),
                        currency: wallet.currencyCode,
                        iconAsset: AssetsFake.influencerWalletIcon,
                      ),
                      const SizedBox(height: Spacing.base),
                      InfluencerWithdrawInputField(
                        label: locale.influencer_withdraw_amount,
                        hint: wallet.availableBalance.amount.toStringAsFixed(3),
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) => _isValidAmount(value, wallet)
                            ? null
                            : locale.this_field_is_required,
                      ),
                      if (!wallet.bankInfo.isConfigured) ...[
                        const SizedBox(height: Spacing.base),
                        InfluencerWithdrawInputField(
                          label: locale.influencer_bank_account_holder,
                          hint: locale.influencer_account_holder_hint,
                          controller: _accountHolderController,
                        ),
                        const SizedBox(height: Spacing.sm),
                        InfluencerWithdrawInputField(
                          label: locale.influencer_bank_iban,
                          hint: locale.influencer_iban_hint,
                          controller: _ibanController,
                        ),
                        const SizedBox(height: Spacing.sm),
                        InfluencerWithdrawInputField(
                          label: locale.influencer_bank_name,
                          hint: locale.influencer_select_bank_hint,
                          controller: _bankNameController,
                        ),
                      ],
                      const SizedBox(height: Spacing.base),
                      InfluencerWithdrawNoticeBanner(
                        message: locale.influencer_withdraw_notice_text,
                      ),
                      const SizedBox(height: Spacing.xl),
                      InfluencerPrimaryButton(
                        label: locale.influencer_request_withdraw,
                        onPressed:
                            wallet.withdrawalPolicy.canWithdraw &&
                                !wallet.hasActiveWithdrawalRequest
                            ? () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _openReview(context, wallet);
                                }
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openReview(BuildContext context, InfluencerWalletEntity wallet) {
    final amount = double.parse(_amountController.text.trim());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InfluencerWithdrawReviewScreen(
          wallet: wallet,
          amount: amount,
          bankName: wallet.bankInfo.isConfigured
              ? wallet.bankInfo.bankName
              : _bankNameController.text.trim(),
          accountHolderName: wallet.bankInfo.isConfigured
              ? wallet.bankInfo.accountHolderName
              : _accountHolderController.text.trim(),
          iban: wallet.bankInfo.isConfigured
              ? wallet.bankInfo.iban
              : _ibanController.text.replaceAll(' ', '').toUpperCase(),
        ),
      ),
    );
  }

  bool _isValidAmount(String? value, InfluencerWalletEntity wallet) {
    final amount = double.tryParse(value?.trim() ?? '');
    if (amount == null) return false;
    final policy = wallet.withdrawalPolicy;
    return amount >= policy.minimumAmount &&
        amount <= policy.maximumAmount &&
        amount <= wallet.availableBalance.amount;
  }
}
