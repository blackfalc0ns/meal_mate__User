import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilySubscriptionToggleSwitch extends StatelessWidget {
  const FamilySubscriptionToggleSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isEnabled = onChanged != null;

    return Semantics(
      toggled: value,
      enabled: isEnabled,
      child: GestureDetector(
        onTap: isEnabled ? () => onChanged!(!value) : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: Spacing.familyPermissionsSwitchWidth,
          height: Spacing.familyPermissionsSwitchHeight,
          padding: const EdgeInsets.all(Spacing.xxs),
          decoration: BoxDecoration(
            color: value
                ? color.primary
                : color.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
            border: Border.all(
              color: value
                  ? color.primary
                  : color.outlineVariant.withValues(alpha: 0.5),
              width: 1.0,
            ),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: AlignmentDirectional(value ? 1.0 : -1.0, 0.0),
            child: Container(
              width: Spacing.familyPermissionsSwitchThumbSize,
              height: Spacing.familyPermissionsSwitchThumbSize,
              decoration: BoxDecoration(
                color: color.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.18),
                    blurRadius: 3.0,
                    offset: const Offset(0.0, 1.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
