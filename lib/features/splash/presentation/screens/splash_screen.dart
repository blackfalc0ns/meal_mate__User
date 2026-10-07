import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/auth_refresh_service.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/shared/constants/app_ui_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _isRefreshing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppUiConstants.splashDelay, _handleStartupRouting);
  }

  Future<void> _handleStartupRouting() async {
    if (!mounted) return;
    setState(() {
      _errorMessage = null;
    });

    final tokenService = getIt<TokenService>();
    final isRemembered = await tokenService.isRememberedSession();

    if (!isRemembered) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
      return;
    }

    final isExpired = tokenService.isAccessTokenExpired();
    if (!isExpired) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      return;
    }

    // Access token expired -> single refresh
    final refreshToken = await tokenService.getRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      await tokenService.clearSession();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
      return;
    }

    setState(() {
      _isRefreshing = true;
    });

    final refreshService = getIt<AuthRefreshService>();
    final result = await refreshService.refreshSession();

    if (!mounted) return;
    setState(() {
      _isRefreshing = false;
    });

    switch (result) {
      case ApiSuccessResult():
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        return;
      case ApiErrorResult(:final failure):
        final isPermanent =
            failure.exception.errorType == ApiErrorType.unauthorized ||
            failure.exception.errorType == ApiErrorType.forbidden ||
            failure.exception.statusCode == 401 ||
            failure.exception.statusCode == 403;

        if (isPermanent) {
          await tokenService.clearSession();
          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
        } else {
          final message = ErrorMessagePresenter.fromFailure(context, failure);
          setState(() {
            _errorMessage = message;
          });
        }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
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
            const CustomPaint(painter: _SplashArcPainter()),
            const _SplashLogo(),
            if (_isRefreshing)
              const Center(child: CustomProgressIndicator()),
            if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _handleStartupRouting,
                        child: Text(
                          AppLocalizations.of(context)?.retry ?? 'Retry',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const _HomeIndicator(),
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
