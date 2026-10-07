import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class ProfileAppVersionFooter extends StatelessWidget {
  const ProfileAppVersionFooter({super.key, this.version = '1.0.0 (Demo)'});

  /// Dynamic app version string. If null or empty, an unavailable label will be shown.
  final String? version;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final displayText = (version != null && version!.trim().isNotEmpty)
        ? locale.profile_settings_version_value(version!)
        : locale.profile_settings_version_unavailable;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xxs,
        ),
        decoration: BoxDecoration(
          color: color.secondaryContainer,
          borderRadius: BorderRadius.circular(Spacing.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.verified_user_rounded,
              size: Spacing.iconSm,
              color: color.primary,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              displayText,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
