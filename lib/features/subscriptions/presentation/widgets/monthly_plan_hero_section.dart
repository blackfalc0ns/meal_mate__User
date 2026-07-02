import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';

class MonthlyPlanHeroSection extends StatelessWidget {
  const MonthlyPlanHeroSection({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const designWidth = 390.0;
        const designHeroHeight = 329.01;
        final screenWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final scale = (screenWidth / designWidth).clamp(0.88, 1.0);
        final heroHeight = designHeroHeight * scale;

        return SizedBox(
          height: heroHeight,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _FigmaZoomedHeroImage(height: heroHeight),
                // DecoratedBox(
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: [
                //         AppColors.white.withValues(alpha: 0),
                //         AppColors.white.withValues(alpha: 0.18),
                //         AppColors.white.withValues(alpha: 0.92),
                //         AppColors.white,
                //       ],
                //       stops: const [0.08, 0.46, 0.78, 1],
                //     ),
                //   ),
                // ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + (31.44 * scale),
                  right: 20 * scale,
                  child: InkWell(
                    onTap: onBack,
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    child: Container(
                      width: 28.82 * scale,
                      height: 28.82 * scale,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + (27.95 * scale),
                  left: 0,
                  right: 0,
                  child: _SmallLogo(scale: scale),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FigmaZoomedHeroImage extends StatelessWidget {
  const _FigmaZoomedHeroImage({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.18,
      child: Image.asset(
        Assets.monthlyPlanHero,
        height: height,
        fit: BoxFit.cover,
        alignment: const Alignment(0, 0.50),
      ),
    );
  }
}

class _SmallLogo extends StatelessWidget {
  const _SmallLogo({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 54 * scale,
          height: 54 * scale,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.restaurant_menu_rounded,
            color: AppColors.primary,
            size: 30 * scale,
          ),
        ),
        RichText(
          text: TextSpan(
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size11 * scale,
              color: AppColors.primaryDark,
            ),
            children: const [
              TextSpan(text: 'Meal'),
              TextSpan(
                text: 'Mate',
                style: TextStyle(color: Color(0xFF5AA925)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
