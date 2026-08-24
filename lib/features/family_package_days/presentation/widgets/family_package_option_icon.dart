import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyPackageOptionIconView extends StatelessWidget {
  const FamilyPackageOptionIconView({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return CircleAvatar(
      radius: Spacing.familyPackageOptionIconRadius,
      backgroundColor: color.primaryContainer.withValues(alpha: 0.35),
      child: Icon(icon, color: color.primary, size: Spacing.iconMd),
    );
  }
}
