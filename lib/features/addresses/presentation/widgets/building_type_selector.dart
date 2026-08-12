import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class BuildingTypeSelector extends StatelessWidget {
  const BuildingTypeSelector({super.key});

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
                  child: Center(
                    child: Container(
                      width: Spacing.addressesBuildingTypeSelectedWidth,
                      height: Spacing.addressesBuildingTypeSelectedHeight,
                      decoration: BoxDecoration(
                        color: color.surface,
                        border: Border.all(
                          color: color.primary,
                          width: Spacing.addressesHomeFormFieldBorder,
                        ),
                        borderRadius: BorderRadius.circular(
                          Spacing.addressesHomeFormIconBoxRadius,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            locale.addresses_building_type_home,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: Spacing.addressesBuildingTypeTextSize,
                              color: color.primary,
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          SvgPicture.asset(
                            Assets.addressesIconHome,
                            width: Spacing.addressesBuildingTypeIconSize,
                            height: Spacing.addressesBuildingTypeIconSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        locale.addresses_building_type_building,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: Spacing.addressesBuildingTypeTextSize,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      SvgPicture.asset(
                        Assets.addressesIconBuilding,
                        width: Spacing.addressesBuildingTypeIconSize,
                        height: Spacing.addressesBuildingTypeIconSize,
                        colorFilter: ColorFilter.mode(
                          color.onSurfaceVariant,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
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
