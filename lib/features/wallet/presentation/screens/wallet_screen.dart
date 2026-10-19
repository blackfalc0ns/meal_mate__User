import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/wallet_entities.dart';
import 'package:meal_meat_user/features/wallet/presentation/manager/customer_wallet_event.dart';
import 'package:meal_meat_user/features/wallet/presentation/manager/customer_wallet_state.dart';
import 'package:meal_meat_user/features/wallet/presentation/manager/customer_wallet_view_model.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_action_button.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_info_card.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_recent_transactions_section.dart';
import 'package:meal_meat_user/features/wallet/presentation/widgets/wallet_security_note.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerWalletViewModel>(
      create: (_) =>
          getIt<CustomerWalletViewModel>()
            ..doIntent(const LoadCustomerWalletEvent()),
      child: const _WalletScreenContent(),
    );
  }
}

class _WalletScreenContent extends StatelessWidget {
  const _WalletScreenContent();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

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
        child: BlocBuilder<CustomerWalletViewModel, CustomerWalletState>(
          builder: (context, state) {
            if (state.isLoading && state.wallet == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.failure != null && state.wallet == null) {
              return ApiErrorWidget(
                exception: state.failure!.exception,
                onRetry: () => context
                    .read<CustomerWalletViewModel>()
                    .doIntent(const LoadCustomerWalletEvent()),
              );
            }

            final wallet = state.wallet;
            final totalBalance =
                wallet != null ? wallet.totalBalance.toStringAsFixed(3) : '0.000';
            final cashBalance = wallet?.cashBalance ?? 0.0;
            final promotionalBalance = wallet?.promotionalBalance ?? 0.0;
            final currency = wallet?.currency ?? 'KWD';

            final recentTransactions = state.transactions.take(5).map((t) {
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

            return RefreshIndicator(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.screenH,
                  ),
                  child: Column(
                    children: [
                      if (state.failure != null && state.wallet != null) ...[
                        InlineApiErrorWidget(
                          failure: state.failure!,
                          onRetry: () => context
                              .read<CustomerWalletViewModel>()
                              .doIntent(const RefreshCustomerWalletEvent()),
                        ),
                        const SizedBox(height: Spacing.sm),
                      ],
                      WalletBalanceCard(
                        title: locale.wallet_total_refundable_balance_title,
                        amount: totalBalance,
                        currency: currency,
                        subtitle:
                            locale.wallet_total_refundable_balance_subtitle,
                      ),
                      const SizedBox(height: Spacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.base,
                          vertical: Spacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: color.surface,
                          borderRadius:
                              BorderRadius.circular(Spacing.cardRadius),
                          border: Border.all(color: color.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locale.wallet_cash_balance,
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size11,
                                      color: color.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: Spacing.xxs),
                                  Text(
                                    '${cashBalance.toStringAsFixed(3)} $currency',
                                    style: getBoldStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size14,
                                      color: color.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 32,
                              color: color.outlineVariant,
                            ),
                            const SizedBox(width: Spacing.base),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locale.wallet_promotional_balance,
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size11,
                                      color: color.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: Spacing.xxs),
                                  Text(
                                    '${promotionalBalance.toStringAsFixed(3)} $currency',
                                    style: getBoldStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size14,
                                      color: color.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: WalletActionButton(
                              label: locale.wallet_refund_to_card,
                              icon: Icons.credit_card_rounded,
                              filled: true,
                              onTap: () =>
                                  context.pushNamed(AppRoutes.walletRefund),
                            ),
                          ),
                          const SizedBox(width: Spacing.walletActionGap),
                          Expanded(
                            child: WalletActionButton(
                              label: locale.wallet_transactions_history,
                              icon: Icons.description_rounded,
                              onTap: () => context
                                  .pushNamed(AppRoutes.walletTransactions),
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
                      if (recentTransactions.isNotEmpty) ...[
                        WalletRecentTransactionsSection(
                          transactions: recentTransactions,
                        ),
                      ] else ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: Spacing.xl,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: color.surface,
                            borderRadius:
                                BorderRadius.circular(Spacing.cardRadius),
                            border: Border.all(color: color.outlineVariant),
                          ),
                          child: Text(
                            locale.wallet_empty_transactions,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: Spacing.lg),
                      const WalletSecurityNote(),
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
}
