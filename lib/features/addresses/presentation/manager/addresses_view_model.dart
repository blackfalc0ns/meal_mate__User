import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/constants/app_constants.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
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
import 'package:meal_meat_user/features/addresses/presentation/manager/address_catalog_matcher.dart';
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
  final Map<String, LocationAreaEntity> _areaBlocksCache = {};
  int _geocodeRequestId = 0;
  int _coverageSessionId = 0;

  void configureFamilyMember(
    String memberId, {
    required PreviewFamilyMemberAddressUseCase previewAddress,
    required AddFamilyMemberAddressUseCase addAddress,
  }) {
    final memberChanged =
        _familyMemberId != null && _familyMemberId != memberId;
    if (memberChanged) {
      _coverageSessionId++;
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
          coveragePreview: AddressCoveragePreviewState(
            sessionId: _coverageSessionId,
          ),
        ),
      );
    }
    _familyMemberId = memberId;
    _previewFamilyMemberAddressUseCase = previewAddress;
    _addFamilyMemberAddressUseCase = addAddress;
  }

  void invalidateFamilyMemberOperations() {
    _familyMemberGeneration++;
    _coverageSessionId++;
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

  Future<void> doIntent(AddressesEvent event) async {
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
        await _deleteCustomerAddress(event.addressId);
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
      case LoadMoreAddressCoverageRestaurantsEvent():
        _loadMoreAddressCoverageRestaurants();
      case RetryAddressCoveragePreviewEvent():
        _retryAddressCoveragePreview();
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
      final initialSelection = AddressCatalogMatcher.findInitialSelection(
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
          : AddressCatalogMatcher.findInitialBlock(
              selectedArea,
              initialAddress,
            );

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
        final initialSelection = AddressCatalogMatcher.findInitialSelection(
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
            : AddressCatalogMatcher.findInitialBlock(
                selectedArea,
                initialAddress,
              );

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

    // Use memory cache first if blocks are already loaded
    final cachedArea = _areaBlocksCache[area.id];
    if (cachedArea != null && cachedArea.blocks.isNotEmpty) {
      emit(
        state.copyWith(
          locations: state.locations.copyWith(
            selectedArea: cachedArea,
            clearSelectedBlock: true,
          ),
        ),
      );
      return;
    }

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
        final selectedAreaWithBlocks = AddressCatalogMatcher.findAreaById(
          result.data,
          area.id,
        );
        if (selectedAreaWithBlocks != null &&
            selectedAreaWithBlocks.blocks.isNotEmpty) {
          _areaBlocksCache[area.id] = selectedAreaWithBlocks;
        }
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

  Future<LocationAreaEntity?> _loadAreaBlocks(
    String countryCode,
    String areaId,
  ) async {
    final cached = _areaBlocksCache[areaId];
    if (cached != null && cached.blocks.isNotEmpty) {
      return cached;
    }

    final result = await _getLocationsCatalogUseCase(
      countryCode,
      areaId: areaId,
    );

    switch (result) {
      case ApiSuccessResult():
        final area = AddressCatalogMatcher.findAreaById(result.data, areaId);
        if (area != null && area.blocks.isNotEmpty) {
          _areaBlocksCache[areaId] = area;
        }
        return area;
      case ApiErrorResult():
        return null;
    }
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
        (latitude - lastLatitude).abs() < 0.0001 &&
        (longitude - lastLongitude).abs() < 0.0001) {
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
    _geocodeRequestId++;
    final currentRequestId = _geocodeRequestId;
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
    if (isClosed ||
        memberGeneration != _familyMemberGeneration ||
        currentRequestId != _geocodeRequestId) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        final autofill = result.data;
        _lastReverseGeocodeResult = autofill;
        final updatedLocations = await _resolveAutofillCatalogState(
          autofill,
          memberGeneration: memberGeneration,
        );
        if (!isClosed &&
            memberGeneration == _familyMemberGeneration &&
            currentRequestId == _geocodeRequestId) {
          emit(
            state.copyWith(
              locations: updatedLocations ?? state.locations,
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
    _geocodeRequestId++;
    final currentRequestId = _geocodeRequestId;
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
    if (isClosed ||
        memberGeneration != _familyMemberGeneration ||
        currentRequestId != _geocodeRequestId) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        final autofill = result.data;
        final updatedLocations = await _resolveAutofillCatalogState(
          autofill,
          memberGeneration: memberGeneration,
        );
        if (!isClosed &&
            memberGeneration == _familyMemberGeneration &&
            currentRequestId == _geocodeRequestId) {
          emit(
            state.copyWith(
              locations: updatedLocations ?? state.locations,
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

  Future<LocationsCatalogState?> _resolveAutofillCatalogState(
    MapAddressAutofillEntity autofill, {
    required int memberGeneration,
  }) async {
    if (memberGeneration != _familyMemberGeneration) return null;
    final catalog = state.locations.data;
    if (catalog == null) return null;

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

    final selection = AddressCatalogMatcher.findInitialSelection(
      catalog,
      tempAddress,
      autofill: autofill,
    );
    if (selection.governorate == null && selection.area == null) return null;

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
        ? AddressCatalogMatcher.findInitialBlock(
            selectedArea,
            tempAddress,
            autofill: autofill,
          )
        : null;

    return state.locations.copyWith(
      selectedGovernorate: selection.governorate,
      selectedArea: selectedArea,
      selectedBlock: selectedBlock,
    );
  }

  Future<void> _addCustomerAddress(CustomerAddressRequestEntity request) async {
    if (!isWithinKuwaitBounds(request.latitude, request.longitude)) {
      emit(
        state.copyWith(
          action: state.action.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: AddressOutOfBoundsFailure(),
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
            failure: AddressOutOfBoundsFailure(),
          ),
        ),
      );
      return;
    }

    await _runAddressAction(
      () => _updateCustomerAddressUseCase(addressId, request),
    );
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
    _coverageSessionId++;
    final sessionId = _coverageSessionId;

    if (!isWithinKuwaitBounds(request.latitude, request.longitude)) {
      emit(
        state.copyWith(
          coveragePreview: state.coveragePreview.copyWith(
            sessionId: sessionId,
            isLoading: false,
            isSuccess: false,
            failure: AddressOutOfBoundsFailure(),
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        coveragePreview: AddressCoveragePreviewState(
          sessionId: sessionId,
          isLoading: true,
          isSuccess: false,
          pendingAction: AddressPendingActionType.add,
          pendingRequest: request,
        ),
      ),
    );

    final familyMemberId = _familyMemberId;
    final result = familyMemberId == null
        ? await _previewNewAddressCoverageUseCase(
            request,
            page: AppConstants.firstPage,
            pageSize: AppConstants.defaultPageSize,
          )
        : await _previewFamilyMemberAddressUseCase!(
            familyMemberId,
            request,
            page: AppConstants.firstPage,
            pageSize: AppConstants.defaultPageSize,
          );
    if (isClosed ||
        memberGeneration != _familyMemberGeneration ||
        sessionId != _coverageSessionId) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoading: false,
              isSuccess: true,
              preview: result.data,
              reachedEnd: _hasReachedEnd(result.data),
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
    final memberGeneration = _familyMemberGeneration;
    _coverageSessionId++;
    final sessionId = _coverageSessionId;

    if (!isWithinKuwaitBounds(request.latitude, request.longitude)) {
      emit(
        state.copyWith(
          coveragePreview: state.coveragePreview.copyWith(
            sessionId: sessionId,
            isLoading: false,
            isSuccess: false,
            failure: AddressOutOfBoundsFailure(),
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        coveragePreview: AddressCoveragePreviewState(
          sessionId: sessionId,
          isLoading: true,
          isSuccess: false,
          pendingAction: AddressPendingActionType.update,
          targetAddressId: addressId,
          pendingRequest: request,
        ),
      ),
    );

    final result = await _previewNewAddressCoverageUseCase(
      request,
      page: AppConstants.firstPage,
      pageSize: AppConstants.defaultPageSize,
    );
    if (isClosed ||
        memberGeneration != _familyMemberGeneration ||
        sessionId != _coverageSessionId) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoading: false,
              isSuccess: true,
              preview: result.data,
              reachedEnd: _hasReachedEnd(result.data),
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
    final memberGeneration = _familyMemberGeneration;
    _coverageSessionId++;
    final sessionId = _coverageSessionId;

    emit(
      state.copyWith(
        coveragePreview: AddressCoveragePreviewState(
          sessionId: sessionId,
          isLoading: true,
          isSuccess: false,
          pendingAction: AddressPendingActionType.setDefault,
          targetAddressId: addressId,
        ),
      ),
    );

    final result = await _previewExistingAddressCoverageUseCase(
      addressId,
      page: AppConstants.firstPage,
      pageSize: AppConstants.defaultPageSize,
    );
    if (isClosed ||
        memberGeneration != _familyMemberGeneration ||
        sessionId != _coverageSessionId) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoading: false,
              isSuccess: true,
              preview: result.data,
              reachedEnd: _hasReachedEnd(result.data),
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

  bool _hasReachedEnd(
    AddressCoveragePreviewEntity entity, [
    int? currentServerPage,
  ]) {
    final meta = entity.pagination;
    if (meta == null) return true;
    if (meta.hasNextPage == false) return true;
    if (entity.servingRestaurants.isEmpty) return true;
    if (currentServerPage != null &&
        meta.page != null &&
        meta.page! <= currentServerPage) {
      return true;
    }
    return false;
  }

  Future<void> _loadMoreAddressCoverageRestaurants() async {
    final current = state.coveragePreview;
    final preview = current.preview;
    final meta = preview?.pagination;
    if (isClosed ||
        current.isLoading ||
        current.isLoadingMore ||
        state.action.isLoading ||
        !current.canLoadMore ||
        preview == null ||
        meta == null) {
      return;
    }
    final page = meta.page;
    final pageSize = meta.pageSize;
    if (page == null || page < 1 || pageSize == null || pageSize < 1) return;
    final nextPage = page + 1;
    final sessionId = current.sessionId;
    final memberGeneration = _familyMemberGeneration;

    emit(
      state.copyWith(
        coveragePreview: current.copyWith(
          isLoadingMore: true,
          clearLoadMoreFailure: true,
        ),
      ),
    );

    final result = await _requestCoveragePage(
      current,
      page: nextPage,
      pageSize: pageSize,
    );

    if (isClosed ||
        memberGeneration != _familyMemberGeneration ||
        sessionId != _coverageSessionId) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        final incoming = result.data;
        final seen = <String>{
          for (final item in preview.servingRestaurants)
            if (item.id.isNotEmpty) item.id,
        };
        final merged = <ServingRestaurantEntity>[...preview.servingRestaurants];
        for (final item in incoming.servingRestaurants) {
          if (item.id.isEmpty || seen.add(item.id)) merged.add(item);
        }
        final updated = preview.copyWith(
          servingRestaurants: List.unmodifiable(merged),
          pagination: incoming.pagination,
          clearPagination: incoming.pagination == null,
        );
        final reachedEnd = _hasReachedEnd(incoming, page);

        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoadingMore: false,
              clearLoadMoreFailure: true,
              preview: updated,
              reachedEnd: reachedEnd,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            coveragePreview: state.coveragePreview.copyWith(
              isLoadingMore: false,
              loadMoreFailure: result.failure,
            ),
          ),
        );
    }
  }

  Future<ApiResult<AddressCoveragePreviewEntity>> _requestCoveragePage(
    AddressCoveragePreviewState context, {
    required int page,
    required int pageSize,
  }) {
    final pendingAction = context.pendingAction;
    final pendingRequest = context.pendingRequest;
    final targetId = context.targetAddressId;

    if (pendingAction == AddressPendingActionType.setDefault &&
        targetId != null) {
      return _previewExistingAddressCoverageUseCase(
        targetId,
        page: page,
        pageSize: pageSize,
      );
    } else if (pendingRequest != null) {
      final familyMemberId = _familyMemberId;
      if (familyMemberId != null &&
          _previewFamilyMemberAddressUseCase != null) {
        return _previewFamilyMemberAddressUseCase!(
          familyMemberId,
          pendingRequest,
          page: page,
          pageSize: pageSize,
        );
      }
      return _previewNewAddressCoverageUseCase(
        pendingRequest,
        page: page,
        pageSize: pageSize,
      );
    }
    return Future.value(
      ApiErrorResult(
        failure: Failure(
          errorMessage: 'No pending address request for coverage paging',
        ),
      ),
    );
  }

  Future<void> _retryAddressCoveragePreview() async {
    final current = state.coveragePreview;
    if (current.loadMoreFailure != null) {
      _loadMoreAddressCoverageRestaurants();
    } else if (current.failure != null) {
      final pendingAction = current.pendingAction;
      final pendingRequest = current.pendingRequest;
      final targetId = current.targetAddressId;

      if (pendingAction == AddressPendingActionType.setDefault &&
          targetId != null) {
        await _previewExistingAddressCoverage(targetId);
      } else if (pendingAction == AddressPendingActionType.update &&
          targetId != null &&
          pendingRequest != null) {
        _previewUpdateAddressCoverage(targetId, pendingRequest);
      } else if (pendingRequest != null) {
        _previewNewAddressCoverage(pendingRequest);
      }
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

    _coverageSessionId++;
    emit(
      state.copyWith(
        coveragePreview: AddressCoveragePreviewState(
          sessionId: _coverageSessionId,
        ),
      ),
    );

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
    _coverageSessionId++;
    emit(
      state.copyWith(
        coveragePreview: AddressCoveragePreviewState(
          sessionId: _coverageSessionId,
        ),
      ),
    );
  }
}
