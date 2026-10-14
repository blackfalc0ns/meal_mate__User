import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/password_recovery_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/password_recovery_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/password_recovery_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/register_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/register_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/register_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_footer_action.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_otp_code_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_otp_countdown.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_otp_purpose.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';

class AuthOtpPage extends StatefulWidget {
  const AuthOtpPage({
    super.key,
    required this.onNavigate,
    required this.purpose,
    this.retryAvailableAtUtc,
  });

  final ValueChanged<AuthPageType> onNavigate;
  final AuthOtpPurpose purpose;
  final DateTime? retryAvailableAtUtc;

  @override
  State<AuthOtpPage> createState() => _AuthOtpPageState();
}

class _AuthOtpPageState extends State<AuthOtpPage> {
  String _otpValue = '';
  late DateTime _fallbackDeadline;

  @override
  void initState() {
    super.initState();
    _fallbackDeadline = DateTime.now().toUtc().add(const Duration(seconds: 60));
  }

  @override
  void didUpdateWidget(covariant AuthOtpPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.purpose != widget.purpose) {
      _otpValue = '';
      _fallbackDeadline = DateTime.now().toUtc().add(
        const Duration(seconds: 60),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isReset = widget.purpose == AuthOtpPurpose.resetPassword;
    final isFamily = widget.purpose == AuthOtpPurpose.familyFirstLogin;

    final retryAvailableAtUtc =
        widget.retryAvailableAtUtc ??
        (isReset
            ? context.select<PasswordRecoveryViewModel, DateTime?>(
                    (vm) => vm.state.retryAvailableAtUtc,
                  ) ??
                  _fallbackDeadline
            : context.select<RegisterViewModel, DateTime?>(
                    (vm) => vm.state.retryAvailableAtUtc,
                  ) ??
                  _fallbackDeadline);

    final isResending = isReset
        ? context.select<PasswordRecoveryViewModel, bool>(
            (vm) => vm.state.isResending,
          )
        : context.select<RegisterViewModel, bool>((vm) => vm.state.isResending);

    final title = isFamily
        ? locale.auth_family_first_login_otp_title
        : (isReset
              ? locale.auth_reset_password_otp_title
              : locale.auth_otp_title);
    final subtitle = isFamily
        ? locale.auth_family_first_login_otp_subtitle
        : (isReset
              ? locale.auth_reset_password_otp_subtitle
              : locale.auth_otp_subtitle);
    final hint = isFamily
        ? locale.auth_family_first_login_otp_hint
        : (isReset
              ? locale.auth_reset_password_otp_hint
              : locale.auth_otp_hint);
    final buttonText = isReset
        ? locale.auth_reset_password_otp_button
        : locale.auth_verify_code_button;

    final content = AuthPageShell(
      title: title,
      subtitle: subtitle,
      topOffset: Spacing.xxl,
      footer: AuthFooterAction(
        prompt: locale.auth_have_account_prompt,
        actionText: locale.auth_sign_in_link,
        onTap: () {
          if (isFamily) {
            context.read<LoginViewModel>().doIntent(
              const ResetFamilyFirstLoginFlowEvent(),
            );
          }
          widget.onNavigate(AuthPageType.signIn);
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              title,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size24,
                color: color.onSurface,
              ),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurfaceVariant,
            ).copyWith(height: 1.45),
          ),
          const SizedBox(height: Spacing.xl),
          AuthOtpCodeField(
            onChanged: (value) {
              _otpValue = value;
            },
          ),
          const SizedBox(height: Spacing.xl),
          AppButton(
            borderRadius: 50,
            variant: AppButtonVariant.filled,
            text: buttonText,
            iconWidget: SvgPicture.asset(
              Assets.loginIcon,
              width: Spacing.iconSm,
              height: Spacing.iconSm,
            ),
            onPressed: _handleSubmit,
            color: color.primary,
          ),
          if (!isFamily) ...[
            const SizedBox(height: Spacing.lg),
            Center(
              child: Text(
                locale.auth_no_code_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xs),
            AuthOtpCountdown(
              retryAvailableAtUtc: retryAvailableAtUtc,
              onResend: _handleResend,
              isResending: isResending,
            ),
          ],
        ],
      ),
    );

    if (isFamily) {
      return BlocListener<LoginViewModel, LoginState>(
        listenWhen: (previous, current) =>
            previous.outcome != current.outcome ||
            previous.failure != current.failure,
        listener: (context, state) {
          if (state.outcome == LoginOutcome.failure && state.failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.failure!,
              ),
            );
          }
        },
        child: content,
      );
    }

    if (isReset) {
      return BlocListener<PasswordRecoveryViewModel, PasswordRecoveryState>(
        listenWhen: (previous, current) =>
            previous.outcome != current.outcome ||
            previous.failure != current.failure ||
            previous.resendOtpSent != current.resendOtpSent,
        listener: (context, state) {
          if (state.resendOtpSent) {
            CustomSnackbar.showSuccess(
              context: context,
              message: locale.auth_otp_resent_success,
            );
          }

          if (state.outcome == PasswordRecoveryOutcome.failure &&
              state.failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.failure!,
              ),
            );
          }
        },
        child: content,
      );
    }

    return BlocListener<RegisterViewModel, RegisterState>(
      listenWhen: (previous, current) =>
          previous.outcome != current.outcome ||
          previous.failure != current.failure ||
          previous.resendOtpSent != current.resendOtpSent,
      listener: (context, state) {
        if (state.outcome == RegisterOutcome.phoneVerifiedSuccess) {
          unawaited(
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
          );
          return;
        }

        if (state.resendOtpSent) {
          CustomSnackbar.showSuccess(
            context: context,
            message: locale.auth_otp_resent_success,
          );
        }

        if (state.outcome == RegisterOutcome.failure && state.failure != null) {
          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.fromFailure(context, state.failure!),
          );
        }
      },
      child: content,
    );
  }

  void _handleSubmit() {
    final otpError = Validations.validOtp(context, _otpValue);
    if (otpError != null) {
      CustomSnackbar.showError(context: context, message: otpError);
      return;
    }

    if (widget.purpose == AuthOtpPurpose.familyFirstLogin) {
      context.read<LoginViewModel>().doIntent(
        VerifyFamilyFirstLoginOtpEvent(_otpValue),
      );
      return;
    }

    if (widget.purpose == AuthOtpPurpose.resetPassword) {
      context.read<PasswordRecoveryViewModel>().doIntent(
        SaveRecoveryOtpEvent(_otpValue),
      );
      widget.onNavigate(AuthPageType.newPassword);
      return;
    }

    context.read<RegisterViewModel>().doIntent(
      VerifyRegisterPhoneEvent(_otpValue),
    );
  }

  void _handleResend() {
    if (widget.purpose == AuthOtpPurpose.resetPassword) {
      context.read<PasswordRecoveryViewModel>().doIntent(
        const ResendRecoveryOtpEvent(),
      );
    } else {
      context.read<RegisterViewModel>().doIntent(
        const ResendRegisterOtpEvent(),
      );
    }
  }
}
