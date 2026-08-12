import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class BuildingTypeOption extends StatelessWidget {
  const BuildingTypeOption({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          Spacing.addressesHomeFormIconBoxRadius,
        ),
        child: Container(
          width: Spacing.addressesBuildingTypeSelectedWidth,
          height: Spacing.addressesBuildingTypeSelectedHeight,
          decoration: BoxDecoration(
            color: isSelected ? color.surface : color.surfaceContainerHighest,
            border: Border.all(
              color: isSelected ? color.primary : color.surfaceContainerHighest,
              width: Spacing.addressesHomeFormFieldBorder,
            ),
            borderRadius: BorderRadius.circular(
              Spacing.addressesHomeFormIconBoxRadius,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isSelected
                      ? getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: Spacing.addressesBuildingTypeTextSize,
                          color: color.primary,
                        )
                      : getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: Spacing.addressesBuildingTypeTextSize,
                          color: color.onSurfaceVariant,
                        ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              SvgPicture.asset(
                iconAsset,
                width: Spacing.addressesBuildingTypeIconSize,
                height: Spacing.addressesBuildingTypeIconSize,
                colorFilter: ColorFilter.mode(
                  isSelected ? color.primary : color.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
                semanticsLabel: locale.addresses_building_type_label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
