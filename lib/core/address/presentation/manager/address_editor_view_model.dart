import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meal_meat_user/core/address/domain/contracts/address_editor_operations.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/core/address/domain/repo/address_location_repository.dart';
import 'package:meal_meat_user/core/address/domain/usecase/geocode_address_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/reverse_geocode_location_usecase.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_catalog_matcher.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_event.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_state.dart';
import 'package:meal_meat_user/core/constants/app_constants.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';

class AddressEditorViewModel extends Cubit<AddressEditorState> {
  AddressEditorViewModel({
    required AddressEditorOperations operations,
    GetLocationsCatalogUseCase? getLocationsCatalogUseCase,
    GeocodeAddressUseCase? geocodeAddressUseCase,
    ReverseGeocodeLocationUseCase? reverseGeocodeLocationUseCase,
    AddressLocationRepository? locationRepository,
  }) : // ignore: prefer_initializing_formals
       _operations = operations,
       _getLocationsCatalogUseCase =
           getLocationsCatalogUseCase ??
           (locationRepository != null
               ? GetLocationsCatalogUseCase(locationRepository)
               : null)!,
       _geocodeAddressUseCase =
           geocodeAddressUseCase ??
           (locationRepository != null
               ? GeocodeAddressUseCase(locationRepository)
               : null)!,
       _reverseGeocodeLocationUseCase =
           reverseGeocodeLocationUseCase ??
           (locationRepository != null
               ? ReverseGeocodeLocationUseCase(locationRepository)
               : null)!,
       super(const AddressEditorState());

  final AddressEditorOperations _operations;
  final GetLocationsCatalogUseCase _getLocationsCatalogUseCase;
  final GeocodeAddressUseCase _geocodeAddressUseCase;
  final ReverseGeocodeLocationUseCase _reverseGeocodeLocationUseCase;

  AddressEditorOperations get operations => _operations;

  double? _lastReverseGeocodeLatitude;
  double? _lastReverseGeocodeLongitude;
  MapAddressAutofillEntity? _lastReverseGeocodeResult;
  final Map<String, LocationAreaEntity> _areaBlocksCache = {};

  int _sessionRevision = 0;
  int _areaRequestRevision = 0;
  int _geocodeRequestId = 0;
  int _coverageSessionId = 0;
  bool _isSaving = false;

  static bool isWithinKuwaitBounds(double? lat, double? lng) {
    if (lat == null || lng == null) return false;
    return lat >= 28.5 && lat <= 30.2 && lng >= 46.5 && lng <= 48.5;
  }

  void _clearReverseGeocodeCache() {
    _lastReverseGeocodeLatitude = null;
    _lastReverseGeocodeLongitude = null;
    _lastReverseGeocodeResult = null;
  }

