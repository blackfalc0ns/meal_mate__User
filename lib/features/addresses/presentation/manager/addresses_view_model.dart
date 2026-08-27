import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/add_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/delete_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/update_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';

@injectable
class AddressesViewModel extends Cubit<AddressesState> {
  AddressesViewModel(
    this._getCustomerAddressesUseCase,
    this._getLocationsCatalogUseCase,
    this._addCustomerAddressUseCase,
    this._updateCustomerAddressUseCase,
    this._deleteCustomerAddressUseCase,
  ) : super(const AddressesState());

  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;
  final GetLocationsCatalogUseCase _getLocationsCatalogUseCase;
  final AddCustomerAddressUseCase _addCustomerAddressUseCase;
  final UpdateCustomerAddressUseCase _updateCustomerAddressUseCase;
  final DeleteCustomerAddressUseCase _deleteCustomerAddressUseCase;

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

    switch (result) {
      case ApiSuccessResult():
        final initialSelection = _findInitialSelection(
          result.data,
          initialAddress,
        );
        final selectedAreaWithBlocks = initialSelection.area == null
            ? null
            : await _loadAreaBlocks(countryCode, initialSelection.area!.id);
        final selectedArea = selectedAreaWithBlocks ?? initialSelection.area;
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
    CustomerAddressEntity? address,
  ) {
    if (address == null) return const _InitialLocationSelection();

    for (final governorate in locations.governorates) {
      for (final area in governorate.areas) {
        if (_matchesArea(area, address)) {
          return _InitialLocationSelection(
            governorate: governorate,
            area: area,
          );
        }
      }
    }

    return const _InitialLocationSelection();
  }

  bool _matchesArea(LocationAreaEntity area, CustomerAddressEntity address) {
    return _matchesValue(area.id, address.regionId) ||
        _matchesValue(area.code, address.area) ||
        _matchesValue(area.nameAr, address.area) ||
        _matchesValue(area.nameEn, address.area);
  }

  LocationBlockEntity? _findInitialBlock(
    LocationAreaEntity area,
    CustomerAddressEntity? address,
  ) {
    if (address == null) return null;

    for (final block in area.blocks) {
      if (_matchesValue(block.id, address.blockRegionId) ||
          _matchesValue(block.code, address.block) ||
          _matchesValue(block.nameAr, address.block) ||
          _matchesValue(block.nameEn, address.block)) {
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

  Future<void> _addCustomerAddress(CustomerAddressRequestEntity request) async {
    await _runAddressAction(() => _addCustomerAddressUseCase(request));
    if (!isClosed && state.action.isSuccess) {
      await _getCustomerAddresses();
      _setDeliveryNoticeFromRefreshedAddresses();
    }
  }

  Future<void> _updateCustomerAddress(
    String addressId,
    CustomerAddressRequestEntity request,
  ) async {
    await _runAddressAction(
      () => _updateCustomerAddressUseCase(addressId, request),
    );
    if (!isClosed && state.action.isSuccess) {
      await _getCustomerAddresses();
      _setDeliveryNoticeFromRefreshedAddresses();
    }
  }

  Future<void> _deleteCustomerAddress(String addressId) async {
    await _runVoidAction(() => _deleteCustomerAddressUseCase(addressId));
    if (!isClosed && state.action.isSuccess) {
      await _getCustomerAddresses();
    }
  }

  void _setDeliveryNoticeFromRefreshedAddresses() {
    final existingNotice = state.action.deliveryChangeNotice;
    if (existingNotice != null && existingNotice.isNotEmpty) return;

    final refreshedNotice = state.addresses.pendingDeliveryChangeNotice;
    if (refreshedNotice == null || refreshedNotice.isEmpty) return;

    emit(
      state.copyWith(
        action: state.action.copyWith(deliveryChangeNotice: refreshedNotice),
      ),
    );
  }

  Future<void> _runAddressAction(
    Future<ApiResult<CustomerAddressEntity>> Function() action,
  ) async {
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
}

class _InitialLocationSelection {
  const _InitialLocationSelection({this.governorate, this.area});

  final LocationGovernorateEntity? governorate;
  final LocationAreaEntity? area;
}
