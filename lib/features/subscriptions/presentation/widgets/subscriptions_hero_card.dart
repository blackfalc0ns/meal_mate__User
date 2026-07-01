import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';

class SubscriptionsHeroCard extends StatelessWidget {
  const SubscriptionsHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F0),
        borderRadius: BorderRadius.circular(33),
        border: Border.all(color: const Color(0xFFECF1EC)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            end: 6,
            bottom: 14,
            child: SizedBox(
              width: 134,
              height: 103,
              child: Image.asset(
                Assets.subscriptionHeroMeal,
                fit: BoxFit.contain,
              ),
            ),
          ),
          PositionedDirectional(
            start: 12,
            top: 16,
            bottom: 16,
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 23,
                    color: const Color(0xFF418B46),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  //textAlign: TextAlign.left,
                  style: getRegularStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Dot(isActive: true),
                const SizedBox(width: 8),
                _Dot(),
                const SizedBox(width: 8),
                _Dot(),
                const SizedBox(width: 8),
                _Dot(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: isActive ? 24 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0C6C3F) : const Color(0x330C6C3F),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
