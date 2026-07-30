import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: double.infinity,
      height: Spacing.profileLogoutHeight,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.logout_rounded, size: Spacing.lg),
        label: Text(
          locale.drawer_logout,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: Spacing.profileSettingsTitleFontSize,
            color: color.error,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: color.error,
          side: BorderSide(color: color.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.profileLogoutRadius),
          ),
        ),
      ),
    );
  }
}