  Future<void> doIntent(AddressEditorEvent event) async {
    switch (event) {
      case GetLocationsCatalogEvent():
        await _getLocationsCatalog(event.countryCode, event.initialAddress);
      case SelectAddressGovernorateEvent():
        _selectGovernorate(event.governorate);
      case SelectAddressAreaEvent():
        await _selectArea(event.area);
      case SelectAddressBlockEvent():
        _selectBlock(event.block);
      case ReverseGeocodeEvent():
        await _reverseGeocode(
          event.latitude,
          event.longitude,
          force: event.force,
        );
      case GeocodeAddressEvent():
        await _geocodeAddress(event.address, event.countryCode);
      case PreviewNewAddressCoverageEvent():
        await _previewNewAddressCoverage(event.request);
      case PreviewUpdateAddressCoverageEvent():
        await _previewUpdateAddressCoverage(event.addressId, event.request);
      case PreviewExistingAddressCoverageEvent():
        await _previewExistingAddressCoverage(event.addressId);
      case ConfirmPendingAddressActionEvent():
        await _confirmPendingAddressAction();
      case ClearCoveragePreviewEvent():
        _clearCoveragePreview();
      case LoadMoreAddressCoverageRestaurantsEvent():
        await _loadMoreAddressCoverageRestaurants();
      case RetryAddressCoveragePreviewEvent():
        await _retryAddressCoveragePreview();
      case SubmitAddressEvent():
        await _submitAddress(event.request, addressId: event.addressId);
      case SetDefaultAddressEvent():
        await _setDefaultAddress(event.addressId);
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

    final session = _sessionRevision;
    final result = await _getLocationsCatalogUseCase(countryCode);
    if (isClosed || session != _sessionRevision) return;

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
    if (state.locations.selectedGovernorate == governorate) return;
    _areaRequestRevision++;
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
    if (state.locations.selectedArea?.id == area.id &&
        state.locations.selectedArea?.blocks.isNotEmpty == true) {
      return;
    }

    final session = _sessionRevision;
    final requestRev = ++_areaRequestRevision;

    emit(
      state.copyWith(
        locations: state.locations.copyWith(
          selectedArea: area,
          clearSelectedBlock: true,
          clearFailure: true,
        ),
      ),
    );

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
    if (isClosed ||
        session != _sessionRevision ||
        requestRev != _areaRequestRevision) {
      return;
    }

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
    final session = _sessionRevision;
    final currentRequestId = ++_geocodeRequestId;
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
        session != _sessionRevision ||
        currentRequestId != _geocodeRequestId) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        final autofill = result.data;
        _lastReverseGeocodeResult = autofill;
        final updatedLocations = await _resolveAutofillCatalogState(
          autofill,
          session: session,
        );
        if (!isClosed &&
            session == _sessionRevision &&
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
    final session = _sessionRevision;
    final currentRequestId = ++_geocodeRequestId;
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
        session != _sessionRevision ||
        currentRequestId != _geocodeRequestId) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        final autofill = result.data;
        final updatedLocations = await _resolveAutofillCatalogState(
          autofill,
          session: session,
        );
        if (!isClosed &&
            session == _sessionRevision &&
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
    required int session,
  }) async {
    if (session != _sessionRevision) return null;
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

  Future<void> _submitAddress(
    CustomerAddressRequestEntity request, {
    String? addressId,
  }) async {
    if (_isSaving) return;

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

    final isUpdate = addressId != null && addressId.isNotEmpty;
    final actionType = isUpdate
        ? AddressEditorAction.update
        : AddressEditorAction.add;

    if (!_operations.supportedActions.contains(actionType)) {
      emit(
        state.copyWith(
          action: state.action.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: Failure(
              errorMessage:
                  'Action ${actionType.name} is not supported by operations',
            ),
          ),
        ),
      );
      return;
    }

    _isSaving = true;
    try {
      await _runAddressAction(() {
        if (isUpdate) {
          return _operations.update(addressId, request);
        } else {
          return _operations.add(request);
        }
      });
    } finally {
      _isSaving = false;
    }
  }

  Future<void> _setDefaultAddress(String addressId) async {
    if (_isSaving) return;

    if (!_operations.supportedActions.contains(
      AddressEditorAction.setDefault,
    )) {
      emit(
        state.copyWith(
          action: state.action.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: Failure(
              errorMessage: 'setDefault action is not supported by operations',
            ),
          ),
        ),
      );
      return;
    }

    _isSaving = true;
    try {
      await _runAddressAction(() => _operations.setDefault(addressId));
    } finally {
      _isSaving = false;
    }
  }

  Future<void> _runAddressAction(
    Future<ApiResult<CustomerAddressEntity>> Function() action,
  ) async {
    final session = _sessionRevision;
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
    if (isClosed || session != _sessionRevision) return;

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

  Future<void> _previewNewAddressCoverage(
    CustomerAddressRequestEntity request,
  ) async {
    final session = _sessionRevision;
    final sessionId = ++_coverageSessionId;

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

    final result = await _operations.previewNew(
      request,
      page: AppConstants.firstPage,
      pageSize: AppConstants.defaultPageSize,
    );
    if (isClosed ||
        session != _sessionRevision ||
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
    final session = _sessionRevision;
    final sessionId = ++_coverageSessionId;

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

    final result = await _operations.previewNew(
      request,
      page: AppConstants.firstPage,
      pageSize: AppConstants.defaultPageSize,
    );
    if (isClosed ||
        session != _sessionRevision ||
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
    final session = _sessionRevision;
    final sessionId = ++_coverageSessionId;

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

    final result = await _operations.previewExisting(
      addressId,
      page: AppConstants.firstPage,
      pageSize: AppConstants.defaultPageSize,
    );
    if (isClosed ||
        session != _sessionRevision ||
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
    final session = _sessionRevision;

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
        session != _sessionRevision ||
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
      return _operations.previewExisting(
        targetId,
        page: page,
        pageSize: pageSize,
      );
    } else if (pendingRequest != null) {
      return _operations.previewNew(
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
      await _loadMoreAddressCoverageRestaurants();
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
        await _previewUpdateAddressCoverage(targetId, pendingRequest);
      } else if (pendingRequest != null) {
        await _previewNewAddressCoverage(pendingRequest);
      }
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
          await _submitAddress(pendingRequest);
        }
      case AddressPendingActionType.update:
        if (targetId != null && pendingRequest != null) {
          await _submitAddress(pendingRequest, addressId: targetId);
        }
      case AddressPendingActionType.setDefault:
        if (targetId != null) {
          await _setDefaultAddress(targetId);
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

  @override
  Future<void> close() {
    _sessionRevision++;
    _clearReverseGeocodeCache();
    return super.close();
  }
}
