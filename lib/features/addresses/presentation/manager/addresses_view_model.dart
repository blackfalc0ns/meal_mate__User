import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/add_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/confirm_set_default_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/delete_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/geocode_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_existing_address_coverage_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_new_address_coverage_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/reverse_geocode_location_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/update_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_addresses_usecases.dart';

@injectable
class AddressesViewModel extends Cubit<AddressesState> {
  AddressesViewModel(
    this._getCustomerAddressesUseCase,
    this._getLocationsCatalogUseCase,
    this._addCustomerAddressUseCase,
    this._updateCustomerAddressUseCase,
    this._deleteCustomerAddressUseCase,
    this._geocodeAddressUseCase,
    this._reverseGeocodeLocationUseCase,
    this._previewNewAddressCoverageUseCase,
    this._previewExistingAddressCoverageUseCase,
    this._confirmSetDefaultAddressUseCase,
  ) : super(const AddressesState());

  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;
  final GetLocationsCatalogUseCase _getLocationsCatalogUseCase;
  final AddCustomerAddressUseCase _addCustomerAddressUseCase;
  final UpdateCustomerAddressUseCase _updateCustomerAddressUseCase;
  final DeleteCustomerAddressUseCase _deleteCustomerAddressUseCase;
  final GeocodeAddressUseCase _geocodeAddressUseCase;
  final ReverseGeocodeLocationUseCase _reverseGeocodeLocationUseCase;
  final PreviewNewAddressCoverageUseCase _previewNewAddressCoverageUseCase;
  final PreviewExistingAddressCoverageUseCase
  _previewExistingAddressCoverageUseCase;
  final ConfirmSetDefaultAddressUseCase _confirmSetDefaultAddressUseCase;
  PreviewFamilyMemberAddressUseCase? _previewFamilyMemberAddressUseCase;
  AddFamilyMemberAddressUseCase? _addFamilyMemberAddressUseCase;
  String? _familyMemberId;
  int _familyMemberGeneration = 0;
  double? _lastReverseGeocodeLatitude;
  double? _lastReverseGeocodeLongitude;
  MapAddressAutofillEntity? _lastReverseGeocodeResult;

  void configureFamilyMember(
    String memberId, {
    required PreviewFamilyMemberAddressUseCase previewAddress,
    required AddFamilyMemberAddressUseCase addAddress,
  }) {
    final memberChanged =
        _familyMemberId != null && _familyMemberId != memberId;
    if (memberChanged) {
      _familyMemberGeneration++;
      _clearReverseGeocodeCache();
      emit(
        state.copyWith(
          locations: state.locations.copyWith(
            clearSelectedGovernorate: true,
            clearSelectedArea: true,
            clearSelectedBlock: true,
            clearFailure: true,
          ),
          action: const AddressesActionState(),
          mapAutofill: const MapAutofillState(),
          coveragePreview: const AddressCoveragePreviewState(),
        ),
      );
    }
    _familyMemberId = memberId;
    _previewFamilyMemberAddressUseCase = previewAddress;
    _addFamilyMemberAddressUseCase = addAddress;
  }

  void invalidateFamilyMemberOperations() {
    _familyMemberGeneration++;
    _clearReverseGeocodeCache();
  }

  void _clearReverseGeocodeCache() {
    _lastReverseGeocodeLatitude = null;
    _lastReverseGeocodeLongitude = null;
    _lastReverseGeocodeResult = null;
  }

  static bool isWithinKuwaitBounds(double? lat, double? lng) {
    if (lat == null || lng == null) return false;
    return lat >= 28.5 && lat <= 30.2 && lng >= 46.5 && lng <= 48.5;
  }

