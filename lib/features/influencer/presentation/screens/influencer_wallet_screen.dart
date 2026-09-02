import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/influencer/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_action_tile.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_dashboard_bottom_tabs.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_transaction_tile.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_wallet_balance_card.dart';

class InfluencerWalletScreen extends StatelessWidget {
  const InfluencerWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dashboard = InfluencerFakeDataSource(locale).loadDashboard();
    final wallet = dashboard.wallet;

    final actions = [
      InfluencerActionEntity(
        title: locale.influencer_request_withdraw,
        subtitle: locale.influencer_request_withdraw_subtitle,
        icon: InfluencerActionIcon.wallet,
        routeName: AppRoutes.influencerWithdraw,
      ),
      InfluencerActionEntity(
        title: locale.influencer_withdraw_history_title,
        subtitle: locale.influencer_withdraw_history_subtitle,
        icon: InfluencerActionIcon.history,
        routeName: AppRoutes.influencerWithdrawHistory,
      ),
    ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.influencer_wallet_title,
        titleFontSize: FontSize.size17,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      bottomNavigationBar: const InfluencerDashboardBottomTabs(
        selectedTab: InfluencerDashboardTabItem.wallet,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.screenH,
            top: Spacing.md,
            end: Spacing.screenH,
            bottom: Spacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfluencerWalletBalanceCard(
                title: locale.influencer_available_earnings,
                amount: wallet.availableBalance,
                subtitle: wallet.lastUpdated,
              ),
              const SizedBox(height: Spacing.base),
              ...actions.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: InfluencerActionTile(
                    action: action,
                    onTap: () =>
                        Navigator.of(context).pushNamed(action.routeName),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                locale.influencer_recent_commissions,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              ...wallet.transactions
                  .take(2)
                  .map(
                    (transaction) => Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.sm),
                      child: InfluencerTransactionTile(
                        transaction: transaction,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
