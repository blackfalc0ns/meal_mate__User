import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.imageAsset,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final String imageAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9917), Color(0xFFF67E15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _PromoPatternPainter())),
          Positioned(
            left: -87,
            top: -23,
            child: Container(
              width: 205,
              height: 205,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(68.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFED474A).withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 30,
            right: 7,
            width: 245,
            child: Text(
              title,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size20,
                color: AppColors.white,
              ),
            ),
          ),
          Positioned(
            top: 59,
            right: 7,
            width: 248,
            child: Text(
              subtitle,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size13,
                color: AppColors.white,
              ),
            ),
          ),
          Positioned(
            left: 112,
            top: 84,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 160,
                height: 29,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  buttonLabel,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size13,
                    color: AppColors.white,
                  ).copyWith(height: 1.2),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 15,
            right: 24,
            child: Row(
              children: [
                _IndicatorDot(color: Color(0xFF04994E)),
                SizedBox(width: 4),
                _IndicatorDot(color: Color(0x66FFFFFF)),
                SizedBox(width: 4),
                _IndicatorDot(color: Color(0xB3FFFFFF)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorDot extends StatelessWidget {
  const _IndicatorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _PromoPatternPainter extends CustomPainter {
  const _PromoPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = AppColors.white.withValues(alpha: 0.5);

    canvas.drawArc(Rect.fromLTWH(59, 21, 22, 17), -0.2, 2.2, false, paint);
    canvas.drawArc(Rect.fromLTWH(71, 76, 22, 8), 0.3, 2.7, false, paint);
    canvas.drawArc(Rect.fromLTWH(41, 120, 37, 27), -0.8, 2.6, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
