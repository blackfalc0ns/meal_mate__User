import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_form_field.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/building_type_selector.dart';

class HomeAddressFormCard extends StatelessWidget {
  const HomeAddressFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: Spacing.addressesHomeFormWidth,
      height: Spacing.addressesHomeFormHeight,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.addressesHomeFormRadius),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: Spacing.addressesHomeFormShadowBlur,
            offset: const Offset(
              Spacing.zero,
              Spacing.addressesHomeFormShadowOffsetY,
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Spacing.addressesHomeFormRadius),
        child: Stack(
          children: [
            PositionedDirectional(
              start: Spacing.addressesHomeFormTitleEnd,
              top: Spacing.addressesHomeFormTitleTop,
              child: Text(
                locale.addresses_home_address_title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: Spacing.addressesHomeFormTitleSize,
                  color: color.primary,
                ),
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormSubtitleEnd,
              top: Spacing.addressesHomeFormSubtitleTop,
              child: Text(
                locale.addresses_home_address_subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: Spacing.addressesHomeFormSubtitleSize,
                  color: color.onSurfaceVariant,
                ),
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormGovernorateTop,
              child: AddressFormField(
                label: locale.addresses_governorate_label,
                hint: locale.addresses_governorate_hint,
                iconAsset: Assets.addressesIconGovernorate,
                showDropdown: true,
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormAreaTop,
              child: AddressFormField(
                label: locale.addresses_area_label,
                hint: locale.addresses_area_hint,
                iconAsset: Assets.addressesIconArea,
                showDropdown: true,
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormBlockTop,
              child: AddressFormField(
                label: locale.addresses_block_label,
                hint: locale.addresses_block_hint,
                iconAsset: Assets.addressesIconBlock,
                showDropdown: true,
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormStreetTop,
              child: AddressFormField(
                label: locale.addresses_street_label,
                hint: locale.addresses_street_hint,
                iconAsset: Assets.addressesIconStreet,
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormAvenueTop,
              child: AddressFormField(
                label: locale.addresses_avenue_label,
                hint: locale.addresses_avenue_hint,
                iconAsset: Assets.addressesIconAvenue,
                optionalText: locale.addresses_optional,
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormBuildingTop,
              child: const BuildingTypeSelector(),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormFloorTop,
              child: AddressFormField(
                label: locale.addresses_floor_label,
                hint: locale.addresses_floor_hint,
                iconAsset: Assets.addressesIconFloor,
                showDropdown: true,
                small: true,
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormNumberTop,
              child: AddressFormField(
                label: locale.addresses_building_number_label,
                hint: locale.addresses_building_number_hint,
                iconAsset: Assets.addressesIconNumber,
                small: true,
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormApartmentTop,
              child: AddressFormField(
                label: locale.addresses_apartment_number_label,
                hint: locale.addresses_apartment_number_hint,
                iconAsset: Assets.addressesIconApartment,
                optionalText: locale.addresses_optional,
                small: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
