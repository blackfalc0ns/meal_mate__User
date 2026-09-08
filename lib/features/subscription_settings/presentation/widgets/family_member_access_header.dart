import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilyMemberAccessHeader extends StatelessWidget {
  const FamilyMemberAccessHeader({super.key, required this.member});

  final FamilyMemberAccessEntity member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isActive = member.status == FamilyMemberAccessStatus.active;
    final statusText = isActive
        ? locale.family_member_access_status_active
        : locale.family_member_access_status_paused;
    final badgeColor = isActive ? color.primary : color.onSurfaceVariant;
    final badgeBg = isActive
        ? color.primary.withValues(alpha: 0.12)
        : color.outlineVariant.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.border,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Spacing.familyPermissionsAvatarRadius,
            ),
            child: Image.asset(
              member.memberImageAsset,
              width: Spacing.familyPermissionsAvatarWidth,
              height: Spacing.familyPermissionsAvatarHeight,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Spacing.base),
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
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                        border: Border.all(
                          color: badgeColor.withValues(alpha: 0.3),
                          width: Spacing.hairline,
                        ),
                      ),
                      child: Text(
                        statusText,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    Container(
                      width: Spacing.sm,
                      height: Spacing.sm,
                      decoration: BoxDecoration(
                        color: badgeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        locale.family_member_access_last_login(
                          member.lastLogin,
                        ),
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
        ],
      ),
    );
  }
}
