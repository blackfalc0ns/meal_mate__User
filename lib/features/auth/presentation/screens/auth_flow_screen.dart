import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/login_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/password_recovery_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/register_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_background.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_forgot_password_page.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_loading_overlay.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_new_password_page.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_otp_page.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_otp_purpose.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_sign_in_page.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_sign_up_page.dart';

class AuthFlowScreen extends StatefulWidget {
  const AuthFlowScreen({super.key, this.initialPage = AuthPageType.signIn});

  final AuthPageType initialPage;

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen> {
  late final PageController _pageController;
  late AuthPageType _currentPage;
  AuthOtpPurpose _otpPurpose = AuthOtpPurpose.phoneVerification;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(AuthPageType page) {
    if (_currentPage == page) {
      return;
    }

    setState(() {
      _currentPage = page;
    });

    unawaited(
      _pageController.animateToPage(
        page.index,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      ),
    );
  }

  void _goToResetPasswordOtp() {
    setState(() {
      _otpPurpose = AuthOtpPurpose.resetPassword;
    });
    _goToPage(AuthPageType.otp);
  }

  void _goToPhoneVerificationOtp() {
    setState(() {
      _otpPurpose = AuthOtpPurpose.phoneVerification;
    });
    _goToPage(AuthPageType.otp);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CallingCodesViewModel>(
          create: (_) =>
              getIt<CallingCodesViewModel>()
                ..doIntent(const LoadCallingCodesEvent()),
        ),
        BlocProvider<LoginViewModel>(
          create: (_) =>
              getIt<LoginViewModel>()
                ..doIntent(const CheckBiometricReadinessEvent()),
        ),
        BlocProvider<RegisterViewModel>(
          create: (_) => getIt<RegisterViewModel>(),
        ),
        BlocProvider<PasswordRecoveryViewModel>(
          create: (_) => getIt<PasswordRecoveryViewModel>(),
        ),
      ],
      child: Scaffold(
        body: AuthBackground(
          child: SafeArea(
            child: Builder(
              builder: (context) {
                final isLoginLoading = context.select<LoginViewModel, bool>(
                  (vm) => vm.state.isLoading,
                );
                final isRegisterLoading = context
                    .select<RegisterViewModel, bool>(
                      (vm) => vm.state.isLoading || vm.state.isResending,
                    );
                final isRecoveryLoading = context
                    .select<PasswordRecoveryViewModel, bool>(
                      (vm) => vm.state.isLoading || vm.state.isResending,
                    );
                final isCallingCodesLoading = context
                    .select<CallingCodesViewModel, bool>(
                      (vm) => vm.state.isLoading && vm.state.items.isEmpty,
                    );
                final isLoading =
                    isLoginLoading ||
                    isRegisterLoading ||
                    isRecoveryLoading ||
                    isCallingCodesLoading;

                return AuthLoadingOverlay(
                  isLoading: isLoading,
                  child: BlocBuilder<CallingCodesViewModel, CallingCodesState>(
                    buildWhen: (previous, current) =>
                        previous.items != current.items ||
                        previous.isLoading != current.isLoading ||
                        previous.failure != current.failure,
                    builder: (context, state) {
                      final showCallingCodesError =
                          !state.isLoading &&
                          state.items.isEmpty &&
                          state.failure != null;

                      if (showCallingCodesError) {
                        return ApiErrorWidget(
                          exception: state.failure!.exception,
                          onRetry: () => context
                              .read<CallingCodesViewModel>()
                              .doIntent(const LoadCallingCodesEvent()),
                          onCheckConnection: () => context
                              .read<CallingCodesViewModel>()
                              .doIntent(const LoadCallingCodesEvent()),
                        );
                      }

                      return PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (index) {
                          _currentPage = AuthPageType.values[index];
                        },
                        children: [
                          AuthSignInPage(onNavigate: _goToPage),
                          AuthSignUpPage(
                            onNavigate: _goToPage,
                            onOtpSent: _goToPhoneVerificationOtp,
                          ),
                          AuthForgotPasswordPage(
                            onNavigate: _goToPage,
                            onOtpSent: _goToResetPasswordOtp,
                          ),
                          AuthOtpPage(
                            onNavigate: _goToPage,
                            purpose: _otpPurpose,
                          ),
                          AuthNewPasswordPage(onNavigate: _goToPage),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
