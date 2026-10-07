import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/password_recovery_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/password_recovery_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/password_recovery_view_model.dart';
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
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocListener<PasswordRecoveryViewModel, PasswordRecoveryState>(
      listenWhen: (previous, current) =>
          previous.outcome != current.outcome ||
          previous.failure != current.failure,
      listener: (context, state) {
        if (state.outcome == PasswordRecoveryOutcome.resetSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: locale.auth_reset_password_success,
          );
          widget.onNavigate(AuthPageType.signIn);
          return;
        }

        if (state.outcome == PasswordRecoveryOutcome.failure &&
            state.failure != null) {
          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.fromFailure(context, state.failure!),
          );
        }
      },
      child: AuthPageShell(
        title: locale.auth_new_password_title,
        subtitle: locale.auth_new_password_subtitle,
        topOffset: Spacing.xxl,
        footer: AuthFooterAction(
          prompt: locale.auth_have_account_prompt,
          actionText: locale.auth_sign_in_link,
          onTap: () => widget.onNavigate(AuthPageType.signIn),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  locale.auth_new_password_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size24,
                    color: color.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                locale.auth_new_password_hint,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurfaceVariant,
                ).copyWith(height: 1.45),
              ),
              const SizedBox(height: Spacing.xl),
              AuthPasswordField(
                controller: _passwordController,
                labelText: locale.auth_new_password_label,
                hintText: locale.auth_new_password_hint_field,
              ),
              const SizedBox(height: Spacing.xl),
              AppButton(
                borderRadius: 50,
                variant: AppButtonVariant.filled,
                text: locale.auth_new_password_button,
                iconWidget: SvgPicture.asset(
                  Assets.loginIcon,
                  width: Spacing.iconSm,
                  height: Spacing.iconSm,
                ),
                onPressed: _handleSubmit,
                color: color.primary,
              ),
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

    context.read<PasswordRecoveryViewModel>().doIntent(
      SubmitResetPasswordEvent(newPassword: _passwordController.text),
    );
  }
}
