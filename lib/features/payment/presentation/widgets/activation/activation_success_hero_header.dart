import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Celebration icon header with title and subtitle for offer activation.
class ActivationSuccessHeroHeader extends StatelessWidget {
  const ActivationSuccessHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.primary.withValues(alpha: 0.12),
          ),
          child: Icon(
            Icons.celebration_rounded,
            color: color.primary,
            size: 40,
          ),
        ),
        const SizedBox(height: Spacing.md),
        Text(
          locale.offer_activation_congrats,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size18,
            color: color.primary,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          locale.offer_activation_subtitle,
          textAlign: TextAlign.center,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size13,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
