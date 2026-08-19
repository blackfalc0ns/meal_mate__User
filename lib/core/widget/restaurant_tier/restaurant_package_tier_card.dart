import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_icon.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_tier_logos_row.dart';

class RestaurantPackageTierCard extends StatelessWidget {
  const RestaurantPackageTierCard({
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

  final RestaurantPackageTierUiModel package;
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
    final isMax = package.iconName == 'diamond';
    final usesLightForeground = isFeatured || isMax;
    final countLabel = package.restaurantCount > 0
        ? '+${package.restaurantCount}'
        : '';
    final foregroundColor = isSelected && !usesLightForeground
        ? color.primary
        : usesLightForeground
        ? color.onPrimary
        : color.onSurface;
    final buttonBackgroundColor = isMax
        ? color.secondary
        : usesLightForeground
        ? color.surface
        : color.primary;
    final buttonForegroundColor = isMax
        ? color.onSecondary
        : usesLightForeground
        ? color.primary
        : color.onPrimary;

    final isRtl = Directionality.of(context) == TextDirection.rtl;

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
            painter: _RestaurantPackageTierCardPainter(
              colors: isFeatured
                  ? [color.primary, color.onPrimaryContainer]
                  : isMax
                  ? [color.onSurfaceVariant, color.onSurface]
                  : [color.surface, color.surfaceContainerHighest],
              borderColor: isFeatured ? color.primary : color.outlineVariant,
              shadowColor: color.shadow.withValues(alpha: 0.14),
              radius: isFeatured
                  ? Spacing.monthlyPlanPackageFeaturedRadius
                  : Spacing.monthlyPlanPackageSideRadius,
              isRtl: isRtl,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                PositionedDirectional(
                  start: Spacing.monthlyPlanPackageLogoStart,
                  top: Spacing.monthlyPlanPackageLogoTop,
                  child: RestaurantTierLogosRow(
                    countLabel: countLabel,
                    logoUrls: package.restaurantLogoUrls,
                    isFeatured: isFeatured,
                  ),
                ),
                PositionedDirectional(
                  end: Spacing.monthlyPlanPackageIconEnd,
                  top: Spacing.monthlyPlanPackageIconTop,
                  child: RestaurantPackageTierIcon(
                    iconName: package.iconName,
                    logoUrl: package.logoUrl,
                    usesLightForeground: usesLightForeground,
                    isSelected: isSelected,
                  ),
                ),
                PositionedDirectional(
                  end: Spacing.monthlyPlanPackageTitleEnd,
                  top: Spacing.monthlyPlanPackageTitleTop,
                  width: Spacing.monthlyPlanPackageTitleWidth,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size22,
                      color: foregroundColor,
                    ).copyWith(height: 1.25),
                  ),
                ),
                PositionedDirectional(
                  start: Spacing.monthlyPlanPackageButtonStart,
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
                            isRtl
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
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
                PositionedDirectional(
                  end: Spacing.monthlyPlanPackageIndicatorEnd,
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

class _RestaurantPackageTierCardPainter extends CustomPainter {
  const _RestaurantPackageTierCardPainter({
    required this.colors,
    required this.borderColor,
    required this.shadowColor,
    required this.radius,
    required this.isRtl,
  });

  final List<Color> colors;
  final Color borderColor;
  final Color shadowColor;
  final double radius;
  final bool isRtl;

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
  bool shouldRepaint(covariant _RestaurantPackageTierCardPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.radius != radius ||
        oldDelegate.isRtl != isRtl;
  }
}
