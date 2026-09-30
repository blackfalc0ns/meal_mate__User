import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class RestaurantPackageTierCardSkeleton extends StatelessWidget {
  const RestaurantPackageTierCardSkeleton({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    final placeholderColor = color.surfaceContainerHighest;

    return SizedBox(
      width: width,
      height: height,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size(width, height),
              painter: _RestaurantPackageTierCardSkeletonPainter(
                fillColor: color.surface,
                borderColor: color.outlineVariant.withValues(alpha: 0.6),
                shadowColor: color.shadow.withValues(alpha: 0.08),
                radius: Spacing.monthlyPlanPackageSideRadius,
              ),
            ),
            ShimmerWidget(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: Spacing.monthlyPlanPackageLogoStart,
                    top: Spacing.monthlyPlanPackageLogoTop,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: Spacing.monthlyPlanRestaurantLogoSize,
                          height: Spacing.monthlyPlanRestaurantLogoSize,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        for (var i = 0; i < 3; i++) ...[
                          const SizedBox(width: Spacing.xs),
                          Container(
                            width: Spacing.monthlyPlanRestaurantLogoSize,
                            height: Spacing.monthlyPlanRestaurantLogoSize,
                            decoration: BoxDecoration(
                              color: placeholderColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: color.surface,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    right: Spacing.monthlyPlanPackageIconEnd,
                    top: Spacing.monthlyPlanPackageIconTop,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: Spacing.monthlyPlanPackageTitleWidth,
                          height: Spacing.base,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusPill,
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Container(
                          width: Spacing.monthlyPlanPackageIconSize,
                          height: Spacing.monthlyPlanPackageIconSize,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: Spacing.monthlyPlanPackageButtonStart,
                    top: Spacing.monthlyPlanPackageButtonTop,
                    child: Container(
                      width: Spacing.monthlyPlanPackageButtonWidth,
                      height: Spacing.monthlyPlanPackageButtonHeight,
                      decoration: BoxDecoration(
                        color: placeholderColor,
                        borderRadius: BorderRadius.circular(
                          Spacing.radiusPill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: Spacing.monthlyPlanPackageIndicatorEnd,
                    top: Spacing.monthlyPlanPackageIndicatorTop,
                    child: Container(
                      width: Spacing.monthlyPlanPackageIndicatorSize,
                      height: Spacing.monthlyPlanPackageIndicatorSize,
                      decoration: BoxDecoration(
                        color: color.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: color.outlineVariant),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantPackageTierCardSkeletonPainter extends CustomPainter {
  const _RestaurantPackageTierCardSkeletonPainter({
    required this.fillColor,
    required this.borderColor,
    required this.shadowColor,
    required this.radius,
  });

  final Color fillColor;
  final Color borderColor;
  final Color shadowColor;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _createPath(size);
    canvas.drawShadow(path, shadowColor, Spacing.sm, true);

    canvas.drawPath(path, Paint()..color = fillColor);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = Spacing.hairline
      ..color = borderColor;

    canvas.drawPath(path, borderPaint);
  }

  Path _createPath(Size size) {
    const bodyTop = Spacing.monthlyPlanPackageBodyTop;
    final bodyBottom = size.height;
    final curveStart = size.width * 0.53;
    final curveWidth = size.width * 0.11;

    return Path()
      ..moveTo(radius, bodyTop)
      ..lineTo(curveStart, bodyTop)
      ..cubicTo(
        curveStart + curveWidth * 0.45,
        bodyTop,
        curveStart + curveWidth * 0.55,
        0,
        curveStart + curveWidth,
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
  bool shouldRepaint(
    covariant _RestaurantPackageTierCardSkeletonPainter oldDelegate,
  ) {
    return oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.radius != radius;
  }
}
