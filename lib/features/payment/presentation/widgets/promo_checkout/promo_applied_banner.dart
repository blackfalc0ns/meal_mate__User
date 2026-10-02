import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Top banner displayed on checkout when a promo offer is applied.
class PromoAppliedBanner extends StatelessWidget {
  const PromoAppliedBanner({super.key, this.promoCode});

  final String? promoCode;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Spacing.md),
        border: Border.all(color: color.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.primary.withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: color.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            locale.offer_checkout_applied_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size18,
              color: color.primary,
            ),
          ),
          if (promoCode != null && promoCode!.isNotEmpty) ...[
            const SizedBox(height: Spacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xxs,
              ),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Spacing.xs),
              ),
              child: Text(
                '${locale.offer_checkout_applied_code}: $promoCode',
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.primary,
                ),
              ),
            ),
          ],
          const SizedBox(height: Spacing.xs),
          Text(
            locale.offer_checkout_applied_description,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
