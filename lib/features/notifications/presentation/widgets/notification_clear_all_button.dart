import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class NotificationClearAllButton extends StatelessWidget {
  const NotificationClearAllButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.base,
      ),
      child: SizedBox(
        width: double.infinity,
        height: Spacing.buttonHeight,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: color.error.withValues(alpha: 0.08),
            foregroundColor: color.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.buttonRadius),
            ),
          ),
          child: Text(
            locale.notifications_clear_all,
            style: AppTextStyles.button.copyWith(
              color: color.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
