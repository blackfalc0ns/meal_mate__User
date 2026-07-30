import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionBestValueBadge extends StatelessWidget {
  const SubscriptionBestValueBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.lg,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xss),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(Spacing.radiusPill),
      ),
      child: Text(
        locale.subscription_best_value,
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size10,
          color: color.onPrimary,
        ),
      ),
    );
  }
}
