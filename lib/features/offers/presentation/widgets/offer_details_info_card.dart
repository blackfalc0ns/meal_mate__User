import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class OfferDetailsInfoCard extends StatelessWidget {
  const OfferDetailsInfoCard({
    super.key,
    required this.summaryText,
    required this.durationText,
    required this.couponCode,
    required this.termsText,
    required this.accentColor,
    this.onCopyCode,
  });

  final String summaryText;
  final String durationText;
  final String couponCode;
  final String termsText;
  final Color accentColor;
  final VoidCallback? onCopyCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _InfoSection(
            title: 'تفاصيل العرض',
            subtitle: summaryText,
            icon: Icons.local_offer_rounded,
            accentColor: accentColor,
            showDivider: true,
          ),
          _InfoSection(
            title: 'مدة العرض',
            subtitle: durationText,
            icon: Icons.calendar_month_rounded,
            accentColor: accentColor,
            showDivider: true,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.confirmation_num_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رمز الخصم',
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: 12,
                          color: AppColors.primaryVariant,
                        ),
                      ),
                     // const SizedBox(height: 4),
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CopyButton(
                            label: 'نسخ الرمز',
                            onPressed: onCopyCode,
                          ),
                          Spacer(),
                          _CouponChip(
                            code: couponCode,
                            accentColor: accentColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFD9E3D7)),
          _InfoSection(
            title: 'الشروط والأحكام',
            subtitle: termsText,
            icon: Icons.info_outline_rounded,
            accentColor: accentColor,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.showDivider,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,

                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size12,
                        color: AppColors.primaryVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      textAlign: TextAlign.right,
                      style: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: Color(0xFFD9E3D7)),
      ],
    );
  }
}

class _CouponChip extends StatelessWidget {
  const _CouponChip({required this.code, required this.accentColor});

  final String code;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.sm,
        end: Spacing.sm,
      ),
      child: CustomPaint(
        painter: _DashedBorderPainter(color: accentColor),
        child: Container(
          constraints: const BoxConstraints(minWidth: 104, minHeight: 34),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            code,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 12,
              color: accentColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFD7DED4)),
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        minimumSize: const Size(0, 34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            label,
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 11,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(
            Icons.copy_rounded,
            size: 14,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashGap = 3.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(999),
    );

    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = metric.length - distance < dashWidth
            ? metric.length - distance
            : dashWidth;
        canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
