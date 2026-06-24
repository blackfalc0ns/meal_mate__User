import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/features/onboarding/presentation/widgets/onboarding_action_button.dart';

enum OnboardingPageLayout { topLeft, bottomLeft, bottomCenter }

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.actionColor,
    required this.onActionPressed,
    required this.onSkipPressed,
    required this.activeIndicatorIndex,
    required this.indicatorCount,
    this.layout = OnboardingPageLayout.bottomLeft,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Color actionColor;
  final VoidCallback onActionPressed;
  final VoidCallback onSkipPressed;
  final int activeIndicatorIndex;
  final int indicatorCount;
  final OnboardingPageLayout layout;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black.withValues(alpha: 0.03),
                  Colors.transparent,
                  AppColors.black.withValues(alpha: 0.04),
                ],
              ),
            ),
          ),
        ),
        _buildContent(),
        Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OnboardingActionButton(
                  backgroundColor: AppColors.white,
                  foregroundColor: actionColor,
                  onTap: onActionPressed,
                  onSkipTap: onSkipPressed,
                  activeIndicatorIndex: activeIndicatorIndex,
                  indicatorCount: indicatorCount,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (layout) {
      case OnboardingPageLayout.topLeft:
        return Positioned(
          left: 22,
          right: 22,
          top: 70,
          child: _HeadlineBlock(
            title: title,
            subtitle: subtitle,
            titleStyle: titleStyle,
            subtitleStyle: subtitleStyle,
            textAlign: TextAlign.center,
          ),
        );
      case OnboardingPageLayout.bottomLeft:
        return Positioned(
          left: 24,
          right: 24,
          bottom: 230,
          child: _HeadlineBlock(
            title: title,
            subtitle: subtitle,
            titleStyle: titleStyle,
            subtitleStyle: subtitleStyle,
            textAlign: TextAlign.center,
          ),
        );
      case OnboardingPageLayout.bottomCenter:
        return Positioned(
          left: 24,
          right: 24,
          bottom: 230,
          child: _HeadlineBlock(
            title: title,
            subtitle: subtitle,
            titleStyle: titleStyle,
            subtitleStyle: subtitleStyle,
            textAlign: TextAlign.center,
          ),
        );
    }
  }
}

class _HeadlineBlock extends StatelessWidget {
  const _HeadlineBlock({
    required this.title,
    required this.subtitle,
    required this.textAlign,
    required this.titleStyle,
    required this.subtitleStyle,
  });

  final String title;
  final String subtitle;
  final TextAlign textAlign;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, textAlign: textAlign, style: titleStyle),

        Text(subtitle, textAlign: textAlign, style: subtitleStyle),
      ],
    );
  }
}
