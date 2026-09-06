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
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_options_row.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_map_marker.dart';

class AddressesFigmaFrame extends StatefulWidget {
  const AddressesFigmaFrame({
    super.key,
    required this.locations,
    required this.isSubmitting,
    this.initialAddress,
  });

  static const double frameHeight = Spacing.addressesChooseLocationDesignHeight;

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
  AddressLocationMode _selectedMode = AddressLocationMode.currentLocation;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _avenueController = TextEditingController();
  final TextEditingController _buildingNumberController =
      TextEditingController();

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
    _searchController.dispose();
    _streetController.dispose();
    _avenueController.dispose();
    _buildingNumberController.dispose();
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
            if (autofill.formattedAddress.isNotEmpty) {
              _searchController.text = autofill.formattedAddress;
            }
          });
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(autofill.latitude, autofill.longitude),
            ),
          );
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
              child: Center(
                child: IgnorePointer(
                  child: AddressMapMarker(),
                ),
              ),
            ),
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
                onConfirm: () => _submitAddress(context),
              ),
            ),
          ],
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
    final autofill =
        context.read<AddressesViewModel>().state.mapAutofill.autofill;

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
    final building = _buildingNumberController.text.trim().isNotEmpty
        ? _buildingNumberController.text.trim()
        : (autofill?.building?.trim() ?? '');

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
      building: building.isEmpty ? null : building,
      unit: null,
      floor: null,
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
      return;
    }

    context.read<AddressesViewModel>().doIntent(
          PreviewNewAddressCoverageEvent(request),
        );
  }

  void _fillInitialAddress(CustomerAddressEntity? address) {
    if (address == null) return;

    _streetController.text = address.street ?? '';
    _avenueController.text = address.notes ?? '';
    _buildingNumberController.text = address.building ?? '';
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
