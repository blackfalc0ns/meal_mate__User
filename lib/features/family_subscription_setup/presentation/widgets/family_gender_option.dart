import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyGenderOption extends StatelessWidget {
  const FamilyGenderOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Spacing.buttonSmallHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? color.primary.withValues(alpha: 0.08)
              : color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          border: Border.all(
            color: isSelected ? color.primary : color.outlineVariant,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: isSelected ? color.primary : color.onSurface,
          ),
        ),
      ),
    );
  }
}
