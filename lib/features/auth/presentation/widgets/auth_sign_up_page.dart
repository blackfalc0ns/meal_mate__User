import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_footer_action.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_phone_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_terms_section.dart';

class AuthSignUpPage extends StatefulWidget {
  const AuthSignUpPage({super.key, required this.onNavigate});

  final ValueChanged<AuthPageType> onNavigate;

  @override
  State<AuthSignUpPage> createState() => _AuthSignUpPageState();
}

class _AuthSignUpPageState extends State<AuthSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthPageShell(
      title: l10n.auth_create_account_title,
      subtitle: l10n.auth_create_account_subtitle,
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
                l10n.auth_create_account_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size24,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                l10n.auth_name_label,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            AppTextField(
              isGlass: true,
              controller: _nameController,
              hint: l10n.auth_name_hint,
              prefixIcon: const Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: 23,
              ),
              validator: (value) => Validations.validateName(context, value),
            ),
            const SizedBox(height: Spacing.base),
            AuthPhoneField(controller: _phoneController),
            const SizedBox(height: Spacing.base),
            AuthPasswordField(
              controller: _passwordController,
              hintText: l10n.password_hint,
            ),

            AuthTermsSection(
              label: l10n.auth_terms_label,
              initialValue: _acceptedTerms,
              onChanged: (value) {
                _acceptedTerms = value;
              },
            ),
            const SizedBox(height: Spacing.xl),
            AppButton(
              variant: AppButtonVariant.filled,
              text: l10n.auth_create_account_button,
              iconWidget: SvgPicture.asset(
                Assets.loginIcon,
                width: 18,
                height: 18,
              ),
              onPressed: _handleSubmit,
              color: AppColors.primary,
              gradient: LinearGradient(
                colors: [Color(0xFF1D8134), Color(0xFF51C063)],
              ),
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
    if (!_acceptedTerms) {
      return;
    }
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }
}
