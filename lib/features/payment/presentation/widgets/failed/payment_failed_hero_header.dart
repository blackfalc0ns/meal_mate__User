import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';

/// Hero header widget displaying the payment failed 3D card illustration.
class PaymentFailedHeroHeader extends StatelessWidget {
  const PaymentFailedHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Spacing.md,
        bottom: Spacing.xs,
      ),
      child: Center(
        child: Image.asset(
          Assets.paymentFailedHero,
          height: 190,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
