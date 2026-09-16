import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_footer_action.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_password_field.dart';

class AuthNewPasswordPage extends StatefulWidget {
  const AuthNewPasswordPage({super.key, required this.onNavigate});

  final ValueChanged<AuthPageType> onNavigate;

  @override
  State<AuthNewPasswordPage> createState() => _AuthNewPasswordPageState();
}

class _AuthNewPasswordPageState extends State<AuthNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthViewModel, AuthState>(
      listenWhen: (previous, current) =>
          previous.resetPassword.isSuccess != current.resetPassword.isSuccess ||
          previous.resetPassword.errorMessage !=
              current.resetPassword.errorMessage,
      listener: (context, state) {
        if (state.resetPassword.isSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: l10n.auth_reset_password_success,
          );
          widget.onNavigate(AuthPageType.signIn);
          return;
        }

        final message = state.resetPassword.errorMessage;
        if (message != null && message.isNotEmpty) {
          CustomSnackbar.showError(context: context, message: message);
        }
      },
      builder: (context, state) {
        return AuthPageShell(
          title: l10n.auth_new_password_title,
          subtitle: l10n.auth_new_password_subtitle,
          topOffset: Spacing.xxl,
          footer: AuthFooterAction(
            prompt: l10n.auth_have_account_prompt,
            actionText: l10n.auth_sign_in_link,
            onTap: () => widget.onNavigate(AuthPageType.signIn),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    l10n.auth_new_password_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size24,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  l10n.auth_new_password_hint,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: AppColors.textSecondary,
                  ).copyWith(height: 1.45),
                ),
                const SizedBox(height: Spacing.xl),
                AuthPasswordField(
                  controller: _passwordController,
                  labelText: l10n.auth_new_password_label,
                  hintText: l10n.auth_new_password_hint_field,
                ),
                const SizedBox(height: Spacing.xl),
                AppButton.filled(
                  text: l10n.auth_new_password_button,
                  iconWidget: SvgPicture.asset(
                    Assets.loginIcon,
                    width: 18,
                    height: 18,
                  ),
                  onPressed: _handleSubmit,
                  color: AppColors.primary,
                  gradient: AppColors.primaryGradient,
                ),
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
    final authState = context.read<AuthViewModel>().state;
    final forgotPasswordData = authState.forgotPassword.data;
    final phone = forgotPasswordData?.phone ?? '';
    final countryCode =
        forgotPasswordData?.countryCode ??
        authState.callingCodes.selected?.countryCode ??
        'KW';
    final otpCode = authState.resetPasswordOtpCode;

    if (phone.isEmpty || otpCode.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: AppLocalizations.of(context)!.error_unknown,
      );
      return;
    }

    context.read<AuthViewModel>().doIntent(
      ResetPasswordEvent(
        ResetPasswordRequestEntity(
          phone: phone,
          otpCode: otpCode,
          newPassword: _passwordController.text,
          countryCode: countryCode,
        ),
      ),
    );
  }
}
