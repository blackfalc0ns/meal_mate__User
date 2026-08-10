import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberPermissionSwitch extends StatelessWidget {
  const FamilyMemberPermissionSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      toggled: value,
      label: locale.localeName,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: Spacing.familyPermissionsSwitchWidth,
          height: Spacing.familyPermissionsSwitchHeight,
          padding: const EdgeInsets.all(Spacing.xs),
          decoration: BoxDecoration(
            color: value ? color.primary : color.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
          ),
          child: Align(
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color.surface,
                shape: BoxShape.circle,
              ),
              child: const SizedBox.square(
                dimension: Spacing.familyPermissionsSwitchThumbSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
