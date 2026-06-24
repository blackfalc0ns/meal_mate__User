import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/shared/constants/app_ui_constants.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';
import 'package:meal_meat_user/shared/widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppUiConstants.splashDelay, () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _SplashBackground(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppUiConstants.maxContentWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppLogo(
                        size: AppUiConstants.splashLogoSize,
                        showTagline: true,
                        alignment: CrossAxisAlignment.center,
                      ),
                      const SizedBox(height: Spacing.lg),
                      Text(
                        'ابدأ رحلتك الغذائية الذكية',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: Spacing.xxxl),
                      const LoadingIndicator(size: 26),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8FFF8),
                AppColors.white,
                Color(0xFFEAF7EA),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Opacity(
          opacity: AppUiConstants.splashIllustrationOpacity,
          child: Image.asset(
            Assets.bgRegister,
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: _GlowCircle(size: 180),
        ),
        Positioned(
          bottom: -70,
          left: -50,
          child: _GlowCircle(size: 160),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.primarySurface.withValues(alpha: 0.55),
            AppColors.primarySurface.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
