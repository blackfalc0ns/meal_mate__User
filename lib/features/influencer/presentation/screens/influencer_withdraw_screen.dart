import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/influencer/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_info_row.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_primary_button.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_wallet_balance_card.dart';

class InfluencerWithdrawScreen extends StatelessWidget {
  const InfluencerWithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final wallet = InfluencerFakeDataSource(locale).loadDashboard().wallet;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.influencer_request_withdraw,
        titleFontSize: FontSize.size17,
        backgroundColor: color.surface,
        showShadow: false,
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
                subtitle: locale.influencer_withdraw_arrival_hint,
              ),
              const SizedBox(height: Spacing.base),
              Text(
                locale.influencer_withdraw_method,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                  border: Border.all(color: color.outlineVariant),
                ),
                child: Column(
                  children: [
                    InfluencerInfoRow(
                      label: locale.influencer_bank_account_holder,
                      value: wallet.bankAccount.accountHolder,
                    ),
                    InfluencerInfoRow(
                      label: locale.influencer_bank_iban,
                      value: wallet.bankAccount.iban,
                    ),
                    InfluencerInfoRow(
                      label: locale.influencer_bank_name,
                      value: wallet.bankAccount.bankName,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.base),
              InfluencerPrimaryButton(
                label: locale.influencer_continue_review,
                onPressed: () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.influencerWithdrawReview),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
