import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/wallet_entities.dart';
import 'package:meal_meat_user/features/wallet/presentation/manager/customer_wallet_event.dart';
import 'package:meal_meat_user/features/wallet/presentation/manager/customer_wallet_state.dart';
import 'package:meal_meat_user/features/wallet/presentation/manager/customer_wallet_view_model.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_filter_chip.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_info_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_transaction_group.dart';

class WalletTransactionsScreen extends StatelessWidget {
  const WalletTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerWalletViewModel>(
      create: (_) =>
          getIt<CustomerWalletViewModel>()
            ..doIntent(const LoadCustomerWalletEvent()),
      child: const _WalletTransactionsContent(),
    );
  }
}

class _WalletTransactionsContent extends StatelessWidget {
  const _WalletTransactionsContent();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

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
        child: BlocBuilder<CustomerWalletViewModel, CustomerWalletState>(
          builder: (context, state) {
            if (state.isLoading && state.wallet == null && state.transactions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.failure != null && state.wallet == null && state.transactions.isEmpty) {
              return ApiErrorWidget(
                exception: state.failure!.exception,
                onRetry: () => context
                    .read<CustomerWalletViewModel>()
                    .doIntent(const LoadCustomerWalletEvent()),
              );
            }

            final wallet = state.wallet;
            final refundableBalance = wallet != null
                ? wallet.totalBalance.toStringAsFixed(3)
                : '0.000';
            final currency = wallet?.currency ?? 'KWD';
            final lastUpdated = wallet?.updatedAtUtc != null
                ? wallet!.updatedAtUtc!.split('T').first
                : DateTime.now().toIso8601String().split('T').first;

            final mappedTransactions = state.transactions.map((t) {
              final isDebit = t.type == 'debit';
              final kind = t.walletType == 'promotional'
                  ? WalletTransactionKind.settlement
                  : (isDebit
                      ? WalletTransactionKind.refund
                      : WalletTransactionKind.cardRefund);
              final prefix = isDebit ? '-' : '+';
              return WalletTransactionEntity(
                title: t.description.isNotEmpty ? t.description : t.type,
                date: t.createdAtUtc != null
                    ? t.createdAtUtc!.split('T').first
                    : '',
                amount: '$prefix${t.amount.toStringAsFixed(3)}',
                currency: t.currency,
                kind: kind,
                status: WalletTransactionStatus.completed,
              );
            }).toList();

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 200) {
                  context
                      .read<CustomerWalletViewModel>()
                      .doIntent(const LoadMoreWalletTransactionsEvent());
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<CustomerWalletViewModel>()
                      .doIntent(const RefreshCustomerWalletEvent());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.only(bottom: Spacing.xxxl),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Spacing.screenH),
                    child: Column(
                      children: [
                        if (state.failure != null || state.transactionsFailure != null) ...[
                          InlineApiErrorWidget(
                            failure: (state.transactionsFailure ?? state.failure)!,
                            onRetry: () => context
                                .read<CustomerWalletViewModel>()
                                .doIntent(const RefreshCustomerWalletEvent()),
                          ),
                          const SizedBox(height: Spacing.sm),
                        ],
                        WalletBalanceCard(
                          title: locale.wallet_refundable_balance,
                          amount: refundableBalance,
                          currency: currency,
                          subtitle: locale.wallet_last_updated(lastUpdated),
                        ),
                        const SizedBox(height: Spacing.base),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              WalletFilterChip(
                                label: locale.wallet_filter_all,
                                selected: state.selectedWalletType == null,
                                onTap: () => context
                                    .read<CustomerWalletViewModel>()
                                    .doIntent(
                                      const FilterWalletTransactionsEvent(null),
                                    ),
                              ),
                              const SizedBox(width: Spacing.sm),
                              WalletFilterChip(
                                label: locale.wallet_filter_cash,
                                selected: state.selectedWalletType == 'cash',
                                onTap: () => context
                                    .read<CustomerWalletViewModel>()
                                    .doIntent(
                                      const FilterWalletTransactionsEvent('cash'),
                                    ),
                              ),
                              const SizedBox(width: Spacing.sm),
                              WalletFilterChip(
                                label: locale.wallet_filter_promotional,
                                selected:
                                    state.selectedWalletType == 'promotional',
                                onTap: () => context
                                    .read<CustomerWalletViewModel>()
                                    .doIntent(
                                      const FilterWalletTransactionsEvent(
                                        'promotional',
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        if (state.isTransactionsLoading) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: Spacing.xl),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ] else if (mappedTransactions.isEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Spacing.xxl,
                            ),
                            child: EmptyStateWidget(
                              title: locale.wallet_empty_transactions,
                              description: locale.wallet_transactions_notice,
                              icon: Icons.account_balance_wallet_outlined,
                            ),
                          ),
                        ] else ...[
                          WalletTransactionGroup(
                            title: locale.wallet_transactions_history,
                            transactions: mappedTransactions,
                          ),
                        ],
                        if (state.isLoadingMore) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: Spacing.md),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ],
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
          },
        ),
      ),
    );
  }
}
