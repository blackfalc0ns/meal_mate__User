import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class PaymentMethodRadioDot extends StatelessWidget {
  const PaymentMethodRadioDot({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: Spacing.lg,
      height: Spacing.lg,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? color.primary : color.outlineVariant,
          width: isSelected ? 0 : 1.5,
        ),
        color: isSelected ? color.primary : color.surface,
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, color: color.onPrimary, size: Spacing.md)
          : null,
    );
  }
}
