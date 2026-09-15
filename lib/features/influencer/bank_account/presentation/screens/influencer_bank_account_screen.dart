import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import '../../../dashboard/presentation/widgets/influencer_primary_button.dart';
import '../../../wallet/presentation/widgets/influencer_withdraw_input_field.dart';
import '../manager/influencer_bank_account_event.dart';
import '../manager/influencer_bank_account_state.dart';
import '../manager/influencer_bank_account_view_model.dart';

class InfluencerBankAccountScreen extends StatefulWidget {
  const InfluencerBankAccountScreen({super.key});
  @override
  State<InfluencerBankAccountScreen> createState() =>
      _InfluencerBankAccountScreenState();
}

class _InfluencerBankAccountScreenState
    extends State<InfluencerBankAccountScreen> {
  late final InfluencerBankAccountViewModel _viewModel;
  late final TextEditingController _bankController;
  late final TextEditingController _holderController;
  late final TextEditingController _ibanController;
  var _initialized = false;
  @override
  void initState() {
    super.initState();
    _viewModel = getIt<InfluencerBankAccountViewModel>()
      ..doIntent(const LoadInfluencerBankAccountEvent());
    _bankController = TextEditingController();
    _holderController = TextEditingController();
    _ibanController = TextEditingController();
  }

  @override
  void dispose() {
    _viewModel.close();
    _bankController.dispose();
    _holderController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider.value(
      value: _viewModel,
      child:
          BlocConsumer<
            InfluencerBankAccountViewModel,
            InfluencerBankAccountState
          >(
            listenWhen: (previous, current) =>
                !_initialized && current.account != null,
            listener: (_, state) {
              final account = state.account!;
              _bankController.text = account.bankName;
              _holderController.text = account.accountHolderName;
              _ibanController.text = account.iban ?? '';
              _initialized = true;
            },
            builder: (context, state) => Scaffold(
              backgroundColor: color.surface,
              appBar: CustomAppBar(
                title: locale.influencer_bank_transfer_details,
                backgroundColor: color.surface,
                showShadow: false,
              ),
              body: _body(context, state),
            ),
          ),
    );
  }

  Widget _body(BuildContext context, InfluencerBankAccountState state) {
    final color = context.colorScheme;
    final locale = context.localization;
    if (state.isLoading && state.account == null) {
      return Center(child: CircularProgressIndicator(color: color.primary));
    }
    if (state.failure != null && state.account == null) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () => _viewModel.doIntent(
          const LoadInfluencerBankAccountEvent(forceRefresh: true),
        ),
      );
    }
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: Spacing.screenH,
          vertical: Spacing.screenV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfluencerWithdrawInputField(
              label: locale.influencer_bank_name,
              hint: locale.influencer_select_bank_hint,
              controller: _bankController,
            ),
            const SizedBox(height: Spacing.sm),
            InfluencerWithdrawInputField(
              label: locale.influencer_bank_account_holder,
              hint: locale.influencer_account_holder_hint,
              controller: _holderController,
            ),
            const SizedBox(height: Spacing.sm),
            InfluencerWithdrawInputField(
              label: locale.influencer_bank_iban,
              hint: locale.influencer_iban_hint,
              controller: _ibanController,
            ),
            const SizedBox(height: Spacing.xl),
            InfluencerPrimaryButton(
              label: locale.influencer_save_continue,
              isLoading: state.isMutating,
              onPressed: state.isMutating
                  ? null
                  : () => _viewModel.doIntent(
                      SaveInfluencerBankAccountEvent(
                        bankName: _bankController.text.trim(),
                        accountHolderName: _holderController.text.trim(),
                        iban: _ibanController.text
                            .replaceAll(RegExp(r'[\s-]'), '')
                            .toUpperCase(),
                      ),
                    ),
            ),
            if (state.account?.isConfigured == true) ...[
              const SizedBox(height: Spacing.sm),
              InfluencerPrimaryButton(
                label: locale.addresses_delete,
                filled: false,
                onPressed: state.isMutating
                    ? null
                    : () => _viewModel.doIntent(
                        const DeleteInfluencerBankAccountEvent(),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
