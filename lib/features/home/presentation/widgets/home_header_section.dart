import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_dashboard_entity.dart';
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
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF05BB51),
                  Color(0xFF03A646),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Positioned(
            top: -20,
            left: -30,
            child: _DecorativeCircle(
              size: 120,
              color: AppColors.white.withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            top: 36,
            right: -20,
            child: _DecorativeCircle(
              size: 88,
              color: AppColors.white.withValues(alpha: 0.06),
            ),
          ),
          Positioned(
            bottom: -16,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
              child: HomeStatsCard(
                progress: dashboard.progress,
                dailyCalories: dashboard.dailyCalories,
                goalCalories: dashboard.goalCalories,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
              child: Column(
                children: [
                  const SizedBox(height: Spacing.sm),
                  Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      _NotificationButton(onTap: onNotificationTap),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            dashboard.greeting,
                            style: getRegularStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size16,
                              color: AppColors.white.withValues(alpha: 0.92),
                            ),
                          ),
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
                      const SizedBox(width: Spacing.sm),
                      const _AvatarCircle(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(Icons.notifications_none_rounded,
                  color: AppColors.textPrimary),
            ),
            Positioned(
              top: 10,
              right: 10,
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
      width: 52,
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.22),
        shape: BoxShape.circle,
      ),
      child: const CircleAvatar(
        backgroundColor: Color(0xFFD6D9D8),
        child: Icon(Icons.person, color: Color(0xFF8C9592), size: 30),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
