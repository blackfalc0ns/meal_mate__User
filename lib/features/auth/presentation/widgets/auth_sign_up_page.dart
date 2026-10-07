import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/register_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/register_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/register_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_footer_action.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_phone_field.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_terms_section.dart';

class AuthSignUpPage extends StatefulWidget {
  const AuthSignUpPage({
    super.key,
    required this.onNavigate,
    required this.onOtpSent,
  });

  final ValueChanged<AuthPageType> onNavigate;
  final VoidCallback onOtpSent;

  @override
  State<AuthSignUpPage> createState() => _AuthSignUpPageState();
}

class _AuthSignUpPageState extends State<AuthSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocListener<RegisterViewModel, RegisterState>(
      listenWhen: (previous, current) =>
          previous.outcome != current.outcome ||
          previous.failure != current.failure,
      listener: (context, state) {
        if (state.outcome == RegisterOutcome.registrationSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: locale.auth_register_success,
          );
          widget.onOtpSent();
          return;
        }

        if (state.outcome == RegisterOutcome.failure &&
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
      child: AuthPageShell(
        title: '',
        subtitle: locale.auth_create_account_subtitle,
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
                  locale.auth_create_account_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size24,
                    color: color.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                locale.auth_name_label,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              AppTextField(
                isGlass: true,
                controller: _nameController,
                hint: locale.auth_name_hint,
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: color.primary,
                  size: Spacing.iconSm,
                ),
                validator: (value) =>
                    Validations.validateName(context, value),
              ),
              const SizedBox(height: Spacing.base),
              AuthPhoneField(controller: _phoneController),
              const SizedBox(height: Spacing.base),
              AuthPasswordField(
                controller: _passwordController,
                hintText: locale.password_hint,
              ),
              AuthTermsSection(
                label: locale.auth_terms_label,
                initialValue: _acceptedTerms,
                onChanged: (value) {
                  _acceptedTerms = value;
                },
              ),
              const SizedBox(height: Spacing.xl),
              AppButton(
                variant: AppButtonVariant.filled,
                text: locale.auth_create_account_button,
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
    if (!_acceptedTerms) {
      return;
    }
    final selectedCallingCode = context
        .read<CallingCodesViewModel>()
        .state
        .selected;
    if (selectedCallingCode == null) {
      return;
    }

    context.read<RegisterViewModel>().doIntent(
          SubmitRegisterEvent(
            RegisterRequestEntity(
              fullName: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              password: _passwordController.text,
              countryCode: selectedCallingCode.countryCode,
            ),
          ),
        );
  }
}
