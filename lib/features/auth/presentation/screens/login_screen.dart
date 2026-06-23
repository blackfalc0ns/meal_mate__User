import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/login_form_section.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/login_top_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background image (top only, not stretched) ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.42,
            child: Image.asset(
              Assets.bgRegister,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // ── Content ──
          const SingleChildScrollView(
            child: Column(
              children: [
                // ── Top Section (logo + welcome text) ──
                LoginTopSection(),

                // ── Form Section ──
                LoginFormSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
