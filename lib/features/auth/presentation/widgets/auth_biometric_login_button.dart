import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_view_model.dart';

class AuthBiometricLoginButton extends StatelessWidget {
  const AuthBiometricLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginViewModel, LoginState, bool>(
      selector: (state) => state.isBiometricReady,
      builder: (context, isReady) {
        if (!isReady) {
          return const SizedBox.shrink();
        }

        final color = context.colorScheme;
        final locale = context.localization;

        return Padding(
          padding: const EdgeInsets.only(top: Spacing.md),
          child: AppButton(
            variant: AppButtonVariant.outlined,
            text: locale.biometric_quick_login,
            iconWidget: Icon(
              Icons.fingerprint,
              color: color.primary,
              size: Spacing.iconSm,
            ),
            onPressed: () {
              context.read<LoginViewModel>().doIntent(
                    LoginWithBiometricsEvent(
                      localizedReason: locale.biometric_auth_reason,
                    ),
                  );
            },
            color: color.primary,
          ),
        );
      },
    );
  }
}
