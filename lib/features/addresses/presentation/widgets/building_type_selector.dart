import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/building_type_option.dart';

class BuildingTypeSelector extends StatelessWidget {
  const BuildingTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final AddressBuildingType selectedType;
  final ValueChanged<AddressBuildingType> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: Spacing.addressesHomeFormFieldWidth,
      height: Spacing.addressesHomeFormFieldHeight,
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(
          Spacing.addressesHomeFormFieldRadius,
        ),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            start: Spacing.addressesBuildingTypeLabelEnd,
            top: Spacing.addressesBuildingTypeLabelTop,
            child: Text(
              locale.addresses_building_type_label,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: Spacing.addressesBuildingTypeLabelSize,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
          Positioned.fill(
            top: Spacing.addressesBuildingTypeSelectedTop,
            child: Row(
              children: [
                Expanded(
                  child: BuildingTypeOption(
                    label: locale.addresses_building_type_home,
                    iconAsset: Assets.addressesIconHome,
                    isSelected: selectedType == AddressBuildingType.home,
                    onTap: () => onChanged(AddressBuildingType.home),
                  ),
                ),
                Expanded(
                  child: BuildingTypeOption(
                    label: locale.addresses_building_type_building,
                    iconAsset: Assets.addressesIconBuilding,
                    isSelected: selectedType == AddressBuildingType.building,
                    onTap: () => onChanged(AddressBuildingType.building),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum AddressBuildingType { home, building }