  void doIntent(AddressesEvent event) {
    switch (event) {
      case GetCustomerAddressesEvent():
        _getCustomerAddresses();
      case GetLocationsCatalogEvent():
        _getLocationsCatalog(event.countryCode, event.initialAddress);
      case SelectAddressGovernorateEvent():
        _selectGovernorate(event.governorate);
      case SelectAddressAreaEvent():
        _selectArea(event.area);
      case SelectAddressBlockEvent():
        _selectBlock(event.block);
      case AddCustomerAddressEvent():
        _addCustomerAddress(event.request);
      case UpdateCustomerAddressEvent():
        _updateCustomerAddress(event.addressId, event.request);
      case DeleteCustomerAddressEvent():
        _deleteCustomerAddress(event.addressId);
      case ReverseGeocodeEvent():
        _reverseGeocode(event.latitude, event.longitude, force: event.force);
      case GeocodeAddressEvent():
        _geocodeAddress(event.address, event.countryCode);
      case PreviewNewAddressCoverageEvent():
        _previewNewAddressCoverage(event.request);
      case PreviewUpdateAddressCoverageEvent():
        _previewUpdateAddressCoverage(event.addressId, event.request);
      case PreviewExistingAddressCoverageEvent():
        _previewExistingAddressCoverage(event.addressId);
      case ConfirmSetDefaultAddressEvent():
        _confirmSetDefaultAddress(event.addressId);
      case ConfirmPendingAddressActionEvent():
        _confirmPendingAddressAction();
      case ClearCoveragePreviewEvent():
        _clearCoveragePreview();
    }
  }

