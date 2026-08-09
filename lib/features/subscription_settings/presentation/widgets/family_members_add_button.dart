import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilyMembersAddButton extends StatelessWidget {
  const FamilyMembersAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: double.infinity,
      height: Spacing.familyMembersAddButtonHeight,
      child: AppButton(
        text: locale.family_members_add_member,
        onPressed: () {},
        height: Spacing.familyMembersAddButtonHeight,
        borderRadius: Spacing.familyMembersAddButtonRadius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.primary.withValues(alpha: 0.8), color.primary],
        ),
        textColor: color.onPrimary,
        fontSize: FontSize.size17,
        fontWeight: FontWeightManger.semiBold,
      ),
    );
  }
}
