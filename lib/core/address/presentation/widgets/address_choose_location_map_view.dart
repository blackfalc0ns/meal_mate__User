import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/location_service.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_catalog_matcher.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_entry_flow_controller.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_event.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_state.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_view_model.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_choose_location_options_row.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_choose_location_sheet.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_details_wolt_sheet.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_map_marker.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/home_address_form_card.dart';

class AddressChooseLocationMapView extends StatefulWidget {
  const AddressChooseLocationMapView({
    super.key,
    required this.locations,
    required this.isSubmitting,
    this.initialAddress,
    this.showInitialAddressDetails = true,
    this.flowController,
    this.locationService,
    this.customActionText,
    this.customActionIcon,
    this.onCustomAction,
  });

  static const double frameHeight = Spacing.addressesChooseLocationDesignHeight;

  final LocationsCatalogState locations;
  final bool isSubmitting;
  final CustomerAddressEntity? initialAddress;
  final bool showInitialAddressDetails;
  final AddressEntryFlowController? flowController;
  final LocationService? locationService;
  final String? customActionText;
  final Widget? customActionIcon;
  final VoidCallback? onCustomAction;

  @override
  State<AddressChooseLocationMapView> createState() =>
      _AddressChooseLocationMapViewState();
}

class _AddressChooseLocationMapViewState
    extends State<AddressChooseLocationMapView> {
  static const double _defaultLatitude = 29.34;
  static const double _defaultLongitude = 48.08;

  late double _currentLatitude;
  late double _currentLongitude;
  double? _lastGeocodedLat;
  double? _lastGeocodedLng;
  GoogleMapController? _mapController;
  Timer? _mapDebounceTimer;
  Timer? _searchDebounceTimer;
  bool _isLocationModified = false;
  bool _isInitialMapMove = true;
  bool _isProgrammaticMove = false;
  bool _animateCameraToAutofill = false;
  bool _openDetailsAfterAutofill = false;
  final ValueNotifier<bool> _isLocationResolvingNotifier = ValueNotifier(false);
  late final Set<Factory<OneSequenceGestureRecognizer>> _gestureRecognizers = {
    const Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
  };
  final OverlayPortalController _loadingOverlayController =
      OverlayPortalController();
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

  LocationService get _locationService =>
      widget.locationService ??
      (getIt.isRegistered<LocationService>()
          ? getIt<LocationService>()
          : const LocationService());

  @override
  void initState() {
    super.initState();
    _currentLatitude = widget.initialAddress?.latitude ?? _defaultLatitude;
    _currentLongitude = widget.initialAddress?.longitude ?? _defaultLongitude;
    if (widget.initialAddress != null) {
      _lastGeocodedLat = _currentLatitude;
      _lastGeocodedLng = _currentLongitude;
    }
    _ownsFlowController = widget.flowController == null;
    _flowController = widget.flowController ?? AddressEntryFlowController();
    _isLocationModified = widget.initialAddress == null;
    if (widget.initialAddress != null && widget.showInitialAddressDetails) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_showDetailsSheet(context));
      });
    }
    _flowController.addListener(_onFlowStageChanged);
    _buildingNumberController.addListener(_onBuildingNumberChanged);
    _fillInitialAddress(widget.initialAddress);
  }

  @override
  void didUpdateWidget(covariant AddressChooseLocationMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialAddress != widget.initialAddress) {
      _isLocationModified = widget.initialAddress == null;
      _currentLatitude = widget.initialAddress?.latitude ?? _defaultLatitude;
      _currentLongitude = widget.initialAddress?.longitude ?? _defaultLongitude;
      _lastGeocodedLat = widget.initialAddress?.latitude;
      _lastGeocodedLng = widget.initialAddress?.longitude;
      _fillInitialAddress(widget.initialAddress);
    }
  }

  @override
  void dispose() {
    _mapDebounceTimer?.cancel();
    _searchDebounceTimer?.cancel();
    _mapController?.dispose();
    _searchController.dispose();
    _streetController.dispose();
    _avenueController.dispose();
    _buildingNumberController.removeListener(_onBuildingNumberChanged);
    _buildingNumberController.dispose();
    _buildingNumberHasError.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _isLocationResolvingNotifier.dispose();
    _flowController.removeListener(_onFlowStageChanged);
    if (_ownsFlowController) _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocListener<AddressEditorViewModel, AddressEditorState>(
      listenWhen: (previous, current) =>
          previous.mapAutofill != current.mapAutofill,
      listener: (context, state) {
        if (_isLocationResolvingNotifier.value &&
            !state.mapAutofill.isLoading) {
          if (mounted) {
            _setLocationResolving(false);
          }
        }
        if (state.mapAutofill.displayErrorMessage != null &&
            state.mapAutofill.displayErrorMessage!.isNotEmpty) {
          _openDetailsAfterAutofill = false;
          CustomSnackbar.showError(
            context: context,
            message: state.mapAutofill.displayErrorMessage!,
          );
        }
        if (state.mapAutofill.isSuccess && state.mapAutofill.autofill != null) {
          final autofill = state.mapAutofill.autofill!;
          final shouldAnimate = _animateCameraToAutofill;
          _animateCameraToAutofill = false;
          if (shouldAnimate) {
            _currentLatitude = autofill.latitude;
            _currentLongitude = autofill.longitude;
          }
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
          if (shouldAnimate) {
            _isProgrammaticMove = true;
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(autofill.latitude, autofill.longitude),
              ),
            );
          }
          if (_openDetailsAfterAutofill) {
            _openDetailsAfterAutofill = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _showDetailsSheet(context);
            });
          }
        }
      },
      child: OverlayPortal(
        controller: _loadingOverlayController,
        overlayChildBuilder: (context) => const Positioned.fill(
          child: IgnorePointer(child: CustomProgressIndicator()),
        ),
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
                  gestureRecognizers: _gestureRecognizers,
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: Spacing.bottomSheetRadius * 12,
                child: Center(child: IgnorePointer(child: AddressMapMarker())),
              ),
              if (_flowController.stage != AddressEntryStage.coveragePreview) ...[
                Builder(
                  builder: (context) {
                    final hasCustomAction = !_isLocationModified &&
                        widget.customActionText != null &&
                        widget.onCustomAction != null;

                    return Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AddressChooseLocationSheet(
                        selectedMode: _selectedMode,
                        isSubmitting: widget.isSubmitting,
                        searchController: _searchController,
                        onSearchSubmitted: _onSearchSubmitted,
                        onSearchChanged: _onSearchChanged,
                        confirmButtonText: hasCustomAction
                            ? widget.customActionText
                            : null,
                        confirmButtonIcon: hasCustomAction
                            ? (widget.customActionIcon ??
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: Spacing.iconXs,
                                ))
                            : null,
                        onModeChanged: (mode) {
                          setState(() {
                            _selectedMode = mode;
                            if (widget.initialAddress != null) {
                              _isLocationModified = true;
                            }
                          });
                          if (mode == AddressLocationMode.fromMap) {
                            final sent = _triggerReverseGeocode(
                              context,
                              force: true,
                            );
                            if (sent && mounted) {
                              _setLocationResolving(true);
                            }
                          }
                        },
                        onUseCurrentLocation: _onGpsPressed,
                        onConfirm: hasCustomAction
                            ? widget.onCustomAction
                            : () => _prepareAndShowDetails(context),
                      ),
                    );
                  },
                ),
              ],
              ValueListenableBuilder<bool>(
                valueListenable: _isLocationResolvingNotifier,
                builder: (context, isResolving, _) {
                  if (!isResolving) return const SizedBox.shrink();
                  return Positioned.fill(
                    child: AbsorbPointer(
                      child: ColoredBox(
                        color: color.scrim.withValues(alpha: 0.2),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setLocationResolving(bool value) {
    if (_isLocationResolvingNotifier.value == value) return;
    _isLocationResolvingNotifier.value = value;
    if (value) {
      _loadingOverlayController.show();
    } else {
      _loadingOverlayController.hide();
    }
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
    final initialLat = widget.initialAddress?.latitude;
    final initialLng = widget.initialAddress?.longitude;
    if (!_isProgrammaticMove && initialLat != null && initialLng != null) {
      final latDiff = (_currentLatitude - initialLat).abs();
      final lngDiff = (_currentLongitude - initialLng).abs();
      final isModified = latDiff > 0.0003 || lngDiff > 0.0003;
      if (_isLocationModified != isModified) {
        setState(() => _isLocationModified = isModified);
      }
    }
  }

  void _onCameraIdle() {
    if (_isInitialMapMove) {
      _isInitialMapMove = false;
      return;
    }
    if (_isProgrammaticMove) {
      _isProgrammaticMove = false;
      return;
    }
    _mapDebounceTimer?.cancel();
    _mapDebounceTimer = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _triggerReverseGeocode(context);
    });
  }

  Future<void> _onGpsPressed() async {
    if (!_isLocationModified) {
      setState(() => _isLocationModified = true);
    }
    _setLocationResolving(true);
    final result = await _locationService.getCurrentLocation();
    if (!mounted) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        _currentLatitude = data.latitude;
        _currentLongitude = data.longitude;
        _isProgrammaticMove = true;

        await _mapController?.animateCamera(
          CameraUpdate.newLatLng(LatLng(data.latitude, data.longitude)),
        );

        if (!mounted) return;

        final sent = _triggerReverseGeocode(context, force: true);
        if (!sent && mounted) {
          _setLocationResolving(false);
        }

      case ApiErrorResult(:final failure):
        _setLocationResolving(false);
        CustomSnackbar.showError(
          context: context,
          message: failure.code.isNotEmpty
              ? failure.code
              : failure.errorMessage,
        );
    }
  }

  void _onSearchSubmitted(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    _executeSearch(trimmed);
  }

  void _onSearchChanged(String query) {
    _searchDebounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.length < 3) return;
    _searchDebounceTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _executeSearch(trimmed);
    });
  }

  void _executeSearch(String query) {
    if (!_isLocationModified) {
      setState(() => _isLocationModified = true);
    }
    _animateCameraToAutofill = true;
    if (mounted) _setLocationResolving(true);
    context.read<AddressEditorViewModel>().doIntent(
      GeocodeAddressEvent(address: query),
    );
  }

  bool _triggerReverseGeocode(BuildContext context, {bool force = false}) {
    if (_lastGeocodedLat != null && _lastGeocodedLng != null) {
      final latDiff = (_currentLatitude - _lastGeocodedLat!).abs();
      final lngDiff = (_currentLongitude - _lastGeocodedLng!).abs();
      if (!force && latDiff < 0.0001 && lngDiff < 0.0001) {
        return false;
      }
    }
    _lastGeocodedLat = _currentLatitude;
    _lastGeocodedLng = _currentLongitude;

    context.read<AddressEditorViewModel>().doIntent(
      ReverseGeocodeEvent(
        latitude: _currentLatitude,
        longitude: _currentLongitude,
        force: force,
      ),
    );
    return true;
  }

  void _prepareAndShowDetails(BuildContext context) {
    final state = context.read<AddressEditorViewModel>().state;
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
    final sent = _triggerReverseGeocode(context, force: true);
    if (sent && mounted) {
      _setLocationResolving(true);
    }
  }

  Future<void> _showDetailsSheet(BuildContext context) async {
    final viewModel = context.read<AddressEditorViewModel>();
    _flowController.showAddressDetails();
    await AddressDetailsWoltSheet.show(
      context: context,
      isLoading: widget.isSubmitting,
      onConfirm: () {
        if (_submitAddress(context)) Navigator.of(context).pop();
      },
      content: BlocProvider<AddressEditorViewModel>.value(
        value: viewModel,
        child: BlocBuilder<AddressEditorViewModel, AddressEditorState>(
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
                .read<AddressEditorViewModel>()
                .doIntent(SelectAddressGovernorateEvent(governorate)),
            onAreaSelected: (area) => context
                .read<AddressEditorViewModel>()
                .doIntent(SelectAddressAreaEvent(area)),
            onBlockSelected: (block) => context
                .read<AddressEditorViewModel>()
                .doIntent(SelectAddressBlockEvent(block)),
          ),
        ),
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
    final viewModelState = context.read<AddressEditorViewModel>().state;
    final autofill = viewModelState.mapAutofill.autofill;
    final locationsState = viewModelState.locations;

    var area = locationsState.selectedArea;
    var governorate = locationsState.selectedGovernorate;
    final block = locationsState.selectedBlock;

    // Use AddressCatalogMatcher if area wasn't pre-selected
    if (area == null && locationsState.data != null && autofill != null) {
      final matched = AddressCatalogMatcher.findInitialSelection(
        locationsState.data!,
        null,
        autofill: autofill,
      );
      if (matched.area != null) {
        area = matched.area;
        governorate = matched.governorate;
      }
    }

    if (area == null && locationsState.areas.isNotEmpty) {
      area = locationsState.areas.first;
      governorate ??= locationsState.governorates.firstOrNull;
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
        governorate?.code.trim().nullIfEmpty ?? autofill?.governorate;
    final areaCode = area?.code.trim().nullIfEmpty ?? autofill?.area;
    final blockCode = block?.code.trim().nullIfEmpty ?? autofill?.block;
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
      context.read<AddressEditorViewModel>().doIntent(
        PreviewUpdateAddressCoverageEvent(
          addressId: initialAddress.addressId,
          request: request,
        ),
      );
      return true;
    }

    context.read<AddressEditorViewModel>().doIntent(
      PreviewNewAddressCoverageEvent(request),
    );
    return true;
  }

  void _fillInitialAddress(CustomerAddressEntity? address) {
    if (address == null) return;

    _searchController.text = address.addressLine;
    _streetController.text = address.street ?? '';
    _avenueController.text = address.avenue?.trim().isNotEmpty == true
        ? address.avenue!.trim()
        : (address.notes ?? '');
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
}

extension on String {
  String? get nullIfEmpty => trim().isEmpty ? null : trim();
}
