import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/helpers/regex.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_footer_action.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_otp_code_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_otp_purpose.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';

class AuthOtpPage extends StatefulWidget {
  const AuthOtpPage({
    super.key,
    required this.onNavigate,
    required this.purpose,
  });

  final ValueChanged<AuthPageType> onNavigate;
  final AuthOtpPurpose purpose;

  @override
  State<AuthOtpPage> createState() => _AuthOtpPageState();
}

class _AuthOtpPageState extends State<AuthOtpPage> {
  Timer? _timer;
  int _secondsLeft = 23;
  String _otpValue = '';
  bool _resendPhoneOtpSuccessShown = false;
  bool _resendPasswordOtpSuccessShown = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = 23;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      if (_secondsLeft == 0) {
        timer.cancel();
        setState(() {});
        return;
      }
      setState(() {
        _secondsLeft -= 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canResend = _secondsLeft == 0;
    final title = widget.purpose == AuthOtpPurpose.resetPassword
        ? l10n.auth_reset_password_otp_title
        : l10n.auth_otp_title;
    final subtitle = widget.purpose == AuthOtpPurpose.resetPassword
        ? l10n.auth_reset_password_otp_subtitle
        : l10n.auth_otp_subtitle;
    final hint = widget.purpose == AuthOtpPurpose.resetPassword
        ? l10n.auth_reset_password_otp_hint
        : l10n.auth_otp_hint;
    final buttonText = widget.purpose == AuthOtpPurpose.resetPassword
        ? l10n.auth_reset_password_otp_button
        : l10n.auth_verify_code_button;

    return BlocConsumer<AuthViewModel, AuthState>(
      listenWhen: (previous, current) =>
          previous.verifyPhone.isSuccess != current.verifyPhone.isSuccess ||
          previous.verifyPhone.errorMessage !=
              current.verifyPhone.errorMessage ||
          previous.resendPhoneOtp.errorMessage !=
              current.resendPhoneOtp.errorMessage ||
          previous.resendPhoneOtp.isSuccess !=
              current.resendPhoneOtp.isSuccess ||
          previous.resendPasswordOtp.errorMessage !=
              current.resendPasswordOtp.errorMessage ||
          previous.resendPasswordOtp.isSuccess !=
              current.resendPasswordOtp.isSuccess,
      listener: (context, state) {
        if (widget.purpose == AuthOtpPurpose.phoneVerification &&
            state.verifyPhone.isSuccess) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
          return;
        }

        final message = state.verifyPhone.errorMessage;
        if (message != null && message.isNotEmpty) {
          CustomSnackbar.showError(context: context, message: message);
        }

        final resendPhoneOtpMessage = state.resendPhoneOtp.errorMessage;
        if (resendPhoneOtpMessage != null && resendPhoneOtpMessage.isNotEmpty) {
          CustomSnackbar.showError(
            context: context,
            message: resendPhoneOtpMessage,
          );
        }

        if (!state.resendPhoneOtp.isSuccess) {
          _resendPhoneOtpSuccessShown = false;
        }
        if (state.resendPhoneOtp.isSuccess && !_resendPhoneOtpSuccessShown) {
          _resendPhoneOtpSuccessShown = true;
          CustomSnackbar.showSuccess(
            context: context,
            message: l10n.auth_otp_resent_success,
          );
        }

        final resendPasswordOtpMessage = state.resendPasswordOtp.errorMessage;
        if (resendPasswordOtpMessage != null &&
            resendPasswordOtpMessage.isNotEmpty) {
          CustomSnackbar.showError(
            context: context,
            message: resendPasswordOtpMessage,
          );
        }

        if (!state.resendPasswordOtp.isSuccess) {
          _resendPasswordOtpSuccessShown = false;
        }
        if (state.resendPasswordOtp.isSuccess &&
            !_resendPasswordOtpSuccessShown) {
          _resendPasswordOtpSuccessShown = true;
          CustomSnackbar.showSuccess(
            context: context,
            message: l10n.auth_otp_resent_success,
          );
        }
      },
      builder: (context, state) {
        return AuthPageShell(
          title: title,
          subtitle: subtitle,
          topOffset: Spacing.xxl,
          footer: AuthFooterAction(
            prompt: l10n.auth_have_account_prompt,
            actionText: l10n.auth_sign_in_link,
            onTap: () => widget.onNavigate(AuthPageType.signIn),
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
                    color: AppColors.textPrimary,
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
                  color: AppColors.textSecondary,
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
                variant: AppButtonVariant.filled,
                text: buttonText,
                isLoading: state.verifyPhone.isLoading,
                iconWidget: SvgPicture.asset(
                  Assets.loginIcon,
                  width: 18,
                  height: 18,
                ),
                onPressed: _handleSubmit,
                color: AppColors.primary,
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D8134), Color(0xFF51C063)],
                ),
              ),
              const SizedBox(height: Spacing.lg),
              Center(
                child: Text(
                  l10n.auth_no_code_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Center(
                child: GestureDetector(
                  onTap: canResend ? _handleResend : null,
                  child: Text(
                    canResend
                        ? l10n.auth_resend_code
                        : '${l10n.auth_resend_code_in} $_secondsLeft ${l10n.auth_seconds_label}',
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: canResend
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSubmit() {
    if (!AppRegExp.isOTPValid(_otpValue)) {
      CustomSnackbar.showError(
        context: context,
        message: AppLocalizations.of(context)!.verification_code_invalid,
      );
      return;
    }
    if (widget.purpose == AuthOtpPurpose.resetPassword) {
      context.read<AuthViewModel>().doIntent(
        SaveResetPasswordOtpCodeEvent(_otpValue),
      );
      widget.onNavigate(AuthPageType.newPassword);
      return;
    }

    final authState = context.read<AuthViewModel>().state;
    final phone = authState.register.data?.phone ?? '';
    final countryCode = authState.callingCodes.selected?.countryCode ?? 'KW';
    if (phone.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: AppLocalizations.of(context)!.error_unknown,
      );
      return;
    }

    context.read<AuthViewModel>().doIntent(
      VerifyPhoneEvent(
        VerifyPhoneRequestEntity(
          phone: phone,
          code: _otpValue,
          countryCode: countryCode,
        ),
      ),
    );
  }

  void _handleResend() {
    final authState = context.read<AuthViewModel>().state;

    switch (widget.purpose) {
      case AuthOtpPurpose.phoneVerification:
        final phone = authState.register.data?.phone ?? '';
        final countryCode =
            authState.callingCodes.selected?.countryCode ?? 'KW';
        if (phone.isEmpty) {
          CustomSnackbar.showError(
            context: context,
            message: AppLocalizations.of(context)!.error_unknown,
          );
          return;
        }

        context.read<AuthViewModel>().doIntent(
          ResendPhoneOtpEvent(
            ResendPhoneOtpRequestEntity(phone: phone, countryCode: countryCode),
          ),
        );

      case AuthOtpPurpose.resetPassword:
        final forgotPasswordData = authState.forgotPassword.data;
        final phone = forgotPasswordData?.phone ?? '';
        final countryCode =
            forgotPasswordData?.countryCode ??
            authState.callingCodes.selected?.countryCode ??
            'KW';
        if (phone.isEmpty) {
          CustomSnackbar.showError(
            context: context,
            message: AppLocalizations.of(context)!.error_unknown,
          );
          return;
        }

        context.read<AuthViewModel>().doIntent(
          ResendPasswordOtpEvent(
            ResendPasswordOtpRequestEntity(
              phone: phone,
              countryCode: countryCode,
            ),
          ),
        );
    }

    _startTimer();
  }
}
