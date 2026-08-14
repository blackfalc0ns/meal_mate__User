import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_package_icon.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_restaurant_logos_row.dart';

class MonthlyPlanPackageCard extends StatelessWidget {
  const MonthlyPlanPackageCard({
    super.key,
    required this.package,
    required this.title,
    required this.width,
    required this.height,
    required this.isCentered,
    required this.isSelected,
    required this.onTap,
    required this.onBrowseRestaurants,
  });

  final MonthlyPackageTierEntity package;
  final String title;
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
    final countLabel = package.restaurantCount > 0
        ? '+${package.restaurantCount}'
        : '';
    final foregroundColor = isSelected && !usesLightForeground
        ? color.primary
        : usesLightForeground
        ? color.onPrimary
        : color.onSurface;
    final buttonBackgroundColor = isPremium
        ? color.secondary
        : usesLightForeground
        ? color.surface
        : color.primary;
    final buttonForegroundColor = isPremium
        ? color.onSecondary
        : usesLightForeground
        ? color.primary
        : color.onPrimary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: title,
      child: SizedBox(
        width: width,
        height: height,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: CustomPaint(
            painter: _MonthlyPlanPackageCardPainter(
              colors: isFeatured
                  ? [color.primary, color.onPrimaryContainer]
                  : isPremium
                  ? [color.onSurfaceVariant, color.onSurface]
                  : [color.surface, color.surfaceContainerHighest],
              borderColor: isFeatured ? color.primary : color.outlineVariant,
              shadowColor: color.shadow.withValues(alpha: 0.14),
              radius: isFeatured
                  ? Spacing.monthlyPlanPackageFeaturedRadius
                  : Spacing.monthlyPlanPackageSideRadius,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: Spacing.monthlyPlanPackageLogoStart,
                  top: Spacing.monthlyPlanPackageLogoTop,
                  child: MonthlyPlanRestaurantLogosRow(
                    countLabel: countLabel,
                    logoUrls: package.restaurantLogoUrls,
                    isFeatured: isFeatured,
                  ),
                ),
                Positioned(
                  right: Spacing.monthlyPlanPackageIconEnd,
                  top: Spacing.monthlyPlanPackageIconTop,
                  child: MonthlyPlanPackageIcon(
                    iconName: package.iconName,
                    logoUrl: package.logoUrl,
                    usesLightForeground: usesLightForeground,
                    isSelected: isSelected,
                  ),
                ),
                Positioned(
                  right: Spacing.monthlyPlanPackageTitleEnd,
                  top: Spacing.monthlyPlanPackageTitleTop,
                  width: Spacing.monthlyPlanPackageTitleWidth,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,

                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size22,
                      color: foregroundColor,
                    ).copyWith(height: 1.25),
                  ),
                ),
                Positioned(
                  left: Spacing.monthlyPlanPackageButtonStart,
                  top: Spacing.monthlyPlanPackageButtonTop,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onBrowseRestaurants,
                    child: Container(
                      width: Spacing.monthlyPlanPackageButtonWidth,
                      height: Spacing.monthlyPlanPackageButtonHeight,
                      decoration: BoxDecoration(
                        color: buttonBackgroundColor,
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chevron_left_rounded,
                            size: Spacing.iconSm,
                            color: buttonForegroundColor,
                          ),
                          const SizedBox(width: Spacing.sm),
                          Flexible(
                            child: Text(
                              locale.calendar_browse_restaurants,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color: buttonForegroundColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: Spacing.monthlyPlanPackageIndicatorEnd,
                  top: Spacing.monthlyPlanPackageIndicatorTop,
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
                            FadeTransition(opacity: animation, child: child),
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
        ),
      ),
    );
  }
}

class _MonthlyPlanPackageCardPainter extends CustomPainter {
  const _MonthlyPlanPackageCardPainter({
    required this.colors,
    required this.borderColor,
    required this.shadowColor,
    required this.radius,
  });

  final List<Color> colors;
  final Color borderColor;
  final Color shadowColor;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _createPath(size);
    canvas.drawShadow(path, shadowColor, Spacing.sm, true);

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = Spacing.hairline
      ..color = borderColor;

    canvas.drawPath(path, borderPaint);
  }

  Path _createPath(Size size) {
    final bodyTop = Spacing.monthlyPlanPackageBodyTop;
    final bodyBottom = bodyTop + Spacing.monthlyPlanPackageBodyHeight;
    final curveStart = Spacing.monthlyPlanPackageCurveStart;
    final curveWidth = Spacing.monthlyPlanPackageCurveWidth;

    return Path()
      ..moveTo(radius, bodyTop)
      ..lineTo(curveStart, bodyTop)
      ..cubicTo(
        curveStart + curveWidth * 0.28,
        bodyTop,
        curveStart + curveWidth * 0.28,
        0,
        curveStart + curveWidth * 0.62,
        0,
      )
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, bodyBottom - radius)
      ..quadraticBezierTo(
        size.width,
        bodyBottom,
        size.width - radius,
        bodyBottom,
      )
      ..lineTo(radius, bodyBottom)
      ..quadraticBezierTo(0, bodyBottom, 0, bodyBottom - radius)
      ..lineTo(0, bodyTop + radius)
      ..quadraticBezierTo(0, bodyTop, radius, bodyTop)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _MonthlyPlanPackageCardPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.radius != radius;
  }
}
