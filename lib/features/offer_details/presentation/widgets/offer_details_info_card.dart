import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';

/// Info card with up to four rows — each controlled by a bool flag:
///
///  [showSummaryRow]   → tag icon + summaryText (no title label)
///  always shown       → calendar icon + "مدة العرض" bold green + durationText
///  [showCouponSection]→ ticket icon + "رمز الخصم" bold green + copy/chip row
///  always shown       → info icon + "الشروط والأحكام" bold green + termsText
class OfferDetailsInfoCard extends StatelessWidget {
  const OfferDetailsInfoCard({
    super.key,
    required this.summaryText,
    required this.durationText,
    required this.couponCode,
    required this.termsText,
    required this.accentColor,
    this.onCopyCode,
    this.showSummaryRow = true,
    this.showCouponSection = true,
  });

  final String summaryText;
  final String durationText;
  final String couponCode;
  final String termsText;
  final Color accentColor;

  /// No longer used — copy is handled internally with CustomSnackbar.
  final VoidCallback? onCopyCode;

  /// Show the first row (tag icon + summary text)?
  final bool showSummaryRow;

  /// Show the coupon-code row (ticket icon + copy button + dashed chip)?
  final bool showCouponSection;

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
          // ── Row 1: summary (optional) ───────────────────
          if (showSummaryRow) ...[
            _SummaryRow(text: summaryText, accentColor: accentColor),
            const Divider(height: 1, thickness: 1, color: Color(0xFFD9E3D7)),
          ],

          // ── Row 2: duration (always shown) ──────────────
          _InfoRow(
            icon: Icons.calendar_month_rounded,
            title: 'مدة العرض',
            subtitle: durationText,
            accentColor: accentColor,
            showDivider: true,
          ),

          // ── Row 3: coupon (optional) ─────────────────────
          if (showCouponSection) ...[
            _CouponRow(
              couponCode: couponCode,
              accentColor: accentColor,
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFD9E3D7)),
          ],

          // ── Row 4: terms (always shown, no divider after) ─
          _InfoRow(
            icon: Icons.info_outline_rounded,
            title: 'الشروط والأحكام',
            subtitle: termsText,
            accentColor: accentColor,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

// ── Row 1: tag icon + summary text only (no bold title) ──────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.text, required this.accentColor});

  final String text;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.sm,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.local_offer_rounded, size: 20, color: accentColor),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Rows 2 & 4: icon + bold green title + grey subtitle ──────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.showDivider,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.sm,
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: accentColor),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      textDirection: TextDirection.rtl,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
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

// ── Row 3: coupon code with copy button + dashed chip ────────────

class _CouponRow extends StatelessWidget {
  const _CouponRow({
    required this.couponCode,
    required this.accentColor,
  });

  final String couponCode;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.sm,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.confirmation_num_outlined, size: 18, color: accentColor),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رمز الخصم',
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    _CopyButton(
                      label: 'نسخ الرمز',
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: couponCode),
                        );
                        if (context.mounted) {
                          CustomSnackbar.showSuccess(
                            context: context,
                            message: 'تم نسخ الرمز بنجاح',
                          );
                        }
                      },
                    ),
                    const Spacer(),
                    _DashedChip(code: couponCode, accentColor: accentColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Copy button ──────────────────────────────────────────────────

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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            label,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(Icons.copy_rounded, size: 14, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}

// ── Dashed border chip ───────────────────────────────────────────

class _DashedChip extends StatelessWidget {
  const _DashedChip({required this.code, required this.accentColor});

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
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: accentColor,
            ),
          ),
        ),
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
        final length = (metric.length - distance) < dashWidth
            ? (metric.length - distance)
            : dashWidth;
        canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color;
}
