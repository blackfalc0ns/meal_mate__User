import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class OnboardingActionButton extends StatelessWidget {
  const OnboardingActionButton({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    required this.onSkipTap,
    required this.activeIndicatorIndex,
    required this.indicatorCount,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;
  final VoidCallback onSkipTap;
  final int activeIndicatorIndex;
  final int indicatorCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 78,
          height: 78,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(78, 78),
                painter: _SegmentedRingPainter(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white.withValues(alpha: 0.38),
                  activeIndex: activeIndicatorIndex,
                  segmentCount: indicatorCount,
                ),
              ),
              Material(
                color: backgroundColor,
                shape: const CircleBorder(),
                elevation: 0,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: SizedBox(
                    width: 54,
                    height: 54,
                    child: Center(
                      child: CustomPaint(
                        size: const Size(19, 25),
                        painter: _ChevronPainter(color: foregroundColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onSkipTap,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: Text(
              l10n.skip,
              style: getSemiBoldStyle(fontFamily: FontConstant.ibmPlexSansArabic,
                color: Colors.white,
                fontSize: FontSize.size18,
              )
            ),
          ),
        ),
      ],
    );
  }
}

class _SegmentedRingPainter extends CustomPainter {
  const _SegmentedRingPainter({
    required this.activeColor,
    required this.inactiveColor,
    required this.activeIndex,
    required this.segmentCount,
  });

  final Color activeColor;
  final Color inactiveColor;
  final int activeIndex;
  final int segmentCount;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 7;
    final safeSegmentCount = segmentCount.clamp(1, 4);
    final safeActiveIndex = activeIndex.clamp(0, safeSegmentCount - 1);
    const startAngle = -1.36;
    const sweepAngle = 0.98;
    const gapAngle = 0.59;
    const stepAngle = sweepAngle + gapAngle;

    for (var index = 0; index < safeSegmentCount; index++) {
      final paint = Paint()
        ..color = index <= safeActiveIndex ? activeColor : inactiveColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + (index * stepAngle),
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedRingPainter oldDelegate) {
    return oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.activeIndex != activeIndex ||
        oldDelegate.segmentCount != segmentCount;
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.72, size.height * 0.12)
      ..lineTo(size.width * 0.26, size.height * 0.50)
      ..lineTo(size.width * 0.72, size.height * 0.88);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChevronPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
