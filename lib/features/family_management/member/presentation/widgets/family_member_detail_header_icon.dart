import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberDetailHeaderIcon extends StatelessWidget {
  const FamilyMemberDetailHeaderIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: Spacing.familyMemberDetailHeaderIconSize,
      height: Spacing.familyMemberDetailHeaderIconSize,
      decoration: BoxDecoration(
        color: color.secondaryContainer,
        borderRadius: BorderRadius.circular(Spacing.radiusXs),
      ),
      child: Icon(
        icon,
        size: Spacing.iconSm,
        color: color.primary,
        semanticLabel: locale.localeName,
      ),
    );
  }
}
