import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionTypeNotice extends StatelessWidget {
  const SubscriptionTypeNotice({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.subscriptionInfoHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      decoration: BoxDecoration(
        color: color.tertiaryContainer.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(
          Spacing.subscriptionProgramCardRadius,
        ),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Spacing.xl,
            height: Spacing.xl,
            decoration: BoxDecoration(
              color: color.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.priority_high_rounded,
              color: color.onPrimary,
              size: Spacing.iconSm,
              semanticLabel: locale.nav_subscription,
            ),
          ),
                     const SizedBox(width: Spacing.md),

          Flexible(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.primary,
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}
