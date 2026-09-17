import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import '../../domain/entities/influencer_wallet_entity.dart';
import '../../../bank_account/presentation/screens/influencer_bank_account_screen.dart';
import '../../../dashboard/presentation/widgets/influencer_primary_button.dart';
import '../manager/influencer_wallet_event.dart';
import '../manager/influencer_wallet_state.dart';
import '../manager/influencer_wallet_view_model.dart';
import '../models/influencer_wallet_view_data.dart';
import '../widgets/influencer_wallet_action_button.dart';
import '../widgets/influencer_wallet_loading_skeleton.dart';
import '../widgets/influencer_wallet_monthly_summary_card.dart';
import '../widgets/influencer_wallet_overview_card.dart';
import '../widgets/influencer_wallet_recent_transactions_card.dart';
import '../widgets/influencer_wallet_title_block.dart';

class InfluencerWalletScreen extends StatelessWidget {
  const InfluencerWalletScreen({super.key, this.showScaffold = true});
  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider(
      create: (_) =>
          getIt<InfluencerWalletViewModel>()
            ..doIntent(const LoadInfluencerWalletEvent()),
      child: BlocConsumer<InfluencerWalletViewModel, InfluencerWalletState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure &&
            current.failure != null &&
            current.wallet != null,
        listener: (context, state) => CustomSnackbar.showError(
          context: context,
          message: ErrorMessagePresenter.fromFailure(
            context,
            state.failure!,
          ),
        ),
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.wallet != current.wallet ||
            previous.failure != current.failure,
        builder: (context, state) {
          final content = _buildContent(context, state);
          if (!showScaffold) return content;
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              title: locale.influencer_wallet_figma_title,
              backgroundColor: color.surface,
              showShadow: false,
            ),
            body: content,
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, InfluencerWalletState state) {
    final locale = context.localization;
    if (state.isLoading && state.wallet == null) {
      return const InfluencerWalletLoadingSkeleton();
    }
    if (state.failure != null && state.wallet == null) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () => context.read<InfluencerWalletViewModel>().doIntent(
          const LoadInfluencerWalletEvent(forceRefresh: true),
        ),
      );
    }
    final wallet = state.wallet;
    if (wallet == null) return const SizedBox.shrink();
    final actions = [
      InfluencerWalletActionViewData(
        title: locale.influencer_wallet_history_action,
        routeName: AppRoutes.influencerWithdrawHistory,
        icon: InfluencerWalletActionIcon.history,
      ),
      InfluencerWalletActionViewData(
        title: locale.influencer_wallet_withdraw_action,
        routeName: AppRoutes.influencerWithdraw,
        icon: InfluencerWalletActionIcon.wallet,
      ),
    ];
    final transactions = wallet.recentTransactions
        .map(
          (item) => InfluencerTransactionViewData(
            title: locale.influencer_bank_transfer,
            date: item.requestedAtUtc?.toLocal().toString() ?? '',
            amount:
                '${item.amount.amount.toStringAsFixed(3)} ${item.amount.currency}',
            status: item.status == InfluencerWithdrawalStatus.completed
                ? locale.wallet_status_completed
                : locale.wallet_status_processing,
            isDebit: true,
          ),
        )
        .toList();
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
            InfluencerWalletTitleBlock(
              title: locale.influencer_wallet_figma_title,
              subtitle: locale.influencer_wallet_figma_subtitle,
            ),
            const SizedBox(height: Spacing.base),
            InfluencerWalletOverviewCard(
              availableTitle: locale.influencer_available_balance,
              availableAmount: wallet.availableBalance.amount.toStringAsFixed(
                3,
              ),
              totalTitle: locale.influencer_total_earnings_colon,
              totalAmount: wallet.lifetimeEarnings.amount.toStringAsFixed(3),
              currency: wallet.currencyCode,
            ),
            const SizedBox(height: Spacing.influencerWalletActionsTopGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 0; index < actions.length; index++) ...[
                  InfluencerWalletActionButton(
                    action: actions[index],
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(actions[index].routeName),
                  ),
                  if (index < actions.length - 1)
                    const SizedBox(width: Spacing.influencerWalletActionsGap),
                ],
              ],
            ),
            const SizedBox(height: Spacing.base),
            InfluencerWalletMonthlySummaryCard(
              title: locale.influencer_wallet_month_summary,
              metrics: [
                InfluencerWalletSummaryMetricViewData(
                  title: locale.influencer_wallet_summary_withdrawn,
                  value: wallet.thisMonthWithdrawn.amount.toStringAsFixed(3),
                  currency: wallet.currencyCode,
                  icon: InfluencerWalletSummaryIcon.withdrawn,
                ),
                InfluencerWalletSummaryMetricViewData(
                  title: locale.influencer_wallet_summary_total_earnings,
                  value: wallet.thisMonthEarned.amount.toStringAsFixed(3),
                  currency: wallet.currencyCode,
                  icon: InfluencerWalletSummaryIcon.earnings,
                ),
              ],
            ),
            const SizedBox(height: Spacing.base),
            InfluencerWalletRecentTransactionsCard(
              title: locale.influencer_wallet_latest_transactions,
              actionLabel: locale.influencer_view_all,
              transactions: transactions,
              onActionTap: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.influencerWithdrawHistory),
            ),
            const SizedBox(height: Spacing.base),
            InfluencerPrimaryButton(
              label: locale.influencer_bank_transfer_details,
              filled: false,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const InfluencerBankAccountScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
