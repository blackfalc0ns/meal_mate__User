import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class VisaPaymentLogo extends StatelessWidget {
  const VisaPaymentLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: Spacing.xxxl * 1.5,
      height: Spacing.xl,
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: BorderRadius.circular(Spacing.xs),
      ),
      alignment: Alignment.center,
      child: Text(
        'VISA',
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size12,
          color: color.onPrimaryContainer,
        ),
      ),
    );
  }
}
