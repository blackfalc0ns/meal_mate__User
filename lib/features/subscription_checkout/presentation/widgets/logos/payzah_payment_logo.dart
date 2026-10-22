import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class PayzahPaymentLogo extends StatelessWidget {
  const PayzahPaymentLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: Spacing.xxxl * 1.5,
      height: Spacing.xl,
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Spacing.xs),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.credit_card_rounded,
        color: color.primary,
        size: Spacing.lg,
      ),
    );
  }
}
