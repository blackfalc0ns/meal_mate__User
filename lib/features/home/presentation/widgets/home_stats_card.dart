import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class HomeStatsCard extends StatelessWidget {
  const HomeStatsCard({
    super.key,
    required this.progress,
    required this.dailyCalories,
    required this.goalCalories,
  });

  final double progress;
  final int dailyCalories;
  final int goalCalories;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 93,
      padding: const EdgeInsets.fromLTRB(34, 8, 26, 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD6D6D6)),
      ),
      child: Row(
        textDirection: ui.TextDirection.ltr,
        children: [
          SizedBox(
            width: 92,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _ProgressRing(progress: progress),
            ),
          ),
          Container(width: 1, height: 46, color: const Color(0xFFA0A0A0)),
          const Spacer(),
          SizedBox(
            width: 88,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'السعرات اليومية',
                    textAlign: TextAlign.right,
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size10,
                      color: AppColors.black,
                    ).copyWith(height: 1),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    NumberFormat.decimalPattern('en').format(dailyCalories),
                    textAlign: TextAlign.right,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size26,
                      color: AppColors.black,
                    ).copyWith(height: 1),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'من ${NumberFormat.decimalPattern('en').format(goalCalories)} سعرة',
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size11,
                      color: AppColors.black,
                    ).copyWith(height: 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 76,
      child: CustomPaint(
        painter: _ProgressRingPainter(progress: progress),
        child: Center(
          child: Text(
            '${(progress * 100).round()}%',
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size18,
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - 8) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFCECECE);
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFF67E15);

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
