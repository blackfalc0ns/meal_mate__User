import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';

class FamilyPermissionInfoDialog extends StatelessWidget {
  const FamilyPermissionInfoDialog({
    super.key,
    required this.permission,
    required this.currentValue,
  });

  final FamilyPermissionItemEntity permission;
  final bool currentValue;

  static Future<void> show(
    BuildContext context, {
    required FamilyPermissionItemEntity permission,
    required bool currentValue,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => FamilyPermissionInfoDialog(
        permission: permission,
        currentValue: currentValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final label = permission.localizedLabel(isArabic);
    final description = permission.localizedDescription(isArabic);

    return AlertDialog(
      backgroundColor: color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      title: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: color.primary,
            size: 22,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              label.isNotEmpty ? label : locale.family_permission_details_title,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description.isNotEmpty) ...[
              Text(
                description,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.md),
            ],
            // Current value indicator
            Row(
              children: [
                Text(
                  '${locale.family_permission_current_status}: ',
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: currentValue
                        ? color.primary.withValues(alpha: 0.15)
                        : color.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(Spacing.radiusXs),
                  ),
                  child: Text(
                    currentValue
                        ? locale.family_permission_status_enabled
                        : locale.family_permission_status_disabled,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: currentValue ? color.primary : color.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            // Editability / Non-configurable indicator
            if (!permission.isManagerConfigurable) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Spacing.xs),
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: color.onSurfaceVariant,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        locale.family_permission_fixed_state,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.sm),
            ],
            // Prerequisites / Required permissions
            if (permission.requiredPermissions.isNotEmpty) ...[
              Text(
                locale.family_permission_required_grants(
                  permission.requiredPermissions.join(', '),
                ),
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Wrap(
                spacing: Spacing.xs,
                runSpacing: Spacing.xs,
                children: [
                  for (final req in permission.requiredPermissions)
                    Chip(
                      label: Text(
                        req,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      backgroundColor: color.surfaceContainerHighest,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            locale.family_permission_close,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.primary,
            ),
          ),
        ),
      ],
    );
  }
}
