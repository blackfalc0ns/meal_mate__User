import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyMemberDetailActionButton extends StatelessWidget {
  const FamilyMemberDetailActionButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return AppButton.outlined(
      text: label,
      onPressed: () {},
      height: Spacing.familyMemberDetailButtonHeight,
      borderRadius: Spacing.familyMemberDetailButtonRadius,
      color: color.primary,
      textColor: color.primary,
      fontSize: FontSize.size12,
    
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
    );
  }
}
