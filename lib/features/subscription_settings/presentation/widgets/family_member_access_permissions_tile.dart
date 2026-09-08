import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberAccessPermissionsTile extends StatelessWidget {
  const FamilyMemberAccessPermissionsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return InkWell(
      onTap: () =>
          Navigator.of(context).pushNamed(AppRoutes.familyMemberPermissions),
      borderRadius: BorderRadius.circular(Spacing.radiusLg),
      child: Container(
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
            Container(
              width: Spacing.avatarMd,
              height: Spacing.avatarMd,
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
              ),
              child: Icon(
                Icons.tune_rounded,
                size: Spacing.iconMd,
                color: color.primary,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.family_member_access_permissions_tile_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    locale.family_member_access_permissions_tile_subtitle,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left_rounded,
              size: Spacing.iconLg,
              color: color.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
