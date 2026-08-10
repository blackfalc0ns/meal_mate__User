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
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_footer_action.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_otp_code_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';

class AuthOtpPage extends StatefulWidget {
  const AuthOtpPage({super.key, required this.onNavigate});

  final ValueChanged<AuthPageType> onNavigate;

  @override
  State<AuthOtpPage> createState() => _AuthOtpPageState();
}

class _AuthOtpPageState extends State<AuthOtpPage> {
  Timer? _timer;
  int _secondsLeft = 23;
  String _otpValue = '';

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

    return BlocConsumer<AuthViewModel, AuthState>(
      listenWhen: (previous, current) =>
          previous.verifyPhone.isSuccess != current.verifyPhone.isSuccess ||
          previous.verifyPhone.errorMessage != current.verifyPhone.errorMessage,
      listener: (context, state) {
        if (state.verifyPhone.isSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.subscriptionProgramSelection,
            (route) => false,
          );
          return;
        }

        final message = state.verifyPhone.errorMessage;
        if (message != null && message.isNotEmpty) {
          CustomSnackbar.showError(context: context, message: message);
        }
      },
      builder: (context, state) {
        return AuthPageShell(
          title: l10n.auth_otp_title,
          subtitle: l10n.auth_otp_subtitle,
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
                  l10n.auth_otp_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size24,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                l10n.auth_otp_hint,
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
                text: l10n.auth_verify_code_button,
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
                  onTap: canResend ? _startTimer : null,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.verification_code_invalid,
          ),
        ),
      );
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
}
