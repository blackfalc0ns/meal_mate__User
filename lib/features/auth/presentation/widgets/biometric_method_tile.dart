import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class BiometricMethodTile extends StatelessWidget {
  const BiometricMethodTile({
    super.key,
    required this.presentationType,
    required this.isAvailable,
  });

  final BiometricTypeEnum presentationType;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final (iconData, title, subtitle) = switch (presentationType) {
      BiometricTypeEnum.face => (
          Icons.face_rounded,
          locale.biometric_face_id,
          locale.biometric_login_subtitle,
        ),
      BiometricTypeEnum.fingerprint => (
          Icons.fingerprint_rounded,
          locale.biometric_fingerprint,
          locale.biometric_login_subtitle,
        ),
      _ => (
          Icons.fingerprint_rounded,
          locale.biometric_generic,
          locale.biometric_login_subtitle,
        ),
    };

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: isAvailable
            ? color.primary.withValues(alpha: 0.04)
            : color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: isAvailable
              ? color.primary.withValues(alpha: 0.3)
              : color.outlineVariant.withValues(alpha: 0.3),
          width: isAvailable ? 1.5 : Spacing.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isAvailable
                  ? color.primary.withValues(alpha: 0.1)
                  : color.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              size: Spacing.iconMd,
              color: isAvailable ? color.primary : color.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isAvailable)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Spacing.xxl),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: Spacing.iconSm + Spacing.xxs,
                color: color.primary,
              ),
            ),
        ],
      ),
    );
  }
}
