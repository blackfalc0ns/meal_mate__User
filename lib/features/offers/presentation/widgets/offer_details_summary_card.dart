import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_button.dart';

class OfferDetailsSummaryCard extends StatelessWidget {
  const OfferDetailsSummaryCard({
    super.key,
    required this.title,
    required this.totalPrice,
    required this.buttonLabel,
    required this.securePaymentLabel,
    this.onPrimaryPressed,
    this.showButton = true,
  });

  final String title;
  final String totalPrice;
  final String buttonLabel;
  final String securePaymentLabel;
  final VoidCallback? onPrimaryPressed;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    final locale=context.localization;
    return Column(
      children: [
        Container(
       padding: const EdgeInsets.all(Spacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
          
          
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: getMediumStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                         "$totalPrice ${locale.currency}",
                          style: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size18,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showButton) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: buttonLabel,
                        onPressed: onPrimaryPressed,
                        height: 48,
                       // borderRadius: 14,
                      ),
                    ),
                  ],
                ],
              ),
          
              
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.xs ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: AppColors.textHint,
                ),
                const SizedBox(width: 4),
                Text(
                  securePaymentLabel,
                  style: getMediumStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size10,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
        ),
      ],
    );
  }
}
