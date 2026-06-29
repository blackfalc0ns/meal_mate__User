import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

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
  final String? summaryTitle;
  final String? discountLabel;
  final String? couponHint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E7DF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x197C7B7B),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imageAsset,
                width: 145,
                height: 116,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summaryTitle ?? l10n.payment_order_summary_title,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size13,
                        ),
                      ),
                      const SizedBox(height: 13),
                      RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$planTitle - ',
                              style: _style(15, FontWeightManger.bold),
                            ),
                            TextSpan(
                              text: planDuration,
                              style: _style(
                                13,
                                FontWeightManger.semiBold,
                                AppColors.primaryVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        mealsPerDay,
                        style: _style(
                          13,
                          FontWeightManger.regular,
                          const Color(0xFF25242B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _priceRow(
            l10n.payment_base_price_label,
            '$originalPrice ${l10n.currency}',
          ),
          const SizedBox(height: 5),
          _priceRow(
            discountLabel == null
                ? l10n.payment_discount_label
                : '${l10n.payment_discount_label.split('(').first.trim()}($discountLabel)',
            '-$discountAmount ${l10n.currency}',
            valueColor: AppColors.primaryVariant,
          ),
          const Divider(height: 17, color: Color(0xFFECECEE)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.payment_total_after_discount,
                style: _style(14, FontWeightManger.bold),
              ),
              Text(
                '$totalPrice ${l10n.currency}',
                style: _style(
                  15,
                  FontWeightManger.bold,
                  AppColors.primaryVariant,
                ),
              ),
            ],
          ),
          if (couponHint != null) ...[
            const SizedBox(height: 8),
            Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF2F3F2)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.sell_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      couponHint!,
                      style: _style(13, FontWeightManger.medium),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    Color valueColor = const Color(0xFF777B82),
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: _style(13, FontWeightManger.regular, const Color(0xFF777B82)),
        ),
        Text(
          value,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size10,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  TextStyle _style(
    double size,
    FontWeight weight, [
    Color color = AppColors.textPrimary,
  ]) {
    return getRegularStyle(
      fontFamily: FontConstant.ibmPlexSansArabic,
      fontSize: size,
      color: color,
    ).copyWith(fontWeight: weight);
  }
}
