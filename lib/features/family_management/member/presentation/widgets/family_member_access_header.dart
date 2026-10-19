import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberAccessHeader extends StatelessWidget {
  const FamilyMemberAccessHeader({
    super.key,
    required this.isPaused,
    required this.hasExistingLogin,
    this.avatarAsset = Assets.profileAvatar,
  });

  final bool isPaused;
  final bool hasExistingLogin;
  final String avatarAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isActive = !isPaused;
    final statusText = isActive
        ? locale.family_member_access_status_active
        : locale.family_member_access_status_paused;
    final statusColor = isActive ? color.primary : color.error;
    final statusBg = statusColor.withValues(alpha: 0.12);

    final subtitleText = hasExistingLogin
        ? locale.family_member_access_existing_login
        : (isActive
              ? locale.family_member_access_status_active
              : locale.family_member_access_status_paused);

    return Container(
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      locale.family_member_access_status_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      ),
                      child: Text(
                        statusText,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    Container(
                      width: Spacing.xss + 1,
                      height: Spacing.xss + 1,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        subtitleText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            child: Image.asset(
              avatarAsset,
              width: 62.0,
              height: 62.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
