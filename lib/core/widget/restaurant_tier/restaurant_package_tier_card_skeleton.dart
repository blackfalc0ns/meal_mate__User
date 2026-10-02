import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class RestaurantPackageTierCardSkeleton extends StatelessWidget {
  const RestaurantPackageTierCardSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.index = 0,
  });

  final double width;
  final double height;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final placeholderColor = color.surfaceContainerHighest;

    final isPlus = index == 1;
    final isMax = index == 2;

    final cardFillColor = isPlus
        ? color.primary.withValues(alpha: 0.08)
        : isMax
        ? color.onSurface.withValues(alpha: 0.06)
        : color.surface;

    final cardBorderColor = isPlus
        ? color.primary.withValues(alpha: 0.3)
        : isMax
        ? color.outlineVariant.withValues(alpha: 0.8)
        : color.outlineVariant.withValues(alpha: 0.6);

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
                fillColor: cardFillColor,
                borderColor: cardBorderColor,
                shadowColor: color.shadow.withValues(alpha: 0.08),
                radius: Spacing.monthlyPlanPackageSideRadius,
              ),
            ),
            ShimmerWidget(
              baseColor: color.surfaceContainerHighest,
              highlightColor: color.surface,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Top left: Logos row tab
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

                  // Top right: Radio indicator
                  Positioned(
                    right: Spacing.monthlyPlanPackageIndicatorEnd,
                    top: Spacing.monthlyPlanPackageIndicatorTop,
                    child: Container(
                      width: Spacing.monthlyPlanPackageIndicatorSize,
                      height: Spacing.monthlyPlanPackageIndicatorSize,
                      decoration: BoxDecoration(
                        color: placeholderColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: color.outlineVariant),
                      ),
                    ),
                  ),

                  // Bottom content: Price block | Centered Button | Title + Icon
                  Positioned(
                    left: Spacing.monthlyPlanPackageLogoStart,
                    right: Spacing.sm,
                    top: Spacing.monthlyPlanPackageTitleTop,
                    bottom: Spacing.sm,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price & period block
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 52,
                              height: 16,
                              decoration: BoxDecoration(
                                color: placeholderColor,
                                borderRadius: BorderRadius.circular(
                                  Spacing.radiusXs,
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.xxs),
                            Container(
                              width: 68,
                              height: 10,
                              decoration: BoxDecoration(
                                color: placeholderColor,
                                borderRadius: BorderRadius.circular(
                                  Spacing.radiusXs,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: Spacing.xs),

                        // Centered browse restaurants button
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: Spacing.monthlyPlanPackageButtonHeight,
                              constraints: const BoxConstraints(
                                maxWidth: 122.0,
                              ),
                              decoration: BoxDecoration(
                                color: placeholderColor,
                                borderRadius: BorderRadius.circular(
                                  Spacing.radiusPill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),

                        // Title placeholder
                        Container(
                          width: 55,
                          height: 20,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusXs,
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),

                        // Tier badge icon placeholder
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
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
