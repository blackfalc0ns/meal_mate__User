import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SuggestedPromoCodeCard extends StatelessWidget {
  const SuggestedPromoCodeCard({
    super.key,
    required this.code,
    required this.title,
    required this.discount,
    required this.onSelect,
  });

  final String code;
  final String title;
  final String discount;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: 150,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Spacing.md),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
              code,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.primary,
              ),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            discount,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          InkWell(
            onTap: onSelect,
            borderRadius: BorderRadius.circular(Spacing.xs),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.primary,
                borderRadius: BorderRadius.circular(Spacing.xs),
              ),
              child: Text(
                locale.offer_promo_apply_code,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
