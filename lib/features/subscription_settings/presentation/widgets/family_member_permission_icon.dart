import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';

class FamilyMemberPermissionIcon extends StatelessWidget {
  const FamilyMemberPermissionIcon({super.key, required this.type});

  final FamilyMemberPermissionSectionIconType type;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final icon = switch (type) {
      FamilyMemberPermissionSectionIconType.meals => Icons.restaurant_rounded,
      FamilyMemberPermissionSectionIconType.program =>
        Icons.calendar_month_rounded,
      FamilyMemberPermissionSectionIconType.settings => Icons.settings_rounded,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
      ),
      child: SizedBox.square(
        dimension: Spacing.familyPermissionsSectionIconBox,
        child: Icon(
          icon,
          semanticLabel: locale.localeName,
          size: Spacing.familyPermissionsSectionIconSize,
          color: color.primary,
        ),
      ),
    );
  }
}
