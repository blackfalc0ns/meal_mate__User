import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class AppOrderSummaryCard extends StatelessWidget {
  const AppOrderSummaryCard({
    super.key,
    required this.planTitle,
    required this.planDuration,
    required this.mealsPerDay,
    required this.originalPrice,
    required this.discountAmount,
    required this.totalPrice,
    required this.imageAsset,
    this.imageUrl,
    this.summaryTitle,
    this.discountLabel,
    this.couponHint,
  });

  final String planTitle;
  final String planDuration;
  final String mealsPerDay;
  final String originalPrice;
  final String discountAmount;
  final String totalPrice;
  final String imageAsset;
  final String? imageUrl;
  final String? summaryTitle;
  final String? discountLabel;
  final String? couponHint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7ECE7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 165,
                  height: 130,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summaryTitle ?? l10n.payment_order_summary_title,
                          textAlign: TextAlign.right,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$planTitle - ',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text: planDuration,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size16,
                                  color: AppColors.primaryVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mealsPerDay,
                          textAlign: TextAlign.right,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _PriceRow(
              label: l10n.payment_base_price_label,
              value: '$originalPrice ${l10n.currency}',
              valueColor: const Color(0xFF6F737A),
            ),
            const SizedBox(height: 6),
            _PriceRow(
              label: _discountText(l10n.payment_discount_label),
              value: '-$discountAmount ${l10n.currency}',
              valueColor: AppColors.primaryVariant,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  l10n.payment_total_after_discount,
                  textAlign: TextAlign.right,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size16,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(width: 10),
                const Expanded(
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF0F0F0),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$totalPrice ${l10n.currency}',
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size20,
                    color: AppColors.primaryVariant,
                  ),
                ),
              ],
            ),
            if (couponHint != null) ...[
              const SizedBox(height: 14),
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF0F0F0)),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Icon(
                      Icons.sell_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        couponHint!,
                        textAlign: TextAlign.center,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _discountText(String fallbackLabel) {
    if (discountLabel == null || discountLabel!.isEmpty) {
      return fallbackLabel;
    }

    final baseLabel = fallbackLabel.contains('(')
        ? fallbackLabel.substring(0, fallbackLabel.indexOf('(')).trim()
        : fallbackLabel;
    return '$baseLabel($discountLabel)';
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size13,
            color: const Color(0xFF8A8F98),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
        ),
        const SizedBox(width: 8),

        Text(
          value,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
