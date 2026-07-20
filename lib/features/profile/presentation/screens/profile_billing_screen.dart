import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_invoice_history_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_payment_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_plan_card.dart';

class ProfileBillingScreen extends StatelessWidget {
  const ProfileBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.profile_billing,
        titleFontSize: FontSize.size15,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.profileBillingHorizontalPadding,
            vertical: Spacing.md,
          ),
          child: Column(
            children: [
              const ProfileBillingPlanCard(),
              const SizedBox(height: Spacing.md),
              const ProfileBillingPaymentCard(),
              const SizedBox(height: Spacing.md),
              const ProfileBillingInvoiceHistoryCard(),
              const SizedBox(height: Spacing.md),
              CustomWarningWidget(
                icon: Icons.info_rounded,
                message: locale.billing_notice,
                isWarning: true,
                height: Spacing.profileBillingNoticeHeight,
                backgroundColor: color.secondary.withValues(alpha: 0.06),
                borderColor: color.secondary.withValues(alpha: 0.25),
                horizontalPadding: Spacing.sm,
                iconTextSpacing: Spacing.sm,
                borderRadius: Spacing.radiusMd,
                messageFontSize: FontSize.size11,
                maxMessageLines: 3,
              ),
              const SizedBox(height: Spacing.sm),
              SizedBox(
                width: double.infinity,
                height: Spacing.profileBillingButtonHeight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.primary,
                    foregroundColor: color.onPrimary,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    ),
                  ),
                  child: Text(
                    locale.billing_manage_subscription,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size12,
                      color: color.onPrimary,
                    ),
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
