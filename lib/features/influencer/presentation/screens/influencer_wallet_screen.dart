import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_header_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_wallet_action_button.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_wallet_monthly_summary_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_wallet_overview_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_wallet_recent_transactions_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_wallet_title_block.dart';

class InfluencerWalletScreen extends StatelessWidget {
  const InfluencerWalletScreen({super.key, this.showScaffold = true});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dashboard = InfluencerFakeDataSource(locale).loadDashboard();
    final wallet = dashboard.wallet;

    final actions = [
      InfluencerActionEntity(
        title: locale.influencer_wallet_history_action,
        subtitle: locale.influencer_withdraw_history_subtitle,
        icon: InfluencerActionIcon.history,
        routeName: AppRoutes.influencerWithdrawHistory,
      ),
      InfluencerActionEntity(
        title: locale.influencer_wallet_withdraw_action,
        subtitle: locale.influencer_request_withdraw_subtitle,
        icon: InfluencerActionIcon.wallet,
        routeName: AppRoutes.influencerWithdraw,
      ),
    ];

    final body = SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.screenH,
          top: Spacing.md,
          end: Spacing.screenH,
          bottom: Spacing.xxxl,
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
              availableAmount: wallet.availableBalance,
              totalTitle: locale.influencer_total_earnings_colon,
              totalAmount: wallet.totalBalance,
              currency: wallet.currency,
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
              metrics: wallet.monthlySummary,
            ),
            const SizedBox(height: Spacing.base),
            InfluencerWalletRecentTransactionsCard(
              title: locale.influencer_wallet_latest_transactions,
              actionLabel: locale.influencer_view_all,
              transactions: wallet.transactions,
              onActionTap: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.influencerWithdrawHistory),
            ),
          ],
        ),
      ),
    );

    if (!showScaffold) {
      return body;
    }

    return Scaffold(
      backgroundColor: color.surface,
      appBar: InfluencerHeaderCard(
        userName: dashboard.userName,
        partnerLabel: dashboard.partnerLabel,
        avatarAsset: dashboard.avatarAsset,
        logoAsset: dashboard.logoAsset,
      ),
      body: body,
    );
  }
}
