import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
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
    this.initialAddress,
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
  final CustomerAddressEntity? initialAddress;

  @override
  State<AddressesFigmaFrame> createState() => _AddressesFigmaFrameState();
}

class _AddressesFigmaFrameState extends State<AddressesFigmaFrame> {
  static const double _defaultLatitude = 29.34;
  static const double _defaultLongitude = 48.08;

  late double _currentLatitude;
  late double _currentLongitude;
  double? _lastGeocodedLat;
  double? _lastGeocodedLng;
  GoogleMapController? _mapController;
  Timer? _debounceTimer;
  bool _isInitialMapMove = true;

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _avenueController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _buildingNumberController =
      TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  AddressBuildingType _buildingType = AddressBuildingType.home;

  @override
  void initState() {
    super.initState();
    _currentLatitude = widget.initialAddress?.latitude ?? _defaultLatitude;
    _currentLongitude = widget.initialAddress?.longitude ?? _defaultLongitude;
    _fillInitialAddress(widget.initialAddress);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController?.dispose();
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

    return BlocListener<AddressesViewModel, AddressesState>(
      listenWhen: (previous, current) =>
          previous.mapAutofill != current.mapAutofill,
      listener: (context, state) {
        if (state.mapAutofill.isSuccess && state.mapAutofill.autofill != null) {
          final autofill = state.mapAutofill.autofill!;
          setState(() {
            _currentLatitude = autofill.latitude;
            _currentLongitude = autofill.longitude;
            if (autofill.street != null && autofill.street!.isNotEmpty) {
              _streetController.text = autofill.street!;
            }
            if (autofill.avenue != null && autofill.avenue!.isNotEmpty) {
              _avenueController.text = autofill.avenue!;
            }
            _buildingNumberController.clear();
            _floorController.clear();
            _apartmentController.clear();
          });
        }
      },
      child: Semantics(
        label: locale.addresses_choose_location_title,
        child: Container(
          width: Spacing.addressesChooseLocationDesignWidth,
          height: AddressesFigmaFrame.frameHeight,
          color: color.surfaceContainerHighest,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: Spacing.addressesChooseLocationColumnTop + 60,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_currentLatitude, _currentLongitude),
                    zoom: 16.0,
                  ),
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: Spacing.addressesChooseLocationGpsTop),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: Spacing.addressesChooseLocationGpsStart,
                    ),
                    child: Row(
                      children: [
                        AddressGpsButton(
                          onTap: () => _onGpsPressed(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height:
                        Spacing.addressesChooseLocationBadgeTop -
                        Spacing.addressesChooseLocationGpsTop -
                        Spacing.addressesChooseLocationGpsSize,
                  ),
                  const IgnorePointer(
                    child: AddressMapMarker(),
                  ),
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
                          selectedGovernorate:
                              widget.locations.selectedGovernorate,
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
                        CurrentLocationCard(
                          onTap: () => _onGpsPressed(context),
                        ),
                        const SizedBox(
                          height: Spacing.addressesChooseLocationBottomPadding,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _currentLatitude = position.target.latitude;
    _currentLongitude = position.target.longitude;
  }

  void _onCameraIdle() {
    if (_isInitialMapMove) {
      _isInitialMapMove = false;
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _triggerReverseGeocode(context);
    });
  }

  void _onGpsPressed(BuildContext context) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_currentLatitude, _currentLongitude),
      ),
    );
    _triggerReverseGeocode(context);
  }

  void _triggerReverseGeocode(BuildContext context) {
    if (_lastGeocodedLat != null && _lastGeocodedLng != null) {
      final latDiff = (_currentLatitude - _lastGeocodedLat!).abs();
      final lngDiff = (_currentLongitude - _lastGeocodedLng!).abs();
      if (latDiff < 0.0001 && lngDiff < 0.0001) {
        return;
      }
    }
    _lastGeocodedLat = _currentLatitude;
    _lastGeocodedLng = _currentLongitude;

    context.read<AddressesViewModel>().doIntent(
      ReverseGeocodeEvent(
        latitude: _currentLatitude,
        longitude: _currentLongitude,
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
    final initialAddress = widget.initialAddress;
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

    final request = CustomerAddressRequestEntity(
      label: label,
      addressLine: addressLine.isEmpty
          ? locale.addresses_home_address_title
          : addressLine,
      regionId: area.id,
      governorate: governorateCode,
      area: areaCode,
      block: blockCode,
      blockRegionId: block?.id,
      street: street.isEmpty ? null : street,
      avenue: avenue.isEmpty ? null : avenue,
      building: building.isEmpty ? null : building,
      unit: isHome && unit.isNotEmpty ? unit : null,
      floor: isHome && floor.isNotEmpty ? floor : null,
      latitude: _currentLatitude,
      longitude: _currentLongitude,
      notes: avenue.isEmpty ? null : avenue,
      isDefault: initialAddress?.isDefault ?? true,
      notifyOnDelivery: initialAddress?.notifyOnDelivery ?? true,
    );

    if (initialAddress != null && initialAddress.addressId.isNotEmpty) {
      context.read<AddressesViewModel>().doIntent(
        UpdateCustomerAddressEvent(
          addressId: initialAddress.addressId,
          request: request,
        ),
      );
      return;
    }

    context.read<AddressesViewModel>().doIntent(
      AddCustomerAddressEvent(request),
    );
  }

  void _fillInitialAddress(CustomerAddressEntity? address) {
    if (address == null) return;

    _streetController.text = address.street ?? '';
    _avenueController.text = address.notes ?? '';
    _floorController.text = address.floor ?? '';
    _buildingNumberController.text = address.building ?? '';
    _apartmentController.text = address.unit ?? '';
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
