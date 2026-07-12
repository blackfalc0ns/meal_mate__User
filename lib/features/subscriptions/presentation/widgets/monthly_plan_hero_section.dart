import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanHeroSection extends StatelessWidget {
  const MonthlyPlanHeroSection({
    super.key,
    required this.plan,
    required this.imageAsset,
    required this.onBack,
  });

  final MonthlyPlanDetailsEntity plan;
  final String imageAsset;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const designWidth = 390.0;
        const designHeroHeight = 520.0;
        final screenWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final scale = (screenWidth / designWidth).clamp(0.88, 1.0);
        final heroHeight = designHeroHeight * scale;

        return SizedBox(
          height: heroHeight,
          child: Stack(
            children: [
              MonthlyPlanHeroBackground(imageAsset: imageAsset, onBack: onBack),
              Positioned(
                left: 0,
                right: 0,
                top: 366 * scale,
                child: MonthlyPlanHeroSummary(plan: plan),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MonthlyPlanHeroBackground extends StatelessWidget {
  const MonthlyPlanHeroBackground({
    super.key,
    required this.imageAsset,
    required this.onBack,
    this.showBackButton = true,
  });

  final String imageAsset;
  final VoidCallback onBack;
  final bool showBackButton;

  static const designWidth = 390.0;
  static const designHeroHeight = 520.0;
  static const summaryTop = 366.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                _FigmaZoomedHeroImage(
                  width: screenWidth,
                  imageAsset: imageAsset,
                ),
                const _HeroWhiteFade(),
                if (showBackButton)
                  MonthlyPlanHeroBackButton(scale: scale, onBack: onBack),
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

class _HeroWhiteFade extends StatelessWidget {
  const _HeroWhiteFade();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.white.withValues(alpha: 0),
            AppColors.white.withValues(alpha: 0.18),
            AppColors.white.withValues(alpha: 0.68),
            AppColors.white,
            AppColors.white,
          ],
          stops: const [0.15, 0.50, 0.65, 0.78, 1],
        ),
      ),
    );
  }
}

class MonthlyPlanHeroBackButton extends StatelessWidget {
  const MonthlyPlanHeroBackButton({
    super.key,
    required this.scale,
    required this.onBack,
  });

  final double scale;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + (31.44 * scale),
      right: 24 * scale,
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
          child: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ),
      ),
    );
  }
}

class _FigmaZoomedHeroImage extends StatelessWidget {
  const _FigmaZoomedHeroImage({required this.width, required this.imageAsset});

  final double width;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: width * -0.2074,
      top: width * -0.5374,
      width: width * 1.4161,
      height: width * 2.1743,
      child: Image.asset(
        imageAsset,
        fit: BoxFit.cover,
        alignment: Alignment.center,
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
        SvgPicture.asset(
          Assets.logoWhite,
          width: 61 * scale,
          height: 58 * scale,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
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

class MonthlyPlanHeroSummary extends StatelessWidget {
  const MonthlyPlanHeroSummary({super.key, required this.plan});

  final MonthlyPlanDetailsEntity plan;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = (screenWidth / MonthlyPlanHeroBackground.designWidth).clamp(
      0.88,
      1.0,
    );

    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 68 * scale,
              color: AppColors.black,
            ).copyWith(height: 0.88),
            children: [
              TextSpan(text: '${plan.titlePrefix} '),
              TextSpan(
                text: plan.titleHighlight,
                style: const TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
        SizedBox(height: 17 * scale),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PlanMeta(
              icon: Icons.restaurant,
              text: plan.mealsPerDay,
              scale: scale,
            ),
            SizedBox(width: 14 * scale),
            Container(
              width: 1,
              height: 18 * scale,
              color: AppColors.appTextMuted,
            ),
            SizedBox(width: 14 * scale),
            _PlanMeta(
              icon: Icons.calendar_month_outlined,
              text: plan.duration,
              scale: scale,
            ),
          ],
        ),
        SizedBox(height: 20 * scale),
        Container(
          height: 43 * scale,
          padding: EdgeInsets.symmetric(horizontal: 22 * scale),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14.8 * scale),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.percent_rounded,
                color: AppColors.white,
                size: 21 * scale,
              ),
              SizedBox(width: 6 * scale),
              Text(
                plan.discountLabel,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: 15.8 * scale,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanMeta extends StatelessWidget {
  const _PlanMeta({
    required this.icon,
    required this.text,
    required this.scale,
  });

  final IconData icon;
  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 21 * scale, color: AppColors.appTextMuted),
        SizedBox(width: 6 * scale),
        Text(
          text,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: 13.6 * scale,
            color: AppColors.appTextMuted,
          ),
        ),
      ],
    );
  }
}
