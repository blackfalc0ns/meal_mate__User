import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanPackageCard extends StatelessWidget {
  const MonthlyPlanPackageCard({
    super.key,
    required this.package,
    required this.width,
    required this.isSelected,
    required this.onTap,
    required this.onBrowseRestaurants,
  });

  final MonthlyPackageTierEntity package;
  final double width;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isFeatured = package.isPopular;
    final isPremium = package.iconName == 'crown';
    final designWidth = isFeatured
        ? Spacing.monthlyPlanPackageFeaturedWidth
        : Spacing.monthlyPlanPackageSideWidth;
    final sourceLeft = isFeatured
        ? Spacing.monthlyPlanPackageFeaturedLeft
        : isPremium
        ? Spacing.monthlyPlanPackagePremiumLeft
        : Spacing.monthlyPlanPackageBasicLeft;
    final indicatorLeft = isFeatured
        ? Spacing.monthlyPlanPackageFeaturedIndicatorLeft - sourceLeft
        : isPremium
        ? Spacing.monthlyPlanPackagePremiumIndicatorLeft - sourceLeft
        : Spacing.monthlyPlanPackageBasicIndicatorLeft - sourceLeft;
    final indicatorTop = isFeatured
        ? Spacing.monthlyPlanPackageFeaturedIndicatorTop
        : isPremium
        ? Spacing.monthlyPlanPackagePremiumIndicatorTop
        : Spacing.monthlyPlanPackageBasicIndicatorTop;
    final buttonLeft = isFeatured
        ? Spacing.monthlyPlanPackageFeaturedButtonLeft - sourceLeft
        : isPremium
        ? Spacing.monthlyPlanPackagePremiumButtonLeft - sourceLeft
        : Spacing.monthlyPlanPackageBasicButtonLeft - sourceLeft;
    final scale = width / designWidth;

    return Semantics(
      button: true,
      selected: isSelected,
      label: package.title,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        offset: Offset(
          0,
          isSelected ? -Spacing.xs / Spacing.monthlyPlanPackageHeight : 0,
        ),
        child: SizedBox(
          width: width,
          height: Spacing.monthlyPlanPackageHeight * scale,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: designWidth,
              height: Spacing.monthlyPlanPackageHeight,
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned(
                      left: -sourceLeft,
                      top: 0,
                      width: Spacing.monthlyPlanPackagesWidth,
                      height: Spacing.monthlyPlanPackageHeight,
                      child: SvgPicture.asset(
                        Assets.monthlyPackageTiers,
                        fit: BoxFit.fill,
                        semanticsLabel: package.title,
                      ),
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTap,
                        child: const SizedBox.expand(),
                      ),
                    ),
                    Positioned(
                      left: indicatorLeft,
                      top: indicatorTop,
                      child: IgnorePointer(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          width: Spacing.monthlyPlanPackageIndicatorSize,
                          height: Spacing.monthlyPlanPackageIndicatorSize,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? color.primary : color.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? color.primary : color.outline,
                              width: Spacing.border,
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: isSelected
                                ? Icon(
                                    Icons.check_rounded,
                                    key: const ValueKey(true),
                                    size: Spacing.md,
                                    color: color.onPrimary,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: buttonLeft,
                      top: Spacing.monthlyPlanPackageButtonTop,
                      width: Spacing.monthlyPlanPackageButtonWidth,
                      height: Spacing.monthlyPlanPackageButtonHeight,
                      child: Semantics(
                        button: true,
                        label: locale.calendar_browse_restaurants,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onBrowseRestaurants,
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
