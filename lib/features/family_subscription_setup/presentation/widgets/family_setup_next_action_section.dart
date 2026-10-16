import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class FamilySetupNextActionSection extends StatelessWidget {
  const FamilySetupNextActionSection({super.key, required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return AppButton.filled(
      text: locale.family_next_program,
      onPressed: () {
        onSave();
        unawaited(context.pushNamed(AppRoutes.familyProgramSetup));
      },
      borderRadius: Spacing.radiusPill,
      textColor: color.onPrimary,
      fontSize: FontSize.size12,
      iconWidget: Icon(
        Icons.chevron_right_rounded,
        color: color.onPrimary,
        size: Spacing.iconMd,
      ),
    );
  }
}
