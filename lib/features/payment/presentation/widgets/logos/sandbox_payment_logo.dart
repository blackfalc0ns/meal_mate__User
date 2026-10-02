import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SandboxPaymentLogo extends StatelessWidget {
  const SandboxPaymentLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: Spacing.xxxl * 1.5,
      height: Spacing.xl,
      decoration: BoxDecoration(
        color: color.secondaryContainer,
        borderRadius: BorderRadius.circular(Spacing.xs),
      ),
      alignment: Alignment.center,
      child: Text(
        locale.sandbox_badge,
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size11,
          color: color.onSecondaryContainer,
        ),
      ),
    );
  }
}
