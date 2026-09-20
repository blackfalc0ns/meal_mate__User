import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class ProfileLogoutConfirmationSheet extends StatelessWidget {
  const ProfileLogoutConfirmationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.screenH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              locale.drawer_logout,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size18,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              locale.profile_logout_confirmation_message,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: color.error),
              child: Text(locale.drawer_logout),
            ),
            const SizedBox(height: Spacing.sm),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(locale.profile_logout_cancel),
            ),
          ],
        ),
      ),
    );
  }
}
