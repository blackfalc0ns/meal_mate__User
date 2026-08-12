import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/auth/presentation/screens/auth_flow_screen.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthFlowScreen(initialPage: AuthPageType.signIn);
  }
}
