import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/biometric/biometric_credentials.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_footer_action.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_login_options_row.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_phone_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/biometric_prompt_sheet.dart';

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
        context.read<AuthViewModel>().doIntent(const InitBiometricEvent());
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
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthViewModel, AuthState>(
      listenWhen: (previous, current) =>
          previous.login.isSuccess != current.login.isSuccess ||
          previous.login.errorMessage != current.login.errorMessage ||
          previous.biometric.errorMessage != current.biometric.errorMessage,
      listener: (context, state) {
        if (state.login.isSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: l10n.auth_login_success,
          );

          if (state.biometric.isSuccess) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            return;
          }

          final selectedCallingCode = context
              .read<AuthViewModel>()
              .state
              .callingCodes
              .selected;
          final phoneText = _phoneController.text.trim();
          final passwordText = _passwordController.text;
          final phone = phoneText.isNotEmpty
              ? normalizeLoginPhone(
                  phoneText,
                  selectedCallingCode?.dialCode ?? '+20',
                )
              : null;
          final password = passwordText.isNotEmpty ? passwordText : null;
          final countryCode = selectedCallingCode?.countryCode ?? 'EG';

          BiometricPromptSheet.showIfNeeded(
            context,
            credentials: (phone != null && password != null)
                ? BiometricCredentials(
                    phone: phone,
                    password: password,
                    countryCode: countryCode,
                  )
                : null,
            onComplete: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            },
          );
          return;
        }

        final message = state.login.errorMessage;
        if (message != null && message.isNotEmpty) {
          CustomSnackbar.showError(context: context, message: message);
        }

        final biometricError = state.biometric.errorMessage;
        if (biometricError != null && biometricError.isNotEmpty) {
          CustomSnackbar.showError(context: context, message: biometricError);
        }
      },
      builder: (context, state) {
        return AuthPageShell(
          title: l10n.auth_welcome_title,
          subtitle: l10n.auth_welcome_subtitle,
          footer: AuthFooterAction(
            prompt: l10n.auth_no_account,
            actionText: l10n.auth_create_account_link,
            onTap: () => widget.onNavigate(AuthPageType.signUp),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    l10n.auth_sign_in_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size24,
                      color: AppColors.textPrimary,
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
                AuthLoginOptionsRow(
                  onForgotPassword: () =>
                      widget.onNavigate(AuthPageType.forgotPassword),
                ),
                const SizedBox(height: Spacing.xl),
                AppButton(
                  variant: AppButtonVariant.filled,
                  text: l10n.auth_sign_in_button,
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
                if (state.biometric.canOfferBiometric) ...[
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    variant: AppButtonVariant.outlined,
                    text: state.biometric.getBiometricButtonText(l10n),
                    isLoading:
                        state.biometric.isLoading || state.login.isLoading,
                    iconWidget: Icon(
                      state.biometric.biometricIcon,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onPressed: () {
                      context.read<AuthViewModel>().doIntent(
                            AuthenticateWithBiometricEvent(
                              localizedReason: l10n.biometric_auth_reason,
                              lockedOutMessage: l10n.biometric_locked_out,
                              permanentlyLockedOutMessage:
                                  l10n.biometric_permanently_locked_out,
                              notEnrolledMessage:
                                  l10n.biometric_not_enrolled,
                              genericErrorMessage: l10n.biometric_failed,
                            ),
                          );
                    },
                    color: AppColors.primary,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final selectedCallingCode = context
        .read<AuthViewModel>()
        .state
        .callingCodes
        .selected;
    final phone = normalizeLoginPhone(
      _phoneController.text.trim(),
      selectedCallingCode?.dialCode ?? '+20',
    );

    context.read<AuthViewModel>().doIntent(
      LoginCustomerEvent(
        LoginRequestEntity(
          phone: phone,
          password: _passwordController.text,
          countryCode: selectedCallingCode?.countryCode ?? 'EG',
        ),
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
