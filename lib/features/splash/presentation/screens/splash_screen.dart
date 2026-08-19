import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/shared/constants/app_ui_constants.dart';

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
    _timer = Timer(AppUiConstants.splashDelay, _handleStartupRouting);
  }

  Future<void> _handleStartupRouting() async {
    if (!mounted) return;

    final biometricService = getIt<BiometricService>();
    if (biometricService.canRestoreSession()) {
      final l10n = AppLocalizations.of(context);
      final reason = l10n?.biometric_auth_reason ??
          'Please authenticate to sign in to your account';
      final result = await biometricService.authenticate(
        localizedReason: reason,
      );

      if (!mounted) return;

      if (result.isSuccess) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        return;
      }
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.primary400,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary400,
        body: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _SplashArcPainter()),
            _SplashLogo(),
            _HomeIndicator(),
          ],
        ),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final logoWidth = (width * 0.36).clamp(116.0, 142.0);

    return Center(
      child: Transform.translate(
        offset: const Offset(0, -8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Assets.logoWhite, width: logoWidth),
            const SizedBox(height: 22),
            const Text(
              'Meal Mate',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontFamily: FontConstant.alexandria,
                fontSize: 29,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Center(
        child: Container(
          width: 135,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

class _SplashArcPainter extends CustomPainter {
  const _SplashArcPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary500.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.035
      ..strokeCap = StrokeCap.butt;

    final topCenter = Offset(size.width * 1.18, size.height * 0.68);
    final topRadius = size.width * 1.02;
    for (var i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(
          center: topCenter,
          radius: topRadius + (i * size.width * 0.12),
        ),
        3.84,
        1.28,
        false,
        paint,
      );
    }

    final bottomCenter = Offset(size.width * -0.18, size.height * 0.32);
    final bottomRadius = size.width * 1.08;
    for (var i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(
          center: bottomCenter,
          radius: bottomRadius + (i * size.width * 0.12),
        ),
        5.02,
        1.28,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
