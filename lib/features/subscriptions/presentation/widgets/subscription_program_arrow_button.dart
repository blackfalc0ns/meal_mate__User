import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionProgramArrowButton extends StatelessWidget {
  const SubscriptionProgramArrowButton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      button: true,
      label: locale.subscription_choose_plan_button,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.03),
              offset: const Offset(0, Spacing.xss),
              blurRadius: Spacing.xss,
            ),
          ],
        ),
        child: SizedBox.square(
          dimension: Spacing.xxl,
          child: Icon(
            Icons.arrow_forward_ios_outlined,
            color: color.onSurface,
            size: Spacing.iconSm,
          ),
        ),
      ),
    );
  }
}
