import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import '../../domain/entities/influencer_wallet_entity.dart';
import '../manager/influencer_wallet_event.dart';
import '../manager/influencer_wallet_state.dart';
import '../manager/influencer_wallet_view_model.dart';
import '../models/influencer_wallet_view_data.dart';
import '../widgets/influencer_transaction_tile.dart';
import '../widgets/influencer_withdraw_history_loading_skeleton.dart';

class InfluencerWithdrawHistoryScreen extends StatelessWidget {
  const InfluencerWithdrawHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider(
      create: (_) =>
          getIt<InfluencerWalletViewModel>()
            ..doIntent(const LoadInfluencerWithdrawalsEvent()),
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          title: locale.influencer_withdraw_history_title,
          titleFontSize: FontSize.size17,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        body: BlocConsumer<InfluencerWalletViewModel, InfluencerWalletState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure &&
              current.failure != null &&
              current.withdrawals != null,
          listener: (context, state) => CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.fromFailure(context, state.failure!),
          ),
          builder: (context, state) {
            if (state.isHistoryLoading && state.withdrawals == null) {
              return const InfluencerWithdrawHistoryLoadingSkeleton();
            }
            if (state.failure != null && state.withdrawals == null) {
              return ApiErrorWidget(
                exception: state.failure!.exception,
                onRetry: () => context
                    .read<InfluencerWalletViewModel>()
                    .doIntent(const LoadInfluencerWithdrawalsEvent()),
              );
            }
            final items =
                state.withdrawals?.items ??
                const <InfluencerWithdrawalEntity>[];
            if (items.isEmpty) {
              return EmptyStateWidget(
                title: locale.influencer_wallet_history_action,
                description: locale.influencer_wallet_subtitle,
                icon: Icons.history_rounded,
              );
            }
            return SafeArea(
              top: false,
              child: ListView.separated(
                padding: const EdgeInsetsDirectional.only(
                  start: Spacing.screenH,
                  top: Spacing.md,
                  end: Spacing.screenH,
                  bottom: Spacing.xxxl,
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: Spacing.sm),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InfluencerTransactionTile(
                    transaction: InfluencerTransactionViewData(
                      title: locale.influencer_bank_transfer,
                      date: item.requestedAtUtc?.toLocal().toString() ?? '',
                      amount:
                          '${item.amount.amount.toStringAsFixed(3)} ${item.amount.currency}',
                      status:
                          item.status == InfluencerWithdrawalStatus.completed
                          ? locale.wallet_status_completed
                          : locale.wallet_status_processing,
                      isDebit: true,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
