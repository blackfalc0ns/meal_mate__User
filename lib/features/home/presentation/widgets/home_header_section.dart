import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_search_bar.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_stats_card.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.dashboard,
    this.onNotificationTap,
    this.onMenuTap,
  });

  final HomeDashboardEntity dashboard;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 285,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const _HeaderBackground(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 34, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  textDirection: ui.TextDirection.rtl,
                  children: [
                    _DrawerMenuButton(onTap: onMenuTap),
                    const Spacer(),
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
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size12,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dashboard.userName,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size18,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    _NotificationButton(onTap: onNotificationTap),
                  ],
                ),
                const SizedBox(height: 17),
                HomeStatsCard(
                  progress: dashboard.progress,
                  dailyCalories: dashboard.dailyCalories,
                  goalCalories: dashboard.goalCalories,
                ),
              ],
            ),
          ),
          Positioned(
            top: 235,
            left: 20,
            right: 20,
            child: HomeSearchBar(onTap: () {}),
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuButton extends StatelessWidget {
  const _DrawerMenuButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.14),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.menu_rounded,
          color: AppColors.white,
          size: 26,
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 262,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(11),
        ),
        child: Container(
          color: const Color(0xFF32983C),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  Assets.homeFigmaHeaderDoodle,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.3),
                  errorBuilder: (_, _, _) =>
                      const CustomPaint(painter: _LeafPatternPainter()),
                ),
              ),
              Positioned(
                top: 88,
                right: -74,
                child: _GlowDot(
                  size: 152,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              Positioned(
                bottom: -44,
                left: -35,
                child: _GlowDot(
                  size: 126,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ],
          ),
        ),
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
      child: SizedBox(
        width: 29,
        height: 28,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned(
              left: 0,
              bottom: 0,
              child: Icon(
                Icons.notifications_rounded,
                color: AppColors.textPrimary,
                size: 29,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 8,
                height: 8,
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
      width: 50,
      height: 50,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        Assets.homeFigmaAvatar,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return const CircleAvatar(
            backgroundColor: Color(0xFFD7DDDB),
            child: Icon(Icons.person, color: Color(0xFF8E9794), size: 31),
          );
        },
      ),
    );
  }
}
