import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddAllergyOptionTile extends StatelessWidget {
  const AddAllergyOptionTile({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String? iconAsset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: label,
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
              iconAsset == null
                  ? Container(
                      width: Spacing.lg,
                      height: Spacing.lg,
                      decoration: BoxDecoration(
                        color: color.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                    )
                  : SvgPicture.asset(
                      iconAsset!,
                      width: Spacing.lg,
                      height: Spacing.lg,
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
                SvgPicture.asset(
                  AssetsFake.addAllergySelected,
                  width: Spacing.lg,
                  height: Spacing.lg,
                  semanticsLabel: locale.add_allergy_selected,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
