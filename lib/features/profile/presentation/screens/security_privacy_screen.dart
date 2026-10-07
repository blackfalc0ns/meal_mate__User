import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_settings_section_card.dart';
import 'package:meal_meat_user/core/widget/app_settings_tile.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/biometric_cubit.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/biometric_state.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricCubit>(
      create: (_) {
        final cubit = getIt<BiometricCubit>();
        unawaited(cubit.init());
        return cubit;
      },
      child: const _SecurityPrivacyScreenContent(),
    );
  }
}

class _SecurityPrivacyScreenContent extends StatelessWidget {
  const _SecurityPrivacyScreenContent();

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
              BlocConsumer<BiometricCubit, BiometricState>(
                listenWhen: (previous, current) =>
                    previous.isSuccess != current.isSuccess ||
                    previous.errorMessage != current.errorMessage,
                listener: (context, state) {
                  if (state.errorMessage != null &&
                      state.errorMessage!.isNotEmpty) {
                    CustomSnackbar.showError(
                      context: context,
                      message: state.errorMessage!,
                    );
                  } else if (state.isSuccess) {
                    CustomSnackbar.showSuccess(
                      context: context,
                      message: state.isEnabled
                          ? locale.biometric_enabled_success
                          : locale.biometric_disabled_success,
                    );
                  }
                },
                builder: (context, biometricState) {
                  final biometricIcon = switch (biometricState.biometricType) {
                    BiometricTypeEnum.face => Icons.face_rounded,
                    BiometricTypeEnum.fingerprint => Icons.fingerprint_rounded,
                    _ => Icons.fingerprint_rounded,
                  };

                  final biometricTitle = switch (biometricState.biometricType) {
                    BiometricTypeEnum.face => locale.biometric_face_id,
                    BiometricTypeEnum.fingerprint =>
                      locale.biometric_fingerprint,
                    _ => locale.biometric_login_title,
                  };

                  return AppSettingsSectionCard(
                    title: locale.profile_privacy_security_section,
                    icon: Icons.verified_user_rounded,
                    tileHeight: Spacing.profilePrivacyPrimaryTileHeight,
                    customTiles: [
                      AppSettingsTile(
                        icon: Icons.lock_rounded,
                        title: locale.profile_privacy_change_password,
                        subtitle:
                            locale.profile_privacy_change_password_subtitle,
                        showDivider: true,
                        onTap: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.newPassword),
                      ),
                      AppSettingsTile(
                        icon: Icons.phone_rounded,
                        title: locale.profile_privacy_phone_verification,
                        subtitle:
                            locale.profile_privacy_phone_verification_subtitle,
                        showDivider: true,
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.otp),
                      ),
                      AppSettingsTile(
                        icon: Icons.email_rounded,
                        title: locale.profile_privacy_email_verification,
                        subtitle:
                            locale.profile_privacy_email_verification_subtitle,
                        showDivider: true,
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.otp),
                      ),
                      AppSettingsTile(
                        icon: biometricIcon,
                        title: biometricTitle,
                        subtitle: locale.biometric_login_subtitle,
                        showDivider: false,
                        trailingWidget: biometricState.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Switch.adaptive(
                                value: biometricState.isEnabled,
                                activeThumbColor: color.primary,
                                activeTrackColor: color.primary.withValues(
                                  alpha: 0.5,
                                ),
                                onChanged: (value) {
                                  unawaited(
                                    context
                                        .read<BiometricCubit>()
                                        .toggleBiometric(
                                          enable: value,
                                          localizedReason:
                                              locale.biometric_enable_reason,
                                          notSupportedMessage:
                                              locale.biometric_not_supported,
                                          notEnrolledMessage:
                                              locale.biometric_not_enrolled,
                                          lockedOutMessage:
                                              locale.biometric_locked_out,
                                          genericErrorMessage:
                                              locale.biometric_failed,
                                        ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
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
                    () => unawaited(
                      Navigator.of(context).pushNamed(AppRoutes.notifications),
                    ),
                  ),
                  (
                    Icons.description_rounded,
                    locale.profile_privacy_policy,
                    locale.profile_privacy_policy_subtitle,
                    () => unawaited(
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.profilePrivacyPolicy),
                    ),
                  ),
                  (
                    Icons.fact_check_rounded,
                    locale.profile_privacy_terms,
                    locale.profile_privacy_terms_subtitle,
                    () => unawaited(
                      Navigator.of(context).pushNamed(AppRoutes.profileTerms),
                    ),
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
