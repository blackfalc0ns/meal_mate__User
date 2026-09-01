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

class InfluencerWithdrawReviewScreen extends StatelessWidget {
  const InfluencerWithdrawReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final wallet = InfluencerFakeDataSource(locale).loadDashboard().wallet;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.influencer_withdraw_review_title,
        titleFontSize: FontSize.size17,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: Spacing.screenH,
            top: Spacing.md,
            end: Spacing.screenH,
            bottom: Spacing.xxxl,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                  border: Border.all(color: color.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.08),
                      blurRadius: Spacing.md,
                      offset: const Offset(0, Spacing.xs),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_rounded,
                      color: color.primary,
                      size: Spacing.iconXl,
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(
                      locale.influencer_withdraw_review_subtitle,
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    InfluencerInfoRow(
                      label: locale.influencer_withdraw_amount,
                      value: wallet.availableBalance,
                    ),
                    InfluencerInfoRow(
                      label: locale.influencer_bank_name,
                      value: wallet.bankAccount.bankName,
                    ),
                    InfluencerInfoRow(
                      label: locale.influencer_bank_iban,
                      value: wallet.bankAccount.iban,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InfluencerPrimaryButton(
                label: locale.influencer_confirm_withdraw,
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.influencerWallet,
                  ModalRoute.withName(AppRoutes.influencerDashboard),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              InfluencerPrimaryButton(
                label: locale.wallet_cancel,
                filled: false,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
