import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberDialogHeader extends StatelessWidget {
  const FamilyMemberDialogHeader({
    super.key,
    required this.isEditing,
    required this.onClose,
  });

  final bool isEditing;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            IconButton(
              onPressed: onClose,
              icon: CircleAvatar(
                radius: 12,
                backgroundColor: color.surfaceContainerHighest,
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: color.onSurface,
                ),
              ),
            ),
          ],
        ),
        Icon(Icons.person_add_alt_1_rounded, color: color.primary, size: 48),
        const SizedBox(height: Spacing.xss),
        Text(
          isEditing ? locale.family_edit_member : locale.family_add_member,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            color: color.onSurface,
            fontSize: FontSize.size17,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          locale.family_add_member_dialog_subtitle,
          textAlign: TextAlign.center,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            color: color.onSurfaceVariant,
            fontSize: FontSize.size10,
          ),
        ),
      ],
    );
  }
}
