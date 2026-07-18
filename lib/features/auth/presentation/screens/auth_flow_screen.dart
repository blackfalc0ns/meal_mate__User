import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_background.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_forgot_password_page.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_new_password_page.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_otp_page.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_sign_in_page.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_sign_up_page.dart';

class AuthFlowScreen extends StatefulWidget {
  const AuthFlowScreen({
    super.key,
    this.initialPage = AuthPageType.signIn,
  });

  final AuthPageType initialPage;

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen> {
  late final PageController _pageController;
  late AuthPageType _currentPage;

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

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: PageView(
            controller: _pageController,
            reverse: isRtl,
            physics:NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              _currentPage = AuthPageType.values[index];
            },
            children: [
              AuthSignInPage(onNavigate: _goToPage),
              AuthSignUpPage(onNavigate: _goToPage),
              AuthForgotPasswordPage(onNavigate: _goToPage),
              AuthOtpPage(onNavigate: _goToPage),
              AuthNewPasswordPage(onNavigate: _goToPage),
            ],
          ),
        ),
      ),
    );
  }
}
