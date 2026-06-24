import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/shared/constants/app_ui_constants.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
  });

  final int currentIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: AppUiConstants.animationDuration,
          margin: const EdgeInsets.symmetric(
            horizontal: AppUiConstants.onboardingIndicatorSpacing / 3,
          ),
          width: isActive
              ? AppUiConstants.pageIndicatorActiveWidth
              : AppUiConstants.pageIndicatorInactiveWidth,
          height: AppUiConstants.pageIndicatorDotSize,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.primarySurface,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