  Future<void> _getCustomerAddresses() async {
    if (isClosed) return;

    emit(
      state.copyWith(
        addresses: state.addresses.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _getCustomerAddressesUseCase();
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            addresses: state.addresses.copyWith(
              isLoading: false,
              isSuccess: true,
              items: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            addresses: state.addresses.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getLocationsCatalog(
    String countryCode,
    CustomerAddressEntity? initialAddress,
  ) async {
    final loadedCountryCode = state.locations.data?.countryCode;
    final loadedData = state.locations.data;
    if (state.locations.isLoading) return;

    if (loadedData != null && loadedCountryCode == countryCode) {
      final initialSelection = _findInitialSelection(
        loadedData,
        initialAddress,
      );
      final initialArea = initialSelection.area;
      final selectedAreaWithBlocks = initialArea == null
          ? null
          : (initialArea.blocks.isNotEmpty
              ? initialArea
              : await _loadAreaBlocks(countryCode, initialArea.id));
      final selectedArea = selectedAreaWithBlocks ?? initialArea;
      final selectedBlock = selectedArea == null
          ? null
          : _findInitialBlock(selectedArea, initialAddress);

      emit(
        state.copyWith(
          locations: state.locations.copyWith(
            isLoading: false,
            isSuccess: true,
            selectedGovernorate: initialSelection.governorate,
            selectedArea: selectedArea,
            selectedBlock: selectedBlock,
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        locations: state.locations.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _getLocationsCatalogUseCase(countryCode);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final initialSelection = _findInitialSelection(
          result.data,
          initialAddress,
        );
        final initialArea = initialSelection.area;
        final selectedAreaWithBlocks = initialArea == null
            ? null
            : await _loadAreaBlocks(countryCode, initialArea.id);
        final selectedArea = selectedAreaWithBlocks ?? initialArea;
        final selectedBlock = selectedArea == null
            ? null
            : _findInitialBlock(selectedArea, initialAddress);

        emit(
          state.copyWith(
            locations: state.locations.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
              selectedGovernorate: initialSelection.governorate,
              selectedArea: selectedArea,
              selectedBlock: selectedBlock,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            locations: state.locations.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  void _selectGovernorate(LocationGovernorateEntity governorate) {
    emit(
      state.copyWith(
        locations: state.locations.copyWith(
          selectedGovernorate: governorate,
          clearSelectedArea: true,
          clearSelectedBlock: true,
        ),
      ),
    );
  }

  Future<void> _selectArea(LocationAreaEntity area) async {
    final memberGeneration = _familyMemberGeneration;
    emit(
      state.copyWith(
        locations: state.locations.copyWith(
          selectedArea: area,
          clearSelectedBlock: true,
          clearFailure: true,
        ),
      ),
    );

    final countryCode = state.locations.data?.countryCode.isNotEmpty == true
        ? state.locations.data!.countryCode
        : 'KW';
    final result = await _getLocationsCatalogUseCase(
      countryCode,
      areaId: area.id,
    );
    if (isClosed || memberGeneration != _familyMemberGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final selectedAreaWithBlocks = _findAreaById(result.data, area.id);
        emit(
          state.copyWith(
            locations: state.locations.copyWith(
              selectedArea: selectedAreaWithBlocks ?? area,
              clearSelectedBlock: true,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            locations: state.locations.copyWith(failure: result.failure),
          ),
        );
    }
  }

  void _selectBlock(LocationBlockEntity block) {
    emit(
      state.copyWith(locations: state.locations.copyWith(selectedBlock: block)),
    );
  }

  LocationAreaEntity? _findAreaById(
    LocationsCatalogEntity locations,
    String areaId,
  ) {
    for (final governorate in locations.governorates) {
      for (final area in governorate.areas) {
        if (area.id == areaId) return area;
      }
    }
    return null;
  }

  Future<LocationAreaEntity?> _loadAreaBlocks(
    String countryCode,
    String areaId,
  ) async {
    final result = await _getLocationsCatalogUseCase(
      countryCode,
      areaId: areaId,
    );

    switch (result) {
      case ApiSuccessResult():
        return _findAreaById(result.data, areaId);
      case ApiErrorResult():
        return null;
    }
  }

  _InitialLocationSelection _findInitialSelection(
    LocationsCatalogEntity locations,
    CustomerAddressEntity? address, {
    MapAddressAutofillEntity? autofill,
  }) {
    if (address == null && autofill == null) {
      return const _InitialLocationSelection();
    }

    for (final governorate in locations.governorates) {
      for (final area in governorate.areas) {
        if (_matchesArea(area, address, autofill: autofill)) {
          return _InitialLocationSelection(
            governorate: governorate,
            area: area,
          );
        }
      }
    }

    return const _InitialLocationSelection();
  }

  bool _matchesArea(
    LocationAreaEntity area,
    CustomerAddressEntity? address, {
    MapAddressAutofillEntity? autofill,
  }) {
    if (autofill != null) {
      if (_matchesValue(area.id, autofill.suggestedRegionId)) return true;
      if (_matchesValue(area.nameAr, autofill.suggestedRegionNameAr)) {
        return true;
      }
      if (_matchesValue(area.nameEn, autofill.suggestedRegionName)) return true;
      if (_matchesValue(area.nameAr, autofill.area)) return true;
      if (_matchesValue(area.nameEn, autofill.area)) return true;
    }
    if (address == null) return false;
    return _matchesValue(area.id, address.regionId) ||
        _matchesValue(area.code, address.area) ||
        _matchesValue(area.nameAr, address.area) ||
        _matchesValue(area.nameEn, address.area);
  }

  LocationBlockEntity? _findInitialBlock(
    LocationAreaEntity area,
    CustomerAddressEntity? address, {
    MapAddressAutofillEntity? autofill,
  }) {
    if (address == null && autofill == null) return null;

    for (final block in area.blocks) {
      if (autofill != null) {
        if (_matchesValue(block.id, autofill.suggestedBlockId)) return block;
        if (_matchesValue(block.nameAr, autofill.suggestedBlockNameAr)) {
          return block;
        }
        if (_matchesValue(block.nameEn, autofill.suggestedBlockName)) {
          return block;
        }
        if (_matchesValue(block.nameAr, autofill.block)) return block;
        if (_matchesValue(block.nameEn, autofill.block)) return block;
      }
      if (address != null &&
          (_matchesValue(block.id, address.blockRegionId) ||
              _matchesValue(block.code, address.block) ||
              _matchesValue(block.nameAr, address.block) ||
              _matchesValue(block.nameEn, address.block))) {
        return block;
      }
    }
    return null;
  }

  bool _matchesValue(String? first, String? second) {
    final normalizedFirst = _normalize(first);
    final normalizedSecond = _normalize(second);
    return normalizedFirst.isNotEmpty && normalizedFirst == normalizedSecond;
  }

  String _normalize(String? value) {
    return value?.trim().toLowerCase() ?? '';
  }

  Future<void> _reverseGeocode(
    double latitude,
    double longitude, {
    bool force = false,
  }) async {
    final lastLatitude = _lastReverseGeocodeLatitude;
    final lastLongitude = _lastReverseGeocodeLongitude;
    if (!force &&
        lastLatitude != null &&
        lastLongitude != null &&
        (latitude - lastLatitude).abs() < 0.00001 &&
        (longitude - lastLongitude).abs() < 0.00001) {
      final cached = _lastReverseGeocodeResult;
      if (cached != null && !state.mapAutofill.isSuccess) {
        emit(
          state.copyWith(
            mapAutofill: state.mapAutofill.copyWith(
              isLoading: false,
              isSuccess: true,
              autofill: cached,
              clearFailure: true,
            ),
          ),
        );
      }
      return;
    }
    _lastReverseGeocodeLatitude = latitude;
    _lastReverseGeocodeLongitude = longitude;
    final memberGeneration = _familyMemberGeneration;
    if (isClosed) return;

    emit(
      state.copyWith(
        mapAutofill: state.mapAutofill.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _reverseGeocodeLocationUseCase(latitude, longitude);
    if (isClosed || memberGeneration != _familyMemberGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final autofill = result.data;
        _lastReverseGeocodeResult = autofill;
        await _applyAutofillToCatalog(
          autofill,
          memberGeneration: memberGeneration,
        );
        if (!isClosed && memberGeneration == _familyMemberGeneration) {
          emit(
            state.copyWith(
              mapAutofill: state.mapAutofill.copyWith(
                isLoading: false,
                isSuccess: true,
                autofill: autofill,
              ),
            ),
          );
        }
      case ApiErrorResult():
        _lastReverseGeocodeLatitude = null;
        _lastReverseGeocodeLongitude = null;
        emit(
          state.copyWith(
            mapAutofill: state.mapAutofill.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _geocodeAddress(String address, String countryCode) async {
    final memberGeneration = _familyMemberGeneration;
    if (isClosed) return;

    emit(
      state.copyWith(
        mapAutofill: state.mapAutofill.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _geocodeAddressUseCase(
      address,
      countryCode: countryCode,
    );
    if (isClosed || memberGeneration != _familyMemberGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final autofill = result.data;
        await _applyAutofillToCatalog(
          autofill,
          memberGeneration: memberGeneration,
        );
        if (!isClosed && memberGeneration == _familyMemberGeneration) {
          emit(
            state.copyWith(
              mapAutofill: state.mapAutofill.copyWith(
                isLoading: false,
                isSuccess: true,
                autofill: autofill,
              ),
            ),
          );
        }
      case ApiErrorResult():
        emit(
          state.copyWith(
            mapAutofill: state.mapAutofill.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _applyAutofillToCatalog(
    MapAddressAutofillEntity autofill, {
    required int memberGeneration,
  }) async {
    if (memberGeneration != _familyMemberGeneration) return;
    final catalog = state.locations.data;
    if (catalog == null) return;

    final tempAddress = CustomerAddressEntity(
      addressId: '',
      label: '',
      addressLine: autofill.formattedAddress,
      regionId: autofill.suggestedRegionId,
      blockRegionId: autofill.suggestedBlockId,
      governorate: autofill.suggestedGovernorateName ?? autofill.governorate,
      area: autofill.suggestedRegionName ?? autofill.area,
      block: autofill.suggestedBlockName ?? autofill.block,
      street: autofill.street,
      notes: autofill.avenue,
      building: autofill.building,
      latitude: autofill.latitude,
      longitude: autofill.longitude,
      isDefault: false,
      isDeliveryActive: false,
      notifyOnDelivery: false,
    );

    final selection = _findInitialSelection(
      catalog,
      tempAddress,
      autofill: autofill,
    );
    if (selection.governorate == null && selection.area == null) return;

    final countryCode = catalog.countryCode.isNotEmpty
        ? catalog.countryCode
        : 'KW';
    final currentArea = state.locations.selectedArea;
    final areaWithBlocks =
        (currentArea != null &&
            currentArea.id == selection.area?.id &&
            currentArea.blocks.isNotEmpty)
        ? currentArea
        : (selection.area != null
              ? await _loadAreaBlocks(countryCode, selection.area!.id)
              : null);

    final selectedArea = areaWithBlocks ?? selection.area;
    final selectedBlock = selectedArea != null
        ? _findInitialBlock(selectedArea, tempAddress, autofill: autofill)
        : null;

    if (!isClosed && memberGeneration == _familyMemberGeneration) {
      emit(
        state.copyWith(
          locations: state.locations.copyWith(
            selectedGovernorate: selection.governorate,
            selectedArea: selectedArea,
            selectedBlock: selectedBlock,
          ),
        ),
      );
    }
  }

  Future<void> _addCustomerAddress(CustomerAddressRequestEntity request) async {
    if (!isWithinKuwaitBounds(request.latitude, request.longitude)) {
      emit(
        state.copyWith(
          action: state.action.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: 'address.out_of_kuwait_bounds',
            failure: Failure(
              errorMessage:
                  'Coordinates must be within Kuwait bounds (28.5–30.2, 46.5–48.5)',
              code: 'address.out_of_kuwait_bounds',
            ),
          ),
        ),
      );
      return;
    }

    final familyMemberId = _familyMemberId;
    await _runAddressAction(
      () => familyMemberId == null
          ? _addCustomerAddressUseCase(request)
          : _addFamilyMemberAddressUseCase!(familyMemberId, request),
    );
    if (!isClosed && state.action.isSuccess && familyMemberId == null) {
      await _getCustomerAddresses();
    }
  }

  Future<void> _updateCustomerAddress(
    String addressId,
    CustomerAddressRequestEntity request,
  ) async {
    if (!isWithinKuwaitBounds(request.latitude, request.longitude)) {
      emit(
        state.copyWith(
          action: state.action.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: 'address.out_of_kuwait_bounds',
            failure: Failure(
              errorMessage:
                  'Coordinates must be within Kuwait bounds (28.5–30.2, 46.5–48.5)',
              code: 'address.out_of_kuwait_bounds',
            ),
          ),
        ),
      );
      return;
    }

    await _runAddressAction(
      () => _updateCustomerAddressUseCase(addressId, request),
    );
    if (!isClosed && state.action.isSuccess) {
      await _getCustomerAddresses();
    }
  }

  Future<void> _deleteCustomerAddress(String addressId) async {
    await _runVoidAction(() => _deleteCustomerAddressUseCase(addressId));
    if (!isClosed && state.action.isSuccess) {
      await _getCustomerAddresses();
    }
  }

  Future<void> _runAddressAction(
    Future<ApiResult<CustomerAddressEntity>> Function() action,
  ) async {
    final memberGeneration = _familyMemberGeneration;
    emit(
      state.copyWith(
        action: state.action.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearAddress: true,
        ),
      ),
    );

    final result = await action();
    if (isClosed || memberGeneration != _familyMemberGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            action: state.action.copyWith(
              isLoading: false,
              isSuccess: true,
              address: result.data,
              deliveryChangeNotice: result.data.deliveryChangeNotice,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            action: state.action.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _runVoidAction(Future<ApiResult<void>> Function() action) async {
    emit(
      state.copyWith(
        action: state.action.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearAddress: true,
        ),
      ),
    );

    final result = await action();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            action: state.action.copyWith(isLoading: false, isSuccess: true),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            action: state.action.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.code,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _previewNewAddressCoverage(
    CustomerAddressRequestEntity request,
  ) async {
    final memberGeneration = _familyMemberGeneration;
    if (!isWithinKuwaitBounds(request.latitude, request.longitude)) {
      emit(
        state.copyWith(
          coveragePreview: state.coveragePreview.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: Failure(
              errorMessage:
                  'Coordinates must be within Kuwait bounds (28.5–30.2, 46.5–48.5)',
              code: 'address.out_of_kuwait_bounds',
            ),
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        coveragePreview: state.coveragePreview.copyWith(
          isLoading: true,
          isSuccess: false,
          clearPreview: true,
          clearFailure: true,
          pendingAction: AddressPendingActionType.add,
          pendingRequest: request,
        ),
      ),
    );

    final familyMemberId = _familyMemberId;
    final result = familyMemberId == null
        ? await _previewNewAddressCoverageUseCase(request)
        : await _previewFamilyMemberAddressUseCase!(familyMemberId, request);
    if (isClosed || memberGeneration != _familyMemberGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoading: false,
              isSuccess: true,
              preview: result.data,
              pendingAction: AddressPendingActionType.add,
              pendingRequest: request,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _previewUpdateAddressCoverage(
    String addressId,
    CustomerAddressRequestEntity request,
  ) async {
    if (!isWithinKuwaitBounds(request.latitude, request.longitude)) {
      emit(
        state.copyWith(
          coveragePreview: state.coveragePreview.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: Failure(
              errorMessage:
                  'Coordinates must be within Kuwait bounds (28.5–30.2, 46.5–48.5)',
              code: 'address.out_of_kuwait_bounds',
            ),
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        coveragePreview: state.coveragePreview.copyWith(
          isLoading: true,
          isSuccess: false,
          clearPreview: true,
          clearFailure: true,
          pendingAction: AddressPendingActionType.update,
          targetAddressId: addressId,
          pendingRequest: request,
        ),
      ),
    );

    final result = await _previewNewAddressCoverageUseCase(request);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoading: false,
              isSuccess: true,
              preview: result.data,
              pendingAction: AddressPendingActionType.update,
              targetAddressId: addressId,
              pendingRequest: request,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _previewExistingAddressCoverage(String addressId) async {
    emit(
      state.copyWith(
        coveragePreview: state.coveragePreview.copyWith(
          isLoading: true,
          isSuccess: false,
          clearPreview: true,
          clearFailure: true,
          pendingAction: AddressPendingActionType.setDefault,
          targetAddressId: addressId,
        ),
      ),
    );

    final result = await _previewExistingAddressCoverageUseCase(addressId);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoading: false,
              isSuccess: true,
              preview: result.data,
              pendingAction: AddressPendingActionType.setDefault,
              targetAddressId: addressId,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _confirmSetDefaultAddress(String addressId) async {
    await _runAddressAction(() => _confirmSetDefaultAddressUseCase(addressId));
    if (!isClosed && state.action.isSuccess) {
      await _getCustomerAddresses();
    }
  }

  Future<void> _confirmPendingAddressAction() async {
    final pendingAction = state.coveragePreview.pendingAction;
    final pendingRequest = state.coveragePreview.pendingRequest;
    final targetId = state.coveragePreview.targetAddressId;

    if (pendingAction == null) return;

    emit(state.copyWith(coveragePreview: const AddressCoveragePreviewState()));

    switch (pendingAction) {
      case AddressPendingActionType.add:
        if (pendingRequest != null) {
          await _addCustomerAddress(pendingRequest);
        }
      case AddressPendingActionType.update:
        if (targetId != null && pendingRequest != null) {
          await _updateCustomerAddress(targetId, pendingRequest);
        }
      case AddressPendingActionType.setDefault:
        if (targetId != null) {
          await _confirmSetDefaultAddress(targetId);
        }
    }
  }

  void _clearCoveragePreview() {
    emit(state.copyWith(coveragePreview: const AddressCoveragePreviewState()));
  }
}

class _InitialLocationSelection {
  const _InitialLocationSelection({this.governorate, this.area});

  final LocationGovernorateEntity? governorate;
  final LocationAreaEntity? area;
}
