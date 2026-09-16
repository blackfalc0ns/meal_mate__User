import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_view_model.dart';
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

    _pageController.animateToPage(
      page.index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
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

  bool _isLoading(AuthState state) {
    return state.login.isLoading ||
        state.register.isLoading ||
        state.callingCodes.isLoading ||
        state.verifyPhone.isLoading ||
        state.resendPhoneOtp.isLoading ||
        state.forgotPassword.isLoading ||
        state.resetPassword.isLoading ||
        state.resendPasswordOtp.isLoading ||
        state.refreshToken.isLoading ||
        state.logout.isLoading;
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return BlocProvider<AuthViewModel>(
      create: (_) =>
          getIt<AuthViewModel>()..doIntent(const GetCallingCodesEvent()),
      child: Scaffold(
        body: AuthBackground(
          child: SafeArea(
            child: BlocSelector<AuthViewModel, AuthState, bool>(
              selector: _isLoading,
              builder: (context, isLoading) => AuthLoadingOverlay(
                isLoading: isLoading,
                child: BlocBuilder<AuthViewModel, AuthState>(
                  buildWhen: (previous, current) =>
                      previous.callingCodes != current.callingCodes,
                  builder: (context, state) {
                    final showCallingCodesError =
                        !state.callingCodes.isLoading &&
                        state.callingCodes.items.isEmpty &&
                        state.callingCodes.failure != null;

                    if (showCallingCodesError) {
                      return ApiErrorWidget(
                        exception: state.callingCodes.failure!.exception,
                        onRetry: () => context.read<AuthViewModel>().doIntent(
                          const GetCallingCodesEvent(),
                        ),
                        onCheckConnection: () => context
                            .read<AuthViewModel>()
                            .doIntent(const GetCallingCodesEvent()),
                      );
                    }

                    return PageView(
                      controller: _pageController,
                      reverse: isRtl,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
