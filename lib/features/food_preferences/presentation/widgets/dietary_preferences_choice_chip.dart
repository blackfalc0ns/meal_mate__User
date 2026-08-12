import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
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

    return FilterChip(
      selected: isSelected,
      onSelected: onSelected,
      showCheckmark: false,
      label: Text(
        label,
        style: getMediumStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size13,
          color: isSelected ? color.onPrimary : color.onSurfaceVariant,
        ),
      ),
      avatar: isSelected
          ? SizedBox(
              width: Spacing.dietaryIconSize,
              height: Spacing.dietaryIconSize,
              child: SvgPicture.asset(
                Assets.dietaryPreferencesSelectedCheck,
                width: Spacing.dietaryIconSize,
                height: Spacing.dietaryIconSize,
              ),
            )
          : null,
      labelPadding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
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
    );
  }
}
