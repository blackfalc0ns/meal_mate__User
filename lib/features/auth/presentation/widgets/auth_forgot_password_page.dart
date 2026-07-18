import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_footer_action.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_phone_field.dart';

class AuthForgotPasswordPage extends StatefulWidget {
  const AuthForgotPasswordPage({super.key, required this.onNavigate});

  final ValueChanged<AuthPageType> onNavigate;

  @override
  State<AuthForgotPasswordPage> createState() => _AuthForgotPasswordPageState();
}

class _AuthForgotPasswordPageState extends State<AuthForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthPageShell(
      title: l10n.auth_reset_password_title,
      subtitle: l10n.auth_reset_password_subtitle,
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
                l10n.auth_reset_password_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size24,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              l10n.auth_reset_password_hint,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size14,
                color: AppColors.textSecondary,
              ).copyWith(height: 1.45),
            ),
            const SizedBox(height: Spacing.xl),
            AuthPhoneField(
              controller: _phoneController,
              validator: (value) =>
                  Validations.validatePhoneNumber(context, value),
            ),
            const SizedBox(height: Spacing.xl),
            AppButton.filled(
              text: l10n.auth_send_otp_button,
              iconWidget: SvgPicture.asset(
                Assets.loginIcon,
                width: Spacing.lg,
                height: Spacing.lg,
              ),
              onPressed: _handleSubmit,
              color: AppColors.primary,
              gradient: AppColors.primaryGradient,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    widget.onNavigate(AuthPageType.otp);
  }
}
