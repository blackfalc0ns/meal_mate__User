import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class DietaryPreferencesChoiceChip extends StatelessWidget {
  const DietaryPreferencesChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: '${locale.profile_dietary_preferences}: $label',
      child: FilterChip(
        selected: isSelected,
        onSelected: onSelected,
        showCheckmark: isSelected,
        checkmarkColor: color.onPrimary,
        label: Text(
          label,
          style: getMediumStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size11,
            color: isSelected ? color.onPrimary : color.onSurfaceVariant,
          ),
        ),
        avatar: isSelected
            ? Icon(
                Icons.check_circle_rounded,
                size: Spacing.dietarySmallIconSize,
                color: color.onPrimary,
              )
            : null,
        labelPadding: const EdgeInsets.symmetric(horizontal: Spacing.xss),
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        side: BorderSide(
          color: isSelected ? color.primary : color.surfaceContainerHighest,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.dietaryChipRadius),
        ),
        selectedColor: color.primary,
        backgroundColor: color.surfaceContainerHighest,
      ),
    );
  }
}
