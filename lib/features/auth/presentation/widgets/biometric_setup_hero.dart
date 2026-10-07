import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class BiometricSetupHero extends StatelessWidget {
  const BiometricSetupHero({
    super.key,
    required this.presentationType,
  });

  final BiometricTypeEnum presentationType;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final iconData = switch (presentationType) {
      BiometricTypeEnum.face => Icons.face_rounded,
      BiometricTypeEnum.fingerprint => Icons.fingerprint_rounded,
      _ => Icons.fingerprint_rounded,
    };

    return Column(
      children: [
        Container(
          width: Spacing.xxxl * 2,
          height: Spacing.xxxl * 2,
          decoration: BoxDecoration(
            color: color.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.primary.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              iconData,
              size: Spacing.xxxl,
              color: color.primary,
            ),
          ),
        ),
        const SizedBox(height: Spacing.xl),
        Text(
          locale.biometric_setup_title,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size22,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          child: Text(
            locale.biometric_setup_subtitle,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurfaceVariant,
            ).copyWith(height: 1.45),
          ),
        ),
      ],
    );
  }
}
