import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final borderRadius = BorderRadius.circular(Spacing.xxl + Spacing.xs);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: color.surface.withValues(alpha: 0.50),
            borderRadius: borderRadius,
            border: Border.all(
              color: color.surface.withValues(alpha: 0.68),
              width: Spacing.border,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.12),
                blurRadius: 30,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.xl,
              vertical: Spacing.xxl,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
