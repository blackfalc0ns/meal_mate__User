import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberPermissionsConfirmDialog extends StatelessWidget {
  const FamilyMemberPermissionsConfirmDialog({
    super.key,
    required this.memberName,
    required this.onConfirm,
  });

  final String memberName;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return AlertDialog(
      backgroundColor: color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      title: Text(
        locale.family_member_permissions_confirm_title,
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size16,
          color: color.onSurface,
        ),
      ),
      content: Text(
        locale.family_member_permissions_confirm_desc(memberName),
        style: getRegularStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size13,
          color: color.onSurfaceVariant,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            locale.family_member_permissions_confirm_cancel,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurfaceVariant,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(
            locale.family_member_permissions_confirm_action,
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
