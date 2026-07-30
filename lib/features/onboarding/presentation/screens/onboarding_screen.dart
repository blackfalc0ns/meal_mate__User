import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/onboarding/presentation/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSignIn() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
  }

  List<_OnboardingSlideData> _buildSlides(AppLocalizations l10n) {
    return [
      _OnboardingSlideData(
        imagePath: Assets.onboardingOne,
        title: 'MealMate',
        subtitle: l10n.onboarding_first_subtitle,
        actionColor: const Color(0xFFF47C12),
        layout: OnboardingPageLayout.bottomLeft,
        titleStyle: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size69,
          color: AppColors.white,
        ),
        subtitleStyle: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size30,
          color: AppColors.white,
        ),
      ),
      _OnboardingSlideData(
        imagePath: Assets.onboardingThree,
        title: l10n.onboarding_second_title,
        subtitle: l10n.onboarding_second_subtitle,
        actionColor: const Color(0xFFB37D00),
        layout: OnboardingPageLayout.bottomCenter,
        titleStyle: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size33,
          color: AppColors.black,
        ),
        subtitleStyle: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size36,
          color: AppColors.white,
        ),
      ),
      _OnboardingSlideData(
        imagePath: Assets.onboardingTwo,
        title: l10n.onboarding_third_title,
        subtitle: l10n.onboarding_third_subtitle,
        actionColor: const Color(0xFF0F8C45),
        layout: OnboardingPageLayout.topLeft,
        titleStyle: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size36,
          color: AppColors.black,
        ),
        subtitleStyle: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size33,
          color: AppColors.white,
        ),
      ),
    ];
  }

  void _handleAction(List<_OnboardingSlideData> slides) {
    if (_currentPage >= slides.length - 1) {
      _goToSignIn();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final slides = _buildSlides(l10n);

    return Scaffold(
      body: _OnboardingPagerSection(
        pageController: _pageController,
        slides: slides,
        currentPage: _currentPage,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        onActionPressed: () => _handleAction(slides),
        onSkipPressed: _goToSignIn,
      ),
    );
  }
}

class _OnboardingPagerSection extends StatelessWidget {
  const _OnboardingPagerSection({
    required this.pageController,
    required this.slides,
    required this.currentPage,
    required this.onPageChanged,
    required this.onActionPressed,
    required this.onSkipPressed,
  });

  final PageController pageController;
  final List<_OnboardingSlideData> slides;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onActionPressed;
  final VoidCallback onSkipPressed;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: slides.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final slide = slides[index];
        return OnboardingPage(
          imagePath: slide.imagePath,
          title: slide.title,
          subtitle: slide.subtitle,
          titleStyle: slide.titleStyle,
          subtitleStyle: slide.subtitleStyle,
          actionColor: slide.actionColor,
          onActionPressed: onActionPressed,
          onSkipPressed: onSkipPressed,
          activeIndicatorIndex: currentPage,
          indicatorCount: slides.length,
          layout: slide.layout,
        );
      },
    );
  }
}

class _OnboardingSlideData {
  const _OnboardingSlideData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.actionColor,
    required this.layout,
    required this.titleStyle,
    required this.subtitleStyle,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final Color actionColor;
  final OnboardingPageLayout layout;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
}
