import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_biometric_login_button.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_footer_action.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_login_options_row.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_phone_field.dart';

class AuthSignInPage extends StatefulWidget {
  const AuthSignInPage({super.key, required this.onNavigate});

  final ValueChanged<AuthPageType> onNavigate;

  @override
  State<AuthSignInPage> createState() => _AuthSignInPageState();
}

class _AuthSignInPageState extends State<AuthSignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LoginViewModel>().doIntent(
              const CheckBiometricReadinessEvent(),
            );
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocListener<LoginViewModel, LoginState>(
      listenWhen: (previous, current) =>
          previous.outcome != current.outcome ||
          previous.biometricErrorMessage != current.biometricErrorMessage,
      listener: (context, state) {
        if (state.outcome == LoginOutcome.success) {
          CustomSnackbar.showSuccess(
            context: context,
            message: locale.auth_login_success,
          );

          final phone = state.lastSubmittedRequestPhone;
          final countryCode = state.lastSubmittedRequestCountryCode;
          final passwordText = _passwordController.text;

          final biometricService = getIt<BiometricService>();
          final shouldOfferSetup = !biometricService.isBiometricEnabled() &&
              !biometricService.isBiometricDeferred();

          if (shouldOfferSetup) {
            unawaited(
              biometricService.getCapabilities().then((caps) {
                if (!context.mounted) return;
                if (caps.supportsBiometrics && caps.hasEnrollment) {
                  if (phone != null &&
                      passwordText.isNotEmpty &&
                      countryCode != null) {
                    unawaited(
                      biometricService.saveBiometricCredentials(
                        phone: phone,
                        password: passwordText,
                        countryCode: countryCode,
                      ),
                    );
                  }
                  unawaited(
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.biometricSetup,
                      (route) => false,
                    ),
                  );
                } else {
                  unawaited(
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                      (route) => false,
                    ),
                  );
                }
              }),
            );
          } else {
            unawaited(
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.home,
                (route) => false,
              ),
            );
          }
          return;
        }

        if (state.outcome == LoginOutcome.failure) {
          if (state.failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.failure!,
              ),
            );
          } else if (state.biometricErrorMessage != null &&
              state.biometricErrorMessage!.isNotEmpty) {
            CustomSnackbar.showError(
              context: context,
              message: state.biometricErrorMessage!,
            );
          }
        }
      },
      child: AuthPageShell(
        title: locale.auth_welcome_title,
        subtitle: locale.auth_welcome_subtitle,
        footer: AuthFooterAction(
          prompt: locale.auth_no_account,
          actionText: locale.auth_create_account_link,
          onTap: () => widget.onNavigate(AuthPageType.signUp),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  locale.auth_sign_in_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size24,
                    color: color.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xl),
              AuthPhoneField(controller: _phoneController),
              const SizedBox(height: Spacing.base),
              AuthPasswordField(
                controller: _passwordController,
                validator: (value) =>
                    Validations.validateRequired(context, value),
              ),
              const SizedBox(height: Spacing.sm),
              BlocSelector<LoginViewModel, LoginState, bool>(
                selector: (s) => s.rememberMe,
                builder: (context, rememberMe) => AuthLoginOptionsRow(
                  rememberMe: rememberMe,
                  onRememberMeChanged: (val) {
                    context.read<LoginViewModel>().doIntent(
                          RememberMeChangedEvent(val),
                        );
                  },
                  onForgotPassword: () =>
                      widget.onNavigate(AuthPageType.forgotPassword),
                ),
              ),
              const SizedBox(height: Spacing.xl),
              AppButton(
                variant: AppButtonVariant.filled,
                text: locale.auth_sign_in_button,
                iconWidget: SvgPicture.asset(
                  Assets.loginIcon,
                  width: Spacing.iconSm,
                  height: Spacing.iconSm,
                ),
                onPressed: _handleSubmit,
                color: color.primary,
                gradient: LinearGradient(
                  colors: [color.primary, color.secondary],
                ),
              ),
              const AuthBiometricLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final selectedCallingCode =
        context.read<CallingCodesViewModel>().state.selected;
    if (selectedCallingCode == null) {
      return;
    }
    final phone = normalizeLoginPhone(
      _phoneController.text.trim(),
      selectedCallingCode.dialCode,
    );
    final rememberMe = context.read<LoginViewModel>().state.rememberMe;

    context.read<LoginViewModel>().doIntent(
          SubmitLoginEvent(
            LoginRequestEntity(
              phone: phone,
              password: _passwordController.text,
              countryCode: selectedCallingCode.countryCode,
            ),
            rememberMe: rememberMe,
          ),
        );
  }
}

String normalizeLoginPhone(String phone, String dialCode) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  final dialCodeDigits = dialCode.replaceAll(RegExp(r'\D'), '');
  var localDigits = digits;

  if (phone.trimLeft().startsWith('+') && digits.startsWith(dialCodeDigits)) {
    localDigits = digits.substring(dialCodeDigits.length);
  }

  return '+$dialCodeDigits$localDigits';
}
