import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/app_settings_section_card.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.profile_settings_title,
        titleFontSize: FontSize.size15,
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
                title: locale.profile_settings_application_section,
                icon: Icons.settings_rounded,
                tileHeight: Spacing.profilePrivacyPrimaryTileHeight,
                trailingIcon: locale.localeName == 'ar'
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                items: [
                  (
                    Icons.notifications_rounded,
                    locale.profile_settings_notifications,
                    locale.profile_settings_notifications_subtitle,
                    null,
                  ),
                  (
                    Icons.language_rounded,
                    locale.profile_settings_language,
                    locale.profile_settings_language_subtitle,
                    null,
                  ),
                  (
                    Icons.palette_rounded,
                    locale.profile_settings_appearance,
                    locale.profile_settings_appearance_subtitle,
                    null,
                  ),
                ],
              ),
              const SizedBox(height: Spacing.profilePrivacySectionGap),
              AppSettingsSectionCard(
                title: locale.profile_settings_support_section,
                icon: Icons.headset_mic_rounded,
                tileHeight: Spacing.profilePrivacyPrimaryTileHeight,
                trailingIcon: locale.localeName == 'ar'
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                items: [
                  (
                    Icons.menu_book_rounded,
                    locale.profile_settings_help_center,
                    locale.profile_settings_help_center_subtitle,
                    null,
                  ),
                  (
                    Icons.forum_rounded,
                    locale.profile_settings_contact_us,
                    locale.profile_settings_contact_us_subtitle,
                    null,
                  ),
                  (
                    Icons.warning_rounded,
                    locale.profile_settings_complaints,
                    locale.profile_settings_complaints_subtitle,
                    null,
                  ),
                ],
              ),
              const SizedBox(height: Spacing.profilePrivacySectionGap),
              AppSettingsSectionCard(
                title: locale.profile_settings_information_section,
                icon: Icons.info_rounded,
                tileHeight: Spacing.profilePrivacySecondaryTileHeight,
                trailingIcon: locale.localeName == 'ar'
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                items: [
                  (
                    Icons.mail_rounded,
                    locale.profile_settings_about,
                    locale.profile_settings_about_subtitle,
                    null,
                  ),
                  (
                    Icons.verified_user_rounded,
                    locale.profile_settings_privacy_policy,
                    locale.profile_settings_privacy_policy_subtitle,
                    null,
                  ),
                  (
                    Icons.description_rounded,
                    locale.profile_settings_terms,
                    locale.profile_settings_terms_subtitle,
                    null,
                  ),
                  (
                    Icons.code_rounded,
                    locale.profile_settings_version,
                    locale.profile_settings_version_subtitle,
                    null,
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                decoration: BoxDecoration(
                  color: color.secondaryContainer,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      size: Spacing.iconSm,
                      color: color.primary,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      locale.profile_settings_version_label,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}
