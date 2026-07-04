import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/app_shell/presentation/widgets/app_zoom_drawer_shell.dart';
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
    final drawerAnimationValue = DrawerAnimationScope.maybeOf(context);
    final profileOpacity = (1 - (drawerAnimationValue * 1.8)).clamp(0.0, 1.0);
    final headerTopPadding = MediaQuery.paddingOf(context).top + 18;

    return SizedBox(
      height: 285,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const _HeaderBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: headerTopPadding),
              Row(
                textDirection: ui.TextDirection.rtl,
                children: [
                  _DrawerMenuButton(onTap: onMenuTap),
                  const SizedBox(width: 18),
                  IgnorePointer(
                    ignoring: profileOpacity == 0,
                    child: Opacity(
                      opacity: profileOpacity,
                      child: _HomeProfileHeader(
                        greeting: dashboard.greeting,
                        userName: dashboard.userName,
                        avatarAsset: Assets.homeFigmaAvatar,
                      ),
                    ),
                  ),
                  const Spacer(),
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

class _HomeProfileHeader extends StatelessWidget {
  const _HomeProfileHeader({
    required this.greeting,
    required this.userName,
    required this.avatarAsset,
  });

  final String greeting;
  final String userName;
  final String avatarAsset;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AvatarCircle(asset: avatarAsset),
            const SizedBox(width: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (greeting.isNotEmpty) ...[
                    Text(
                      greeting,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size12,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size18,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          //  color: AppColors.white.withValues(alpha: 0.14),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.menu_rounded, color: AppColors.white, size: 26),
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
  const _AvatarCircle({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        asset,
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
