import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_permission_icon.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_permission_row.dart';

class FamilyMemberPermissionsSectionCard extends StatelessWidget {
  const FamilyMemberPermissionsSectionCard({
    super.key,
    required this.section,
    required this.values,
    required this.onPermissionChanged,
  });

  final FamilyMemberPermissionSectionEntity section;
  final List<bool> values;
  final void Function(int permissionIndex, bool value) onPermissionChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.familyPermissionsSectionRadius,
        ),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.familyPermissionsSectionBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.10),
            blurRadius: Spacing.sm,
            offset: const Offset(0, Spacing.sm),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.familyPermissionsSectionPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FamilyMemberPermissionIcon(type: section.iconType),
                const SizedBox(width: Spacing.md),
                Text(
                  _sectionTitle(locale),
                
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.xs),
            for (int index = 0; index < section.permissions.length; index++)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FamilyMemberPermissionRow(
                    permission: section.permissions[index],
                    value: values[index],
                    onChanged: (value) => onPermissionChanged(index, value),
                  ),
                  if (index != section.permissions.length - 1)
                    Divider(
                      height: Spacing.familyPermissionsDividerHeight,
                      thickness: Spacing.familyPermissionsDividerHeight,
                      color: color.outlineVariant,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _sectionTitle(AppLocalizations locale) {
    return switch (section.iconType) {
      FamilyMemberPermissionSectionIconType.meals =>
        locale.family_member_permissions_meals_section,
      FamilyMemberPermissionSectionIconType.program =>
        locale.family_member_permissions_program_section,
      FamilyMemberPermissionSectionIconType.settings =>
        locale.family_member_permissions_settings_section,
    };
  }
}
