import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionCoverageErrorBanner extends StatelessWidget {
  const SubscriptionCoverageErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.errorContainer,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: color.error, width: Spacing.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: color.error,
            size: Spacing.iconSm,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.start,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
