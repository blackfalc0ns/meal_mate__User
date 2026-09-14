import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';

class InfluencerDashedBorder extends StatelessWidget {
  const InfluencerDashedBorder({
    super.key,
    required this.color,
    required this.borderRadius,
    required this.child,
  });

  final Color color;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _InfluencerDashedBorderPainter(
        color: color,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class _InfluencerDashedBorderPainter extends CustomPainter {
  const _InfluencerDashedBorderPainter({
    required this.color,
    required this.borderRadius,
  });

  final Color color;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final radius = borderRadius.topLeft;
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect, radius));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = Spacing.border;

    for (final metric in path.computeMetrics()) {
      var distance = Spacing.zero;
      while (distance < metric.length) {
        final end = (distance + Spacing.influencerShareLinksCouponDash).clamp(
          Spacing.zero,
          metric.length,
        );
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += Spacing.influencerShareLinksCouponDash * 2;
      }
    }
  }

  @override
  bool shouldRepaint(_InfluencerDashedBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        borderRadius != oldDelegate.borderRadius;
  }
}
