import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final topInset = MediaQuery.paddingOf(context).top;

    return Positioned(
      top: topInset + Spacing.lg,
      left: Spacing.xl,
      child: Semantics(
        label: locale.go_back,
        button: true,
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          color: color.onSurface,
          iconSize: Spacing.iconMd,
          style: IconButton.styleFrom(
            backgroundColor: color.surface.withValues(alpha: 0.92),
            fixedSize: const Size(Spacing.iconXl, Spacing.iconXl),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
            ),
          ),
        ),
      ),
    );
  }
}
