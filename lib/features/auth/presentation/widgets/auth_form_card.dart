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
    final locale = context.localization;
    final borderRadius = BorderRadius.circular(Spacing.bottomSheetRadius);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: Spacing.xs, sigmaY: Spacing.xs),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: color.surface.withValues(alpha: 0.14),
            borderRadius: borderRadius,
            border: Border.all(
              color: color.onSurface.withValues(alpha: 0.16),
              width: Spacing.border,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.16),
                blurRadius: Spacing.lg,
                offset: const Offset(0, Spacing.md),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.xl,
              vertical: Spacing.xxl,
            ),
            child: Directionality(
              textDirection: locale.localeName == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
