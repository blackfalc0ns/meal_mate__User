import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

/// Standalone coupon-code row matching the design:
///  ┌────────────────────────────────────────────────────────┐
///  │  🎟  كود الخصم للمستخدم          [نسخ 🗐]            │
///  │      SAVE20 (green bold)                               │
///  └────────────────────────────────────────────────────────┘
class OfferActivatedCouponRow extends StatelessWidget {
  const OfferActivatedCouponRow({
    super.key,
    required this.couponCode,
    required this.accentColor,
    this.copyLabel = 'نسخ',
    this.titleLabel = 'كود الخصم للمستخدم',
    this.onCopy,
  });

  final String couponCode;
  final Color accentColor;
  final String copyLabel;
  final String titleLabel;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color:Color(0xFFF3F7F3),
        // accentColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.18)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ticket icon
          Icon(Icons.confirmation_num_outlined, size: 22, color: AppColors.primaryVariant),
          const SizedBox(width: Spacing.sm),

          // Label + code — takes remaining space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titleLabel,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  couponCode,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: AppColors.primaryVariant,
                  ),
                ),
              ],
            ),
          ),

          // Copy button on the left end
          _CopyButton(label: copyLabel, onPressed: onCopy, accentColor: accentColor),
        ],
      ),
    );
  }
}

// ── Private helpers ─────────────────────────────────────────────

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    required this.label,
    required this.onPressed,
    required this.accentColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: accentColor.withValues(alpha: 0.35)),
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: const Size(0, 34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
         
         
          const Icon(Icons.copy_rounded, size: 14, color: AppColors.primaryVariant),
                 const SizedBox(width: 4),

        Text(
            label,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: AppColors.primaryVariant,
            ),
          ),
       
        ],
      ),
    );
  }
}
