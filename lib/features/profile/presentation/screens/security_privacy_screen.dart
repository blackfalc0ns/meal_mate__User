import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_settings_section_card.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.profile_security,
        titleFontSize: FontSize.size16,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.profilePrivacyScreenHorizontalPadding,
          ).copyWith(top: Spacing.profilePrivacyContentTopPadding),
          child: Column(
            children: [
              AppSettingsSectionCard(
                title: locale.profile_privacy_security_section,
                icon: Icons.verified_user_rounded,
                tileHeight: Spacing.profilePrivacyPrimaryTileHeight,
                items: [
                  (
                    Icons.lock_rounded,
                    locale.profile_privacy_change_password,
                    locale.profile_privacy_change_password_subtitle,
                    () =>
                        Navigator.of(context).pushNamed(AppRoutes.newPassword),
                  ),
                  (
                    Icons.phone_rounded,
                    locale.profile_privacy_phone_verification,
                    locale.profile_privacy_phone_verification_subtitle,
                    () => Navigator.of(context).pushNamed(AppRoutes.otp),
                  ),
                  (
                    Icons.email_rounded,
                    locale.profile_privacy_email_verification,
                    locale.profile_privacy_email_verification_subtitle,
                    () => Navigator.of(context).pushNamed(AppRoutes.otp),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.profilePrivacySectionGap),
              AppSettingsSectionCard(
                title: locale.profile_privacy_section,
                icon: Icons.shield_rounded,
                tileHeight: Spacing.profilePrivacySecondaryTileHeight,
                items: [
                  (
                    Icons.location_on_rounded,
                    locale.profile_privacy_location_permission,
                    locale.profile_privacy_location_permission_subtitle,
                    () => _showComingSoon(context),
                  ),
                  (
                    Icons.notifications_rounded,
                    locale.profile_privacy_notifications,
                    locale.profile_privacy_notifications_subtitle,
                    () => _showComingSoon(context),
                  ),
                  (
                    Icons.description_rounded,
                    locale.profile_privacy_policy,
                    locale.profile_privacy_policy_subtitle,
                    () => _showComingSoon(context),
                  ),
                  (
                    Icons.fact_check_rounded,
                    locale.profile_privacy_terms,
                    locale.profile_privacy_terms_subtitle,
                    () => _showComingSoon(context),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.profilePrivacySectionGap),
              CustomWarningWidget(
                icon: Icons.gpp_good_rounded,
                title: locale.profile_privacy_permissions_title,
                message: locale.profile_privacy_permissions_message,
              ),
              const SizedBox(height: Spacing.profilePrivacyNoticeGap),
              CustomWarningWidget(
                icon: Icons.lock_rounded,
                title: locale.profile_privacy_password_reminder_title,
                message: locale.profile_privacy_password_reminder_message,
                isWarning: true,
              ),
              const SizedBox(height: Spacing.lg),
              AppButton.filled(
                text: locale.profile_privacy_manage_security,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.newPassword),
                height: Spacing.profilePrivacyButtonHeight,
                borderRadius: Spacing.profilePrivacyButtonRadius,
                color: color.primary,
                textColor: color.onPrimary,
                fontSize: FontSize.size12,
                fontWeight: FontWeightManger.semiBold,
                iconWidget: Icon(
                  Icons.lock_rounded,
                  size: Spacing.md,
                  color: color.onPrimary,
                ),
              ),
              const SizedBox(height: Spacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    final locale = context.localization;

    CustomSnackbar.showInfo(
      context: context,
      message: locale.coming_soon_subtitle,
    );
  }
}
