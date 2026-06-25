import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_search_bar.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_stats_card.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.dashboard,
    this.onNotificationTap,
  });

  final HomeDashboardEntity dashboard;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const _HeaderBackground(),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const _AvatarCircle(),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dashboard.greeting,
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.ibmPlexSansArabic,
                                    fontSize: FontSize.size15,
                                    color: AppColors.white.withValues(
                                      alpha: 0.95,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dashboard.userName,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.ibmPlexSansArabic,
                                    fontSize: FontSize.size22,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _NotificationButton(onTap: onNotificationTap),
                    ],
                  ),
                 // const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: Spacing.xxl,
                    ),
                    child: HomeStatsCard(
                      progress: dashboard.progress,
                      dailyCalories: dashboard.dailyCalories,
                      goalCalories: dashboard.goalCalories,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Positioned(
            top: 220,
            left: Spacing.base,
            right: Spacing.base,
            child: HomeSearchBar(onTap: () {}),
          ),
        ],
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2FAA45), Color(0xFF20A33E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _LeafPatternPainter()),
          ),
          Positioned(
            top: 52,
            left: -8,
            child: _GlowDot(
              size: 90,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Positioned(
            top: 120,
            right: -24,
            child: _GlowDot(
              size: 118,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowDot extends StatelessWidget {
  const _GlowDot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _LeafPatternPainter extends CustomPainter {
  const _LeafPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.045);

    const step = 54.0;
    for (var y = -step; y < size.height + step; y += step) {
      for (var x = -step; x < size.width + step; x += step) {
        final center = Offset(x + (y / 18).roundToDouble(), y);
        canvas.drawCircle(center, 14, paint);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: 10),
          -0.5,
          1.3,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.22),
        shape: BoxShape.circle,
      ),
      child: const CircleAvatar(
        backgroundColor: Color(0xFFD7DDDB),
        child: Icon(Icons.person, color: Color(0xFF8E9794), size: 31),
      ),
    );
  }
}
