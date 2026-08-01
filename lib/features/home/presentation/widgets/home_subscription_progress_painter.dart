import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomeSubscriptionProgressPainter extends CustomPainter {
  const HomeSubscriptionProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
    required this.gapAngle,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;
  final double gapAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final insetRect = rect.deflate(strokeWidth / 2);
    final startAngle = math.pi / 2 + gapAngle / 2;
    final sweepAngle = math.pi * 2 - gapAngle;
    final clampedProgress = progress.clamp(0, 1).toDouble();
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(insetRect, startAngle, sweepAngle, false, trackPaint);
    canvas.drawArc(
      insetRect,
      startAngle + sweepAngle * (1 - clampedProgress),
      sweepAngle * clampedProgress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant HomeSubscriptionProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gapAngle != gapAngle;
  }
}
