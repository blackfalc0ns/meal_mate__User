import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Card showing the applied promo code with a quick copy-to-clipboard action.
class ActivationPromoCodeCard extends StatelessWidget {
  const ActivationPromoCodeCard({super.key, required this.promoCode});

  final String promoCode;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Spacing.sm),
        border: Border.all(color: color.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.discount_outlined, color: color.primary, size: 20),
          const SizedBox(width: Spacing.sm),
          Text(
            '${locale.offer_details_code_label}: ',
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurfaceVariant,
            ),
          ),
          Text(
            promoCode,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.primary,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              unawaited(Clipboard.setData(ClipboardData(text: promoCode)));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(locale.offer_details_copy_code),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(Spacing.xs),
              child: Icon(Icons.copy_rounded, color: color.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
