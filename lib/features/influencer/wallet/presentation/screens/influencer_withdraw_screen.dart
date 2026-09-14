import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/dashboard/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_primary_button.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_amount_card.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_balance_card.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_input_field.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_method_card.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_notice_banner.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_title_block.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_withdraw_top_bar.dart';

class InfluencerWithdrawScreen extends StatefulWidget {
  const InfluencerWithdrawScreen({super.key});

  @override
  State<InfluencerWithdrawScreen> createState() =>
      _InfluencerWithdrawScreenState();
}

class _InfluencerWithdrawScreenState extends State<InfluencerWithdrawScreen> {
  int _selectedMethodIndex = 0;
  late final TextEditingController _accountHolderController;
  late final TextEditingController _ibanController;
  late final TextEditingController _bankNameController;

  @override
  void initState() {
    super.initState();
    _accountHolderController = TextEditingController();
    _ibanController = TextEditingController();
    _bankNameController = TextEditingController();
  }

  @override
  void dispose() {
    _accountHolderController.dispose();
    _ibanController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dashboard = InfluencerFakeDataSource(locale).loadDashboard();
    final wallet = dashboard.wallet;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.screenV,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfluencerWithdrawTopBar(
                userName: dashboard.userName,
                partnerLabel: dashboard.partnerLabel,
                avatarAsset: dashboard.avatarAsset,
                onBackTap: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: Spacing.base),
              InfluencerWithdrawTitleBlock(
                title: locale.influencer_withdraw_screen_title,
                subtitle: locale.influencer_withdraw_screen_subtitle,
              ),
              const SizedBox(height: Spacing.base),
              InfluencerWithdrawBalanceCard(
                title: locale.influencer_available_for_withdraw,
                amount: wallet.availableBalance,
                currency: wallet.currency,
                iconAsset: AssetsFake.influencerWalletIcon,
              ),
              const SizedBox(height: Spacing.base),
              Text(
                locale.influencer_choose_withdraw_method,
                textAlign: TextAlign.start,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              InfluencerWithdrawMethodCard(
                title: locale.influencer_bank_transfer,
                subtitle: locale.influencer_bank_transfer_subtitle,
                icon: Icons.account_balance_rounded,
                isSelected: _selectedMethodIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedMethodIndex = 0;
                  });
                },
              ),
              const SizedBox(height: Spacing.sm),
              InfluencerWithdrawMethodCard(
                title: locale.influencer_electronic_wallet,
                subtitle: locale.influencer_electronic_wallet_subtitle,
                icon: Icons.account_balance_wallet_rounded,
                isSelected: _selectedMethodIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedMethodIndex = 1;
                  });
                },
              ),
              const SizedBox(height: Spacing.base),
              Text(
                locale.influencer_bank_transfer_details,
                textAlign: TextAlign.start,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.base),
              InfluencerWithdrawInputField(
                label: locale.influencer_bank_account_holder,
                hint: locale.influencer_account_holder_hint,
                controller: _accountHolderController,
              ),
              const SizedBox(height: Spacing.sm),
              InfluencerWithdrawInputField(
                label: locale.influencer_bank_iban,
                hint: locale.influencer_iban_hint,
                controller: _ibanController,
                suffixIcon: Icon(
                  Icons.crop_free_rounded,
                  color: color.onSurfaceVariant,
                  size: Spacing.iconMd,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              InfluencerWithdrawInputField(
                label: locale.influencer_bank_name,
                hint: locale.influencer_select_bank_hint,
                controller: _bankNameController,
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: color.onSurfaceVariant,
                  size: Spacing.iconMd,
                ),
              ),
              const SizedBox(height: Spacing.base),
              InfluencerWithdrawAmountCard(
                label: locale.influencer_withdraw_amount,
                amount: '${wallet.availableBalance}.000',
                currency: wallet.currency,
              ),
              const SizedBox(height: Spacing.base),
              InfluencerWithdrawNoticeBanner(
                message: locale.influencer_withdraw_notice_text,
              ),
              const SizedBox(height: Spacing.xl),
              InfluencerPrimaryButton(
                label: locale.influencer_request_withdraw,
                onPressed: () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.influencerWithdrawReview),
              ),
              const SizedBox(height: Spacing.base),
            ],
          ),
        ),
      ),
    );
  }
}
