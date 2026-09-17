import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class PackageTierRadioCard extends StatelessWidget {
  const PackageTierRadioCard({
    super.key,
    required this.title,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.isSelected,
    this.isEligible = true,
    this.ineligibilityReason,
    required this.onTap,
  });

  final String title;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercent;
  final bool isSelected;
  final bool isEligible;
  final String? ineligibilityReason;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return InkWell(
      onTap: isEligible ? onTap : null,
      borderRadius: BorderRadius.circular(Spacing.md),
      child: Container(
        margin: const EdgeInsets.only(bottom: Spacing.md),
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? color.primary.withValues(alpha: 0.04)
              : color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Spacing.md),
          border: Border.all(
            color: isSelected ? color.primary : color.outlineVariant,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Radio Indicator
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? color.primary : color.outline,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.primary,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: isEligible ? color.onSurface : color.outline,
                    ),
                  ),
                ),
                if (discountPercent > 0 && isEligible)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$discountPercent%',
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Row(
              children: [
                const SizedBox(width: 28), // Align with text
                if (isEligible && originalPrice > discountedPrice) ...[
                  Text(
                    '${originalPrice.toStringAsFixed(3)} ${locale.currency_kwd}',
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.outline,
                    ).copyWith(decoration: TextDecoration.lineThrough),
                  ),
                  const SizedBox(width: Spacing.sm),
                ],
                Text(
                  '${discountedPrice.toStringAsFixed(3)} ${locale.currency_kwd}',
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size15,
                    color: isEligible ? color.primary : color.outline,
                  ),
                ),
              ],
            ),
            if (!isEligible && ineligibilityReason != null) ...[
              const SizedBox(height: Spacing.xs),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 28),
                child: Text(
                  ineligibilityReason!,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
