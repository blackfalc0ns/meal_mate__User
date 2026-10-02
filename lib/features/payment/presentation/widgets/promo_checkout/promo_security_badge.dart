import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Secure checkout badge displayed below order summary in promo checkout screen.
class PromoSecurityBadge extends StatelessWidget {
  const PromoSecurityBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Spacing.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, color: color.primary, size: 20),
          const SizedBox(width: Spacing.sm),
          Text(
            locale.offer_checkout_secure_badge,
            style: getMediumStyle(
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
