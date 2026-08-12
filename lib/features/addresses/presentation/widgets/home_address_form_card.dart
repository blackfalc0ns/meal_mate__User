import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_form_field.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/building_type_selector.dart';

class HomeAddressFormCard extends StatefulWidget {
  const HomeAddressFormCard({
    super.key,
    required this.governorates,
    required this.areas,
    required this.blocks,
    this.selectedGovernorate,
    this.selectedArea,
    this.selectedBlock,
    required this.onGovernorateSelected,
    required this.onAreaSelected,
    required this.onBlockSelected,
  });

  final List<LocationGovernorateEntity> governorates;
  final List<LocationAreaEntity> areas;
  final List<LocationBlockEntity> blocks;
  final LocationGovernorateEntity? selectedGovernorate;
  final LocationAreaEntity? selectedArea;
  final LocationBlockEntity? selectedBlock;
  final ValueChanged<LocationGovernorateEntity> onGovernorateSelected;
  final ValueChanged<LocationAreaEntity> onAreaSelected;
  final ValueChanged<LocationBlockEntity> onBlockSelected;

  @override
  State<HomeAddressFormCard> createState() => _HomeAddressFormCardState();
}

class _HomeAddressFormCardState extends State<HomeAddressFormCard> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _avenueController = TextEditingController();
  final TextEditingController _buildingNumberController =
      TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  AddressBuildingType _buildingType = AddressBuildingType.home;

  @override
  void dispose() {
    _streetController.dispose();
    _avenueController.dispose();
    _buildingNumberController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

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
              child: Builder(
                builder: (fieldContext) {
                  return AddressFormField(
                    label: locale.addresses_governorate_label,
                    hint: locale.addresses_governorate_hint,
                    iconAsset: Assets.addressesIconGovernorate,
                    showDropdown: true,
                    value: widget.selectedGovernorate?.nameForLanguage(
                      Localizations.localeOf(context).languageCode,
                    ),
                    onTap: () => _showOptions<LocationGovernorateEntity>(
                      context: fieldContext,
                      items: widget.governorates,
                      labelBuilder: (item) => item.nameForLanguage(
                        Localizations.localeOf(context).languageCode,
                      ),
                      onSelected: widget.onGovernorateSelected,
                    ),
                  );
                },
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormAreaTop,
              child: Builder(
                builder: (fieldContext) {
                  return AddressFormField(
                    label: locale.addresses_area_label,
                    hint: locale.addresses_area_hint,
                    iconAsset: Assets.addressesIconArea,
                    showDropdown: true,
                    value: widget.selectedArea?.nameForLanguage(
                      Localizations.localeOf(context).languageCode,
                    ),
                    onTap: widget.selectedGovernorate == null
                        ? null
                        : () => _showOptions<LocationAreaEntity>(
                            context: fieldContext,
                            items: widget.areas,
                            labelBuilder: (item) => item.nameForLanguage(
                              Localizations.localeOf(context).languageCode,
                            ),
                            onSelected: widget.onAreaSelected,
                          ),
                  );
                },
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormBlockTop,
              child: Builder(
                builder: (fieldContext) {
                  return AddressFormField(
                    label: locale.addresses_block_label,
                    hint: locale.addresses_block_hint,
                    iconAsset: Assets.addressesIconBlock,
                    showDropdown: true,
                    value: widget.selectedBlock?.nameForLanguage(
                      Localizations.localeOf(context).languageCode,
                    ),
                    onTap: widget.selectedArea == null
                        ? null
                        : () => _showOptions<LocationBlockEntity>(
                            context: fieldContext,
                            items: widget.blocks,
                            labelBuilder: (item) => item.nameForLanguage(
                              Localizations.localeOf(context).languageCode,
                            ),
                            onSelected: widget.onBlockSelected,
                          ),
                  );
                },
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormStreetTop,
              child: AddressFormField(
                label: locale.addresses_street_label,
                hint: locale.addresses_street_hint,
                iconAsset: Assets.addressesIconStreet,
                controller: _streetController,
                textInputAction: TextInputAction.next,
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormAvenueTop,
              child: AddressFormField(
                label: locale.addresses_avenue_label,
                hint: locale.addresses_avenue_hint,
                iconAsset: Assets.addressesIconAvenue,
                controller: _avenueController,
                textInputAction: TextInputAction.next,
                optionalText: locale.addresses_optional,
              ),
            ),
            PositionedDirectional(
              start: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormBuildingTop,
              child: BuildingTypeSelector(
                selectedType: _buildingType,
                onChanged: (type) => setState(() => _buildingType = type),
              ),
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
                controller: _buildingNumberController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
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
                controller: _apartmentController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                optionalText: locale.addresses_optional,
                small: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showOptions<T>({
    required BuildContext context,
    required List<T> items,
    required String Function(T item) labelBuilder,
    required ValueChanged<T> onSelected,
  }) async {
    if (items.isEmpty) return;

    final color = context.colorScheme;
    final renderBox = context.findRenderObject() as RenderBox?;
    final overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;
    if (renderBox == null || overlay == null) return;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(Offset.zero, ancestor: overlay),
        renderBox.localToGlobal(
          renderBox.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<T>(
      context: context,
      position: position,
      color: color.surface,
      items: items
          .map(
            (item) => PopupMenuItem<T>(
              value: item,
              child: Text(
                labelBuilder(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
            ),
          )
          .toList(),
    );

    if (selected != null) {
      onSelected(selected);
    }
  }
}
