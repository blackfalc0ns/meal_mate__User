import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/services/app_locale_notifier.dart';
import 'package:meal_meat_user/core/services/language_service.dart';
import 'package:meal_meat_user/core/utils/constants.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/app_settings_section_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_app_version_footer.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_language_bottom_sheet.dart';

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
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
                items: [
                  (
                    Icons.notifications_rounded,
                    locale.profile_settings_notifications,
                    locale.profile_settings_notifications_subtitle,
                    () => unawaited(
                      Navigator.of(context).pushNamed(AppRoutes.notifications),
                    ),
                  ),
                  (
                    Icons.language_rounded,
                    locale.profile_settings_language,
                    locale.profile_settings_language_subtitle,
                    () => _showLanguageSheet(context),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.profilePrivacySectionGap),
              AppSettingsSectionCard(
                title: locale.profile_settings_support_section,
                icon: Icons.headset_mic_rounded,
                tileHeight: Spacing.profilePrivacyPrimaryTileHeight,
                trailingIcon: locale.localeName == 'ar'
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
                items: [
                  (
                    Icons.menu_book_rounded,
                    locale.profile_settings_help_center,
                    locale.profile_settings_help_center_subtitle,
                    () => unawaited(
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.profileHelpCenter),
                    ),
                  ),
                  (
                    Icons.forum_rounded,
                    locale.profile_settings_contact_us,
                    locale.profile_settings_contact_us_subtitle,
                    () => unawaited(
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.profileContactUs),
                    ),
                  ),
                  (
                    Icons.warning_rounded,
                    locale.profile_settings_complaints,
                    locale.profile_settings_complaints_subtitle,
                    () => unawaited(
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.profileComplaints),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.profilePrivacySectionGap),
              AppSettingsSectionCard(
                title: locale.profile_settings_information_section,
                icon: Icons.info_rounded,
                tileHeight: Spacing.profilePrivacySecondaryTileHeight,
                trailingIcon: locale.localeName == 'ar'
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
                items: [
                  (
                    Icons.mail_rounded,
                    locale.profile_settings_about,
                    locale.profile_settings_about_subtitle,
                    () => unawaited(
                      Navigator.of(context).pushNamed(AppRoutes.profileAbout),
                    ),
                  ),
                  (
                    Icons.verified_user_rounded,
                    locale.profile_settings_privacy_policy,
                    locale.profile_settings_privacy_policy_subtitle,
                    () => unawaited(
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.profilePrivacyPolicy),
                    ),
                  ),
                  (
                    Icons.description_rounded,
                    locale.profile_settings_terms,
                    locale.profile_settings_terms_subtitle,
                    () => unawaited(
                      Navigator.of(context).pushNamed(AppRoutes.profileTerms),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              const ProfileAppVersionFooter(),
              const SizedBox(height: Spacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLanguageSheet(BuildContext context) async {
    final languageService = getIt<LanguageService>();
    final selectedCode = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      builder: (context) => ProfileLanguageBottomSheet(
        selectedCode: languageService.getLanguageCode(),
      ),
    );

    if (selectedCode == null ||
        selectedCode == languageService.getLanguageCode()) {
      return;
    }

    await languageService.saveLanguageCode(selectedCode);

    appLocaleNotifier.value = Locale(
      selectedCode == AppConstants.enKey
          ? AppConstants.enKey
          : AppConstants.arKey,
    );
  }
}
