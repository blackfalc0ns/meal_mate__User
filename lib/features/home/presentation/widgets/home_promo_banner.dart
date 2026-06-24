import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.imageAsset,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final String imageAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9A1A), Color(0xFFF57A10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            right: -12,
            child: _GlowDot(size: 88, color: Colors.white.withValues(alpha: 0.12)),
          ),
          Positioned(
            bottom: -24,
            left: -16,
            child: _GlowDot(size: 110, color: Colors.white.withValues(alpha: 0.06)),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.base),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.right,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size18,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        subtitle,
                        textAlign: TextAlign.right,
                        style: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size13,
                          color: AppColors.white.withValues(alpha: 0.92),
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.lg,
                            vertical: Spacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            buttonLabel,
                            style: getMediumStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size13,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.base),
                _BannerImage(imageAsset: imageAsset),
              ],
            ),
          ),
          Positioned(
            bottom: 14,
            right: 16,
            child: Row(
              children: [
                _IndicatorDot(color: AppColors.white.withValues(alpha: 0.7)),
                const SizedBox(width: 4),
                _IndicatorDot(color: AppColors.white.withValues(alpha: 0.35)),
                const SizedBox(width: 4),
                _IndicatorDot(color: AppColors.primaryDeep),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white.withValues(alpha: 0.4)),
      ),
      child: ClipOval(
        child: Container(
          color: AppColors.white.withValues(alpha: 0.12),
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _IndicatorDot extends StatelessWidget {
  const _IndicatorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _GlowDot extends StatelessWidget {
  const _GlowDot({
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
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
