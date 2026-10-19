import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OfferDetailsPlanOptionCard extends StatelessWidget {
  const OfferDetailsPlanOptionCard({
    super.key,
    required this.title,
    required this.duration,
    required this.meals,
    required this.originalPrice,
    required this.discountedPrice,
    required this.isSelected,
    required this.accentColor,
    required this.imageAsset,
    this.onTap,
  });

  final String title;
  final String duration;
  final String meals;
  final String originalPrice;
  final String discountedPrice;
  final bool isSelected;
  final Color accentColor;
  final String imageAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? accentColor : AppColors.border,
              width: isSelected ? 1.6 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(
                  alpha: isSelected ? 0.08 : 0.04,
                ),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Selection circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? accentColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? accentColor : AppColors.textHint,
                    width: 1.4,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 18,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Image
              SizedBox(
                width: 70,
                height: 68,
                child: Image.asset(imageAsset, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              // Title + duration + meals
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        title,
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      duration,
                      textAlign: TextAlign.right,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meals,
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Prices
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$originalPrice ${locale.currency}',
                    style: const TextStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: AppColors.textHint,
                      fontWeight: FontWeightManger.medium,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$discountedPrice ${locale.currency}',
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size16,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'خصم 20%',
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
