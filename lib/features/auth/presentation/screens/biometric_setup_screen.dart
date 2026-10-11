import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/biometric_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/biometric_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/biometric_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_loading_overlay.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/biometric_method_tile.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/biometric_privacy_notice.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/biometric_setup_benefits.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/biometric_setup_hero.dart';

class BiometricSetupScreen extends StatelessWidget {
  const BiometricSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricViewModel>(
      create: (_) {
        final vm = getIt<BiometricViewModel>();
        vm.doIntent(const InitBiometricEvent());
        return vm;
      },
      child: Builder(
        builder: (context) {
          final color = context.colorScheme;
          final locale = context.localization;

          return BlocConsumer<BiometricViewModel, BiometricState>(
            listenWhen: (previous, current) =>
                previous.isSuccess != current.isSuccess ||
                previous.authStatus != current.authStatus ||
                previous.errorMessage != current.errorMessage,
            listener: (context, state) {
              if (state.isSuccess && state.isEnabled) {
                CustomSnackbar.showSuccess(
                  context: context,
                  message: locale.biometric_enabled_success,
                );
                unawaited(
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
                );
                return;
              }

              if (state.authStatus != null &&
                  state.authStatus != BiometricAuthStatus.success &&
                  state.authStatus != BiometricAuthStatus.canceled) {
                final message = switch (state.authStatus!) {
                  BiometricAuthStatus.notAvailable =>
                    locale.biometric_not_supported,
                  BiometricAuthStatus.notEnrolled =>
                    locale.biometric_not_enrolled,
                  BiometricAuthStatus.lockedOut ||
                  BiometricAuthStatus.permanentlyLockedOut =>
                    locale.biometric_locked_out,
                  _ => state.errorMessage ?? locale.biometric_failed,
                };
                CustomSnackbar.showError(context: context, message: message);
              }
            },
            builder: (context, state) {
              final isAvailable = state.isSupported && state.hasEnrollment;

              return Scaffold(
                backgroundColor: color.surface,
                body: AuthLoadingOverlay(
                  isLoading: state.isLoading,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xl,
                        vertical: Spacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: Spacing.lg),
                          BiometricSetupHero(
                            presentationType: state.biometricType,
                          ),
                          const SizedBox(height: Spacing.xl),
                          BiometricMethodTile(
                            presentationType: state.biometricType,
                            isAvailable: isAvailable,
                          ),
                          const SizedBox(height: Spacing.lg),
                          const BiometricSetupBenefits(),
                          const SizedBox(height: Spacing.lg),
                          const BiometricPrivacyNotice(),
                          const SizedBox(height: Spacing.xl),
                          AppButton(
                            variant: AppButtonVariant.filled,
                            text: locale.biometric_enable_button,
                            onPressed: () {
                              context.read<BiometricViewModel>().doIntent(
                                ToggleBiometricEvent(
                                  enable: true,
                                  localizedReason:
                                      locale.biometric_enable_reason,
                                ),
                              );
                            },
                            color: color.primary,
                            gradient: LinearGradient(
                              colors: [color.primary, color.secondary],
                            ),
                          ),
                          const SizedBox(height: Spacing.sm),
                          TextButton(
                            onPressed: () {
                              context.read<BiometricViewModel>().doIntent(
                                const DeferBiometricEvent(),
                              );
                              unawaited(
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRoutes.home,
                                  (route) => false,
                                ),
                              );
                            },
                            child: Text(
                              locale.biometric_skip_button,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size14,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            locale.biometric_settings_footer_note,
                            textAlign: TextAlign.center,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.md),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
