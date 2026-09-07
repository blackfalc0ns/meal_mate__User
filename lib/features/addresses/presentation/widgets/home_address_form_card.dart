import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_form_field.dart';

class HomeAddressFormCard extends StatefulWidget {
  const HomeAddressFormCard({
    super.key,
    required this.governorates,
    required this.areas,
    required this.blocks,
    this.selectedGovernorate,
    this.selectedArea,
    this.selectedBlock,
    required this.streetController,
    required this.avenueController,
    required this.floorController,
    required this.buildingNumberController,
    required this.apartmentController,
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
  final TextEditingController streetController;
  final TextEditingController avenueController;
  final TextEditingController floorController;
  final TextEditingController buildingNumberController;
  final TextEditingController apartmentController;
  final ValueChanged<LocationGovernorateEntity> onGovernorateSelected;
  final ValueChanged<LocationAreaEntity> onAreaSelected;
  final ValueChanged<LocationBlockEntity> onBlockSelected;

  @override
  State<HomeAddressFormCard> createState() => _HomeAddressFormCardState();
}

class _HomeAddressFormCardState extends State<HomeAddressFormCard> {
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
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(
            bottom: Spacing.addressesHomeFormTitleTop,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: Spacing.addressesHomeFormFieldStart,
              end: Spacing.addressesHomeFormFieldStart,
              top: Spacing.addressesHomeFormTitleTop,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start:
                        Spacing.addressesHomeFormTitleEnd -
                        Spacing.addressesHomeFormFieldStart,
                  ),
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
                SizedBox(
                  height:
                      Spacing.addressesHomeFormSubtitleTop -
                      Spacing.addressesHomeFormTitleTop -
                      Spacing.addressesHomeFormTitleSize,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start:
                        Spacing.addressesHomeFormSubtitleEnd -
                        Spacing.addressesHomeFormFieldStart,
                  ),
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
                SizedBox(
                  height:
                      Spacing.addressesHomeFormGovernorateTop -
                      Spacing.addressesHomeFormSubtitleTop -
                      Spacing.addressesHomeFormSubtitleSize,
                ),
                Builder(
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
                        title: locale.addresses_governorate_label,
                        items: widget.governorates,
                        selectedValue: widget.selectedGovernorate,
                        labelBuilder: (item) => item.nameForLanguage(
                          Localizations.localeOf(context).languageCode,
                        ),
                        onSelected: widget.onGovernorateSelected,
                      ),
                    );
                  },
                ),
                const SizedBox(height: Spacing.addressesHomeFormFieldGap),
                Builder(
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
                              title: locale.addresses_area_label,
                              items: widget.areas,
                              selectedValue: widget.selectedArea,
                              labelBuilder: (item) => item.nameForLanguage(
                                Localizations.localeOf(context).languageCode,
                              ),
                              onSelected: widget.onAreaSelected,
                            ),
                    );
                  },
                ),
                const SizedBox(height: Spacing.addressesHomeFormFieldGap),
                Builder(
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
                              title: locale.addresses_block_label,
                              items: widget.blocks,
                              selectedValue: widget.selectedBlock,
                              labelBuilder: (item) => item.nameForLanguage(
                                Localizations.localeOf(context).languageCode,
                              ),
                              onSelected: widget.onBlockSelected,
                            ),
                    );
                  },
                ),
                const SizedBox(height: Spacing.addressesHomeFormFieldGap),
                AddressFormField(
                  label: locale.addresses_street_label,
                  hint: locale.addresses_street_hint,
                  iconAsset: Assets.addressesIconStreet,
                  controller: widget.streetController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: Spacing.addressesHomeFormFieldGap),
                AddressFormField(
                  label: locale.addresses_avenue_label,
                  hint: locale.addresses_avenue_hint,
                  iconAsset: Assets.addressesIconAvenue,
                  controller: widget.avenueController,
                  textInputAction: TextInputAction.next,
                  optionalText: locale.addresses_optional,
                ),
                const SizedBox(height: Spacing.addressesHomeFormFieldGap),
                AddressFormField(
                  label: locale.addresses_floor_label,
                  hint: locale.addresses_floor_hint,
                  iconAsset: Assets.addressesIconFloor,
                  controller: widget.floorController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  small: true,
                ),
                const SizedBox(height: Spacing.addressesHomeFormFieldGap),
                AddressFormField(
                  label: locale.addresses_building_number_label,
                  hint: locale.addresses_building_number_hint,
                  iconAsset: Assets.addressesIconNumber,
                  controller: widget.buildingNumberController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  small: true,
                ),
                const SizedBox(height: Spacing.addressesHomeFormFieldGap),
                AddressFormField(
                  label: locale.addresses_apartment_number_label,
                  hint: locale.addresses_apartment_number_hint,
                  iconAsset: Assets.addressesIconApartment,
                  controller: widget.apartmentController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  optionalText: locale.addresses_optional,
                  small: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showOptions<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required T? selectedValue,
    required String Function(T item) labelBuilder,
    required ValueChanged<T> onSelected,
  }) async {
    if (items.isEmpty) return;

    final color = context.colorScheme;
    final selected = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: Spacing.xxxl,
                    height: Spacing.xs,
                    decoration: BoxDecoration(
                      color: color.outlineVariant,
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.base),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size18,
                    color: color.primary,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, _) => Divider(
                      height: Spacing.border,
                      thickness: Spacing.border,
                      color: color.outlineVariant,
                    ),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final isSelected = item == selectedValue;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          labelBuilder(item),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size16,
                            color: color.onSurface,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                color: color.primary,
                                size: Spacing.iconMd,
                              )
                            : null,
                        onTap: () => Navigator.of(sheetContext).pop(item),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;

    if (selected != null) {
      onSelected(selected);
    }
  }
}
