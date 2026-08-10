import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilyMemberPermissionsHeader extends StatelessWidget {
  const FamilyMemberPermissionsHeader({super.key, required this.permissions});

  final FamilyMemberPermissionsPageEntity permissions;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.familyPermissionsHeaderHeight,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Spacing.familyPermissionsAvatarRadius,
            ),
            child: Image.asset(
              permissions.memberImageAsset,
              width: Spacing.familyPermissionsAvatarWidth,
              height: Spacing.familyPermissionsAvatarHeight,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Spacing.base),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.family_member_permissions_title(
                    permissions.memberName,
                  ),
                  locale: Locale(locale.localeName),
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
                Text(
                  locale.family_member_permissions_subtitle(
                    permissions.memberName,
                  ),
                  locale: Locale(locale.localeName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
