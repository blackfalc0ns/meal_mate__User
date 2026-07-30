import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_button.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_package_icon.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_restaurant_logos_row.dart';

class MonthlyPlanPackageCard extends StatelessWidget {
  const MonthlyPlanPackageCard({
    super.key,
    required this.package,
    required this.width,
    required this.height,
    required this.isCentered,
    required this.isSelected,
    required this.onTap,
    required this.onBrowseRestaurants,
  });

  final MonthlyPackageTierEntity package;
  final double width;
  final double height;
  final bool isCentered;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isFeatured = isCentered;
    final isPremium = package.iconName == 'crown';
    final usesLightForeground = isFeatured || isPremium;
    final countLabel = switch (package.iconName) {
      'crown' => '+100',
      'star' => '+50',
      _ => '+25',
    };
    final foregroundColor = usesLightForeground
        ? color.onPrimary
        : color.onSurface;
    final mutedForegroundColor = usesLightForeground
        ? color.onPrimary
        : color.onSurface;

    return Semantics(
      button: true,
      selected: isSelected,
      label: package.title,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned.fill(
              child: Material(
                color: color.surface.withValues(alpha: 0),
                borderRadius: BorderRadius.circular(
                  isFeatured
                      ? Spacing.monthlyPlanPackageFeaturedRadius
                      : Spacing.monthlyPlanPackageSideRadius,
                ),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(
                    isFeatured
                        ? Spacing.monthlyPlanPackageFeaturedRadius
                        : Spacing.monthlyPlanPackageSideRadius,
                  ),
                  child: Ink(
                    padding: EdgeInsets.only(
                      top: isFeatured
                          ? Spacing.lg + Spacing.xs
                          : Spacing.base + Spacing.xs,
                      bottom: Spacing.sm,
                      left: Spacing.xss,
                      right: Spacing.xss,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isFeatured
                            ? [color.primary, color.onPrimaryContainer]
                            : isPremium
                            ? [color.onSurfaceVariant, color.onSurface]
                            : [color.surface, color.surfaceContainerHighest],
                      ),
                      borderRadius: BorderRadius.circular(
                        isFeatured
                            ? Spacing.monthlyPlanPackageFeaturedRadius
                            : Spacing.monthlyPlanPackageSideRadius,
                      ),
                      border: Border.all(
                        color: isFeatured
                            ? color.primary
                            : color.outlineVariant,
                        width: Spacing.hairline,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.shadow.withValues(alpha: 0.14),
                          blurRadius: Spacing.sm,
                          offset: const Offset(0, Spacing.xs),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        MonthlyPlanPackageIcon(
                          iconName: package.iconName,
                          usesLightForeground: usesLightForeground,
                        ),
                        Text(
                          package.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size20,
                            color: foregroundColor,
                          ).copyWith(height: 1.25),
                        ),
                        const SizedBox(height: Spacing.xs),

                        Text(
                          package.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size8,
                            color: mutedForegroundColor,
                          ).copyWith(height: 1.2),
                        ),
                        const SizedBox(height: Spacing.xs),
                        for (final bullet in package.bullets)
                          Padding(
                            padding: const EdgeInsets.only(top: Spacing.xs),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: FontSize.size6,
                                  color: usesLightForeground
                                      ? color.onPrimary.withValues(alpha: 0.72)
                                      : color.primary,
                                ),
                                const SizedBox(width: Spacing.xs),
                                Flexible(
                                  child: Text(
                                    bullet,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: getLightStyle(
                                      fontFamily:
                                          FontConstant.alexandria,
                                      fontSize: FontSize.size10,
                                      color: mutedForegroundColor,
                                    ).copyWith(height: 1.35),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        MonthlyPlanRestaurantLogosRow(
                          countLabel: countLabel,
                          isFeatured: isFeatured,
                        ),
                        const SizedBox(height: Spacing.xs),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onBrowseRestaurants,
                          child: CustomAppButton(
                            size: AppButtonSize.small,
                            text: locale.calendar_browse_restaurants,
                            onPressed: null,
                            isExpanded: false,
                            width: Spacing.monthlyPlanPackageButtonWidth,
                            height: Spacing.monthlyPlanPackageButtonHeight,
                            textColor: color.onPrimary,
                            fontSize: FontSize.size10,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: (width - Spacing.monthlyPlanPackageIndicatorSize) / 2,
              top: -Spacing.monthlyPlanPackageIndicatorSize / 2,
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
          ],
        ),
      ),
    );
  }
}
