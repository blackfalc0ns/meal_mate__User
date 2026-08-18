import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddAllergyOptionTile extends StatelessWidget {
  const AddAllergyOptionTile({
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
    final locale = context.localization;

    return Semantics(
      label: isSelected ? '$label ${locale.add_allergy_selected}' : label,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.addAllergyGridTileRadius),
        child: Ink(
          height: Spacing.addAllergyGridTileHeight,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
          decoration: BoxDecoration(
            color: isSelected
                ? color.primaryContainer
                : color.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(
              Spacing.addAllergyGridTileRadius,
            ),
            border: Border.all(
              color: isSelected ? color.primary : color.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: Spacing.lg,
                height: Spacing.lg,
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  size: Spacing.lg,
                  color: color.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
