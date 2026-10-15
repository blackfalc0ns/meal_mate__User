import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyMemberDialogActions extends StatelessWidget {
  const FamilyMemberDialogActions({
    super.key,
    required this.isEditing,
    required this.onSubmit,
    required this.onCancel,
  });

  final bool isEditing;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        AppButton.filled(
          text: isEditing
              ? locale.profile_personal_info_save
              : locale.family_add_member_button,
          onPressed: onSubmit,
          borderRadius: Spacing.radiusPill,
          textColor: color.onPrimary,
          fontSize: FontSize.size13,
        ),
        const SizedBox(height: Spacing.xs),
        TextButton(
          onPressed: onCancel,
          child: Text(
            locale.family_cancel,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              color: color.onSurface,
              fontSize: FontSize.size12,
            ),
          ),
        ),
        const SizedBox(height: Spacing.xs),
      ],
    );
  }
}
