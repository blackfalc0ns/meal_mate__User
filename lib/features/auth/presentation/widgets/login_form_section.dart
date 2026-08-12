import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/country_code_prefix.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/login_password_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/login_remember_forgot_row.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/or_divider.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/social_login_button.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/sign_up_row.dart';

class LoginFormSection extends StatefulWidget {
  const LoginFormSection({super.key});

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // ── White Container with border ──
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: Spacing.base),
          transform: Matrix4.translationValues(0, -30, 0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(Spacing.xl),
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.xl,
              vertical: Spacing.xxl,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Center(
                    child: Text(
                      l10n.login_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),

                  // Phone Number Label
                  Text(
                    l10n.phone_number,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),

                  // Phone Number Field
                  AppTextField(
                    controller: _phoneController,
                    hint: l10n.phone_hint,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(
                      Icons.local_phone_sharp,
                      color: AppColors.primary,
                      size: 25,
                    ),
                    suffixIcon: const CountryCodePrefix(),
                    validator: (value) =>
                        Validations.validatePhoneNumber(context, value),
                  ),
                  const SizedBox(height: Spacing.base),

                  // Password Field
                  LoginPasswordField(controller: _passwordController),
                  const SizedBox(height: Spacing.md),

                  // Remember Me & Forgot Password
                  LoginRememberForgotRow(
                    onForgotPassword: () {
                      // TODO: Navigate to forgot password
                    },
                  ),
                  const SizedBox(height: Spacing.xl),

                  // Login Button
                  AppButton(
                    variant: AppButtonVariant.filled,
                    text: '${l10n.login_button}  ←',
                    onPressed: _onLogin,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: Spacing.base),

                  // Or Divider
                  const OrDivider(),
                  const SizedBox(height: Spacing.base),

                  // Google Login Button
                  SocialLoginButton(onPressed: _onGoogleLogin),
                ],
              ),
            ),
          ),
        ),

        // ── Sign Up Row (outside the white container) ──
        Transform.translate(
          offset: const Offset(0, -8),
          child: const SignUpRow(),
        ),
      ],
    );
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement login logic
    }
  }

  void _onGoogleLogin() {
    // TODO: Implement Google login
  }
}
