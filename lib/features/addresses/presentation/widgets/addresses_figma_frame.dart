import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_gps_button.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_map_marker.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/building_type_selector.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/current_location_card.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/home_address_form_card.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/location_confirmation_card.dart';

class AddressesFigmaFrame extends StatefulWidget {
  const AddressesFigmaFrame({
    super.key,
    required this.locations,
    required this.isSubmitting,
  });

  static const double locationConfirmationCardHeight =
      (Spacing.addressesChooseLocationCardPadding * 2) +
      ((Spacing.addressesChooseLocationTitleSize +
              Spacing.addressesChooseLocationSubtitleSize) *
          Spacing.addressesChooseLocationLineHeight) +
      Spacing.addressesChooseLocationHeaderGap +
      Spacing.addressesChooseLocationLineHeight +
      Spacing.addressesChooseLocationHeaderGap +
      Spacing.addressesChooseLocationButtonHeight;
  static const double frameHeight =
      Spacing.addressesChooseLocationColumnTop +
      locationConfirmationCardHeight +
      Spacing.addressesChooseLocationColumnGap +
      Spacing.addressesHomeFormHeight +
      Spacing.addressesChooseLocationColumnGap +
      Spacing.addressesCurrentLocationCardHeight +
      Spacing.addressesChooseLocationBottomPadding;

  final LocationsCatalogState locations;
  final bool isSubmitting;

  @override
  State<AddressesFigmaFrame> createState() => _AddressesFigmaFrameState();
}

class _AddressesFigmaFrameState extends State<AddressesFigmaFrame> {
  static const double _temporaryLatitude = 29.1322222;
  static const double _temporaryLongitude = 48.1261111;

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _avenueController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _buildingNumberController =
      TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  AddressBuildingType _buildingType = AddressBuildingType.home;

  @override
  void dispose() {
    _streetController.dispose();
    _avenueController.dispose();
    _floorController.dispose();
    _buildingNumberController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.addresses_choose_location_title,
      child: Container(
        width: Spacing.addressesChooseLocationDesignWidth,
        height: AddressesFigmaFrame.frameHeight,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          image: const DecorationImage(
            image: AssetImage(Assets.addressesChooseLocationMap),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: Spacing.addressesChooseLocationGpsTop),
            const Padding(
              padding: EdgeInsetsDirectional.only(
                start: Spacing.addressesChooseLocationGpsStart,
              ),
              child: Row(children: [AddressGpsButton()]),
            ),
            const SizedBox(
              height:
                  Spacing.addressesChooseLocationBadgeTop -
                  Spacing.addressesChooseLocationGpsTop -
                  Spacing.addressesChooseLocationGpsSize,
            ),
            const AddressMapMarker(),
            const SizedBox(
              height:
                  Spacing.addressesChooseLocationColumnTop -
                  Spacing.addressesChooseLocationPinTop -
                  Spacing.addressesChooseLocationPinSize,
            ),
            Center(
              child: Column(
                children: [
                  LocationConfirmationCard(
                    isLoading: widget.isSubmitting,
                    onConfirm: () => _submitAddress(context),
                  ),
                  const SizedBox(
                    height: Spacing.addressesChooseLocationColumnGap,
                  ),
                  HomeAddressFormCard(
                    governorates: widget.locations.governorates,
                    areas: widget.locations.areas,
                    blocks: widget.locations.blocks,
                    selectedGovernorate: widget.locations.selectedGovernorate,
                    selectedArea: widget.locations.selectedArea,
                    selectedBlock: widget.locations.selectedBlock,
                    streetController: _streetController,
                    avenueController: _avenueController,
                    floorController: _floorController,
                    buildingNumberController: _buildingNumberController,
                    apartmentController: _apartmentController,
                    selectedBuildingType: _buildingType,
                    onGovernorateSelected: (governorate) {
                      context.read<AddressesViewModel>().doIntent(
                        SelectAddressGovernorateEvent(governorate),
                      );
                    },
                    onAreaSelected: (area) {
                      context.read<AddressesViewModel>().doIntent(
                        SelectAddressAreaEvent(area),
                      );
                    },
                    onBlockSelected: (block) {
                      context.read<AddressesViewModel>().doIntent(
                        SelectAddressBlockEvent(block),
                      );
                    },
                    onBuildingTypeChanged: (type) {
                      setState(() {
                        _buildingType = type;
                        if (type == AddressBuildingType.building) {
                          _floorController.clear();
                          _apartmentController.clear();
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: Spacing.addressesChooseLocationColumnGap,
                  ),
                  const CurrentLocationCard(),
                  const SizedBox(
                    height: Spacing.addressesChooseLocationBottomPadding,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAddress(BuildContext context) {
    if (widget.isSubmitting) return;

    final locale = context.localization;
    final languageCode = Localizations.localeOf(context).languageCode;
    final governorate = widget.locations.selectedGovernorate;
    final area = widget.locations.selectedArea;
    final block = widget.locations.selectedBlock;
    final street = _streetController.text.trim();
    final avenue = _avenueController.text.trim();
    final floor = _floorController.text.trim();
    final building = _buildingNumberController.text.trim();
    final unit = _apartmentController.text.trim();
    final isHome = _buildingType == AddressBuildingType.home;
    final governorateName = governorate?.nameForLanguage(languageCode);
    final areaName = area?.nameForLanguage(languageCode);
    final blockName = block?.nameForLanguage(languageCode);
    final governorateCode = _regionCode(governorate?.code);
    final areaCode = _regionCode(area?.code);
    final blockCode = _regionCode(block?.code);
    final label = isHome
        ? locale.addresses_building_type_home
        : locale.addresses_building_type_building;
    final addressLine = _addressLine([
      governorateName,
      areaName,
      blockName,
      street,
      avenue,
      if (isHome) floor,
      building,
      if (isHome) unit,
    ]);

    if (area == null) {
      CustomSnackbar.showError(
        context: context,
        message: locale.addresses_area_required,
      );
      return;
    }

    context.read<AddressesViewModel>().doIntent(
      AddCustomerAddressEvent(
        CustomerAddressRequestEntity(
          label: label,
          addressLine: addressLine.isEmpty
              ? locale.addresses_home_address_title
              : addressLine,
          regionId: area.id,
          governorate: governorateCode,
          area: areaCode,
          block: blockCode,
          street: street.isEmpty ? null : street,
          building: building.isEmpty ? null : building,
          unit: isHome && unit.isNotEmpty ? unit : null,
          floor: isHome && floor.isNotEmpty ? floor : null,
          latitude: _temporaryLatitude,
          longitude: _temporaryLongitude,
          notes: avenue.isEmpty ? null : avenue,
          isDefault: true,
          notifyOnDelivery: true,
        ),
      ),
    );
  }

  String _addressLine(List<String?> parts) {
    return parts
        .where((part) => part != null && part.trim().isNotEmpty)
        .map((part) => part!.trim())
        .join(', ');
  }

  String? _regionCode(String? code) {
    final trimmedCode = code?.trim();
    return trimmedCode == null || trimmedCode.isEmpty ? null : trimmedCode;
  }
}
