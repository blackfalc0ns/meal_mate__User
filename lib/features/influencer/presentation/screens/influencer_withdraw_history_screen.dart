import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/influencer/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_transaction_tile.dart';

class InfluencerWithdrawHistoryScreen extends StatelessWidget {
  const InfluencerWithdrawHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final transactions = InfluencerFakeDataSource(
      locale,
    ).loadDashboard().wallet.transactions;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.influencer_withdraw_history_title,
        titleFontSize: FontSize.size17,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.screenH,
            top: Spacing.md,
            end: Spacing.screenH,
            bottom: Spacing.xxxl,
          ),
          itemCount: transactions.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: Spacing.sm),
          itemBuilder: (context, index) =>
              InfluencerTransactionTile(transaction: transactions[index]),
        ),
      ),
    );
  }
}
