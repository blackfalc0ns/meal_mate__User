import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Order summary card matching the design:
///  ┌────────────────────────────────────────┐
///  │  [image]   ملخص طلبك                  │
///  │            باقة شهر - 26 يوم (green)   │
///  │            4 وجبات يومياً              │
///  ├────────────────────────────────────────┤
///  │  52.000 KWD        السعر الأساسي       │
///  │  -10.400 KWD       الخصم(20%)          │
///  ├────────────────────────────────────────┤
///  │  41.600 KWD        الإجمالي بعد الخصم  │
///  └────────────────────────────────────────┘
class OfferActivatedOrderSummaryCard extends StatelessWidget {
  const OfferActivatedOrderSummaryCard({
    super.key,
    required this.planTitle,
    required this.planDuration,
    required this.mealsPerDay,
    required this.originalPrice,
    required this.discountAmount,
    required this.totalPrice,
    required this.discountLabel,
    required this.imageAsset,
  });

  final String planTitle;
  final String planDuration;
  final String mealsPerDay;
  final String originalPrice;
  final String discountAmount;
  final String totalPrice;
  final String discountLabel;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final currency = locale.currency;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top section: image + plan info ────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.sm,
              Spacing.sm,
              Spacing.base,
              Spacing.sm,
            ),
            child: Row(
              // LTR so image is physically on the left
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Meal box image — large, no clip
                Image.asset(
                  imageAsset,
                  width: 130,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: Spacing.sm),
                // Plan info (RTL text)
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ملخص طلبك',
                          style: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        // "باقة شهر - 26 يوم"  where duration is green
                        RichText(
                          textDirection: TextDirection.rtl,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: planTitle,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text: ' - ',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text: planDuration,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size16,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          mealsPerDay,
                          style: getMediumStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // ── Middle: original price + discount ─────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.sm,
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  // Row 1: label right / value left
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // label on right (start in RTL)
                      Text(
                        'السعر الأساسي',
                        style: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size13,
                          color: AppColors.textHint,
                        ),
                      ),
                      // value on left (end in RTL)
                      Text(
                        '$originalPrice $currency',
                        style: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size13,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xs),
                  // Row 2: label right / value left (discount in primary green)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الخصم($discountLabel)',
                        style: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size13,
                          color: AppColors.textHint,
                        ),
                      ),
                      Text(
                        '-$discountAmount $currency',
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size13,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // ── Bottom: total ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الإجمالي بعد الخصم',
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '$totalPrice $currency',
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size20,
                      color: AppColors.primaryDark,
                    ),
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
