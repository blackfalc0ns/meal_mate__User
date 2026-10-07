import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class BiometricPrivacyNotice extends StatelessWidget {
  const BiometricPrivacyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: Spacing.iconSm + Spacing.xxs,
            color: color.onSurfaceVariant,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              locale.biometric_privacy_notice,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ).copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
