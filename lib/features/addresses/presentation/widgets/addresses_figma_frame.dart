import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/address_entry_flow_controller.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_options_row.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_details_wolt_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_map_marker.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/home_address_form_card.dart';

class AddressesFigmaFrame extends StatefulWidget {
  const AddressesFigmaFrame({
    super.key,
    required this.locations,
    required this.isSubmitting,
    this.initialAddress,
    this.showInitialAddressDetails = true,
    this.flowController,
  });

  static const double frameHeight = Spacing.addressesChooseLocationDesignHeight;

  final LocationsCatalogState locations;
  final bool isSubmitting;
  final CustomerAddressEntity? initialAddress;
  final bool showInitialAddressDetails;
  final AddressEntryFlowController? flowController;

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
  bool _openDetailsAfterAutofill = false;
  AddressLocationMode? _selectedMode;
  late final AddressEntryFlowController _flowController;
  late final bool _ownsFlowController;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _avenueController = TextEditingController();
  final TextEditingController _buildingNumberController =
      TextEditingController();
  final ValueNotifier<bool> _buildingNumberHasError = ValueNotifier(false);
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentLatitude = widget.initialAddress?.latitude ?? _defaultLatitude;
    _currentLongitude = widget.initialAddress?.longitude ?? _defaultLongitude;
    _ownsFlowController = widget.flowController == null;
    _flowController = widget.flowController ?? AddressEntryFlowController();
    if (widget.initialAddress != null && widget.showInitialAddressDetails) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showDetailsSheet(context);
      });
    }
    _flowController.addListener(_onFlowStageChanged);
    _buildingNumberController.addListener(_onBuildingNumberChanged);
    _fillInitialAddress(widget.initialAddress);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController?.dispose();
    _searchController.dispose();
    _streetController.dispose();
    _avenueController.dispose();
    _buildingNumberController.removeListener(_onBuildingNumberChanged);
    _buildingNumberController.dispose();
    _buildingNumberHasError.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _flowController.removeListener(_onFlowStageChanged);
    if (_ownsFlowController) _flowController.dispose();
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
            if (autofill.building != null &&
                autofill.building!.trim().isNotEmpty &&
                _buildingNumberController.text.trim().isEmpty) {
              _buildingNumberController.text = autofill.building!.trim();
            }
            if (autofill.formattedAddress.isNotEmpty) {
              _searchController.text = autofill.formattedAddress;
            }
          });
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(autofill.latitude, autofill.longitude),
            ),
          );
          if (_openDetailsAfterAutofill) {
            _openDetailsAfterAutofill = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _showDetailsSheet(context);
            });
          }
        }
      },
      child: Semantics(
        label: locale.addresses_choose_location_title,
        child: Stack(
          children: [
            Positioned.fill(
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
                circles: {
                  Circle(
                    circleId: const CircleId('delivery_radius'),
                    center: LatLng(_currentLatitude, _currentLongitude),
                    radius: 200,
                    fillColor: color.primary.withValues(alpha: 0.12),
                    strokeColor: color.primary.withValues(alpha: 0.28),
                    strokeWidth: 1,
                  ),
                },
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: Spacing.bottomSheetRadius * 12,
              child: Center(child: IgnorePointer(child: AddressMapMarker())),
            ),
            if (_flowController.stage != AddressEntryStage.coveragePreview)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AddressChooseLocationSheet(
                  selectedMode: _selectedMode,
                  isSubmitting: widget.isSubmitting,
                  searchController: _searchController,
                  onSearchSubmitted: _onSearchSubmitted,
                  onSearchChanged: _onSearchChanged,
                  onModeChanged: (mode) {
                    setState(() => _selectedMode = mode);
                  },
                  onUseCurrentLocation: () => _onGpsPressed(context),
                  onConfirm: () => _prepareAndShowDetails(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onFlowStageChanged() {
    if (mounted) setState(() {});
  }

  void _onBuildingNumberChanged() {
    if (_buildingNumberHasError.value &&
        _buildingNumberController.text.trim().isNotEmpty) {
      _buildingNumberHasError.value = false;
    }
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
      CameraUpdate.newLatLng(LatLng(_currentLatitude, _currentLongitude)),
    );
    _triggerReverseGeocode(context);
  }

  void _onSearchSubmitted(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    context.read<AddressesViewModel>().doIntent(
      GeocodeAddressEvent(address: trimmed),
    );
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.length < 3) return;
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      context.read<AddressesViewModel>().doIntent(
        GeocodeAddressEvent(address: trimmed),
      );
    });
  }

  void _triggerReverseGeocode(BuildContext context, {bool force = false}) {
    if (_lastGeocodedLat != null && _lastGeocodedLng != null) {
      final latDiff = (_currentLatitude - _lastGeocodedLat!).abs();
      final lngDiff = (_currentLongitude - _lastGeocodedLng!).abs();
      if (!force && latDiff < 0.0001 && lngDiff < 0.0001) {
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

  void _prepareAndShowDetails(BuildContext context) {
    final state = context.read<AddressesViewModel>().state;
    if (state.mapAutofill.isLoading) return;
    if (state.mapAutofill.isSuccess &&
        state.mapAutofill.autofill != null &&
        state.locations.selectedGovernorate != null &&
        state.locations.selectedArea != null &&
        state.locations.selectedBlock != null) {
      _showDetailsSheet(context);
      return;
    }
    _openDetailsAfterAutofill = true;
    _triggerReverseGeocode(context, force: true);
  }

  Future<void> _showDetailsSheet(BuildContext context) async {
    final viewModel = context.read<AddressesViewModel>();
    _flowController.showAddressDetails();
    await AddressDetailsWoltSheet.show(
      context: context,
      isLoading: widget.isSubmitting,
      onConfirm: () {
        if (_submitAddress(context)) Navigator.of(context).pop();
      },
      content: LayoutBuilder(
        builder: (context, constraints) {
          return FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: Spacing.addressesHomeFormWidth,
              child: BlocProvider<AddressesViewModel>.value(
                value: viewModel,
                child: BlocBuilder<AddressesViewModel, AddressesState>(
                  buildWhen: (previous, current) =>
                      previous.locations != current.locations,
                  builder: (context, state) => HomeAddressFormCard(
                    governorates: state.locations.governorates,
                    areas: state.locations.areas,
                    blocks: state.locations.blocks,
                    selectedGovernorate: state.locations.selectedGovernorate,
                    selectedArea: state.locations.selectedArea,
                    selectedBlock: state.locations.selectedBlock,
                    streetController: _streetController,
                    avenueController: _avenueController,
                    floorController: _floorController,
                    buildingNumberController: _buildingNumberController,
                    buildingNumberErrorListenable: _buildingNumberHasError,
                    apartmentController: _apartmentController,
                    onGovernorateSelected: (governorate) => context
                        .read<AddressesViewModel>()
                        .doIntent(SelectAddressGovernorateEvent(governorate)),
                    onAreaSelected: (area) => context
                        .read<AddressesViewModel>()
                        .doIntent(SelectAddressAreaEvent(area)),
                    onBlockSelected: (block) => context
                        .read<AddressesViewModel>()
                        .doIntent(SelectAddressBlockEvent(block)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    if (mounted && _flowController.stage == AddressEntryStage.details) {
      _flowController.chooseLocation();
    }
  }

  bool _submitAddress(BuildContext context) {
    if (widget.isSubmitting) return false;

    final locale = context.localization;
    final languageCode = Localizations.localeOf(context).languageCode;
    final autofill = context
        .read<AddressesViewModel>()
        .state
        .mapAutofill
        .autofill;

    var area = widget.locations.selectedArea;
    var governorate = widget.locations.selectedGovernorate;
    var block = widget.locations.selectedBlock;

    if (area == null && autofill?.suggestedRegionId != null) {
      for (final g in widget.locations.governorates) {
        for (final a in g.areas) {
          if (a.id == autofill!.suggestedRegionId) {
            area = a;
            governorate = g;
            break;
          }
        }
        if (area != null) break;
      }
    }

    if (area == null && widget.locations.areas.isNotEmpty) {
      area = widget.locations.areas.first;
      governorate ??= widget.locations.governorates.firstOrNull;
    }

    final street = _streetController.text.trim().isNotEmpty
        ? _streetController.text.trim()
        : (autofill?.street?.trim() ?? '');
    final avenue = _avenueController.text.trim().isNotEmpty
        ? _avenueController.text.trim()
        : (autofill?.avenue?.trim() ?? '');
    final building = _buildingNumberController.text.trim();
    if (building.isEmpty) {
      _buildingNumberHasError.value = true;
      return false;
    }
    _buildingNumberHasError.value = false;
    final unit = _apartmentController.text.trim();
    final floor = _floorController.text.trim();

    final governorateName =
        governorate?.nameForLanguage(languageCode) ?? autofill?.governorate;
    final areaName = area?.nameForLanguage(languageCode) ?? autofill?.area;
    final blockName = block?.nameForLanguage(languageCode) ?? autofill?.block;
    final governorateCode =
        _regionCode(governorate?.code) ?? autofill?.governorate;
    final areaCode = _regionCode(area?.code) ?? autofill?.area;
    final blockCode = _regionCode(block?.code) ?? autofill?.block;
    final initialAddress = widget.initialAddress;

    final addressLine = _addressLine([
      governorateName,
      areaName,
      blockName,
      street,
      avenue,
      building,
    ]);

    final request = CustomerAddressRequestEntity(
      label: locale.addresses_current_home,
      addressLine: addressLine.isEmpty
          ? locale.addresses_choose_location_title
          : addressLine,
      regionId: area?.id ?? (autofill?.suggestedRegionId ?? 'default_region'),
      governorate: governorateCode,
      area: areaCode,
      block: blockCode,
      blockRegionId: block?.id,
      street: street.isEmpty ? null : street,
      avenue: avenue.isEmpty ? null : avenue,
      building: building,
      unit: unit.isEmpty ? null : unit,
      floor: floor.isEmpty ? null : floor,
      latitude: _currentLatitude,
      longitude: _currentLongitude,
      notes: avenue.isEmpty ? null : avenue,
      isDefault: initialAddress?.isDefault ?? true,
      notifyOnDelivery: initialAddress?.notifyOnDelivery ?? true,
    );

    if (initialAddress != null && initialAddress.addressId.isNotEmpty) {
      context.read<AddressesViewModel>().doIntent(
        PreviewUpdateAddressCoverageEvent(
          addressId: initialAddress.addressId,
          request: request,
        ),
      );
      return true;
    }

    context.read<AddressesViewModel>().doIntent(
      PreviewNewAddressCoverageEvent(request),
    );
    return true;
  }

  void _fillInitialAddress(CustomerAddressEntity? address) {
    if (address == null) return;

    _searchController.text = address.addressLine;
    _streetController.text = address.street ?? '';
    _avenueController.text = address.notes ?? '';
    _buildingNumberController.text = address.building ?? '';
    _floorController.text = address.floor ?? '';
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
