import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerWithdrawNoticeBanner extends StatelessWidget {
  const InfluencerWithdrawNoticeBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_rounded, color: color.primary, size: Spacing.iconMd),
          const SizedBox(width: Spacing.sm),

          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.start,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
