import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_permission_info_dialog.dart';

class FamilyPermissionRow extends StatelessWidget {
  const FamilyPermissionRow({
    super.key,
    required this.permission,
    required this.value,
    this.isReadOnly = false,
    this.onChanged,
  });

  final FamilyPermissionItemEntity permission;
  final bool value;
  final bool isReadOnly;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final label = permission.localizedLabel(isArabic);
    final isConfigurable = permission.isManagerConfigurable;
    final isEnabled = !isReadOnly && isConfigurable;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      child: Row(
        children: [
          IconButton(
            key: Key('permission_info_${permission.key}'),
            icon: Icon(
              Icons.info_outline,
              size: 20,
              color: color.primary,
            ),
            tooltip: locale.family_permission_details_title,
            onPressed: () => FamilyPermissionInfoDialog.show(
              context,
              permission: permission,
              currentValue: value,
            ),
          ),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.isNotEmpty ? label : permission.key,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: isConfigurable ? color.onSurface : color.onSurfaceVariant,
                  ),
                ),
                if (!isConfigurable)
                  Text(
                    locale.family_permission_fixed_state,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                if (permission.requiredPermissions.isNotEmpty)
                  Text(
                    locale.family_permission_required_grants(
                      permission.requiredPermissions.join(', '),
                    ),
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.xs),
          if (!isConfigurable)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: (value ? color.primary : color.surfaceContainerHighest)
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
              ),
              child: Text(
                value
                    ? locale.family_permission_status_enabled
                    : locale.family_permission_status_disabled,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: value ? color.primary : color.onSurfaceVariant,
                ),
              ),
            )
          else
            Switch(
              value: value,
              onChanged: isEnabled ? onChanged : null,
              activeThumbColor: color.primary,
            ),
        ],
      ),
    );
  }
}
