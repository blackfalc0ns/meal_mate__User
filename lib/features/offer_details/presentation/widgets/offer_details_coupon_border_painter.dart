import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';

class OfferDetailsCouponBorderPainter extends CustomPainter {
  const OfferDetailsCouponBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = Spacing.border;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(Spacing.md),
    );
    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = distance + Spacing.xss > metric.length
            ? metric.length
            : distance + Spacing.xss;
        canvas.drawPath(metric.extractPath(distance, length), paint);
        distance += Spacing.md;
      }
    }
  }

  @override
  bool shouldRepaint(covariant OfferDetailsCouponBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
