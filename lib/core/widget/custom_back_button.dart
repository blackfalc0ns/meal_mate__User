import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    required this.onPressed,
    this.top,
    this.end,
    this.size = Spacing.xxl,
    this.iconSize = Spacing.iconMd,
  });

  final VoidCallback onPressed;
  final double? top;
  final double? end;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Positioned(
      top: top ?? MediaQuery.paddingOf(context).top + Spacing.lg,
      right: end ?? Spacing.xl,
      child: Material(
        color: color.surface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: iconSize,
              color: color.onSurface,
              semanticLabel: locale.go_back,
            ),
          ),
        ),
      ),
    );
  }
}
