import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/add_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/delete_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/update_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';

@injectable
class AddressesViewModel extends Cubit<AddressesState> {
  AddressesViewModel(
    this._getCustomerAddressesUseCase,
    this._addCustomerAddressUseCase,
    this._updateCustomerAddressUseCase,
    this._deleteCustomerAddressUseCase,
  ) : super(const AddressesState());

  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;
  final AddCustomerAddressUseCase _addCustomerAddressUseCase;
  final UpdateCustomerAddressUseCase _updateCustomerAddressUseCase;
  final DeleteCustomerAddressUseCase _deleteCustomerAddressUseCase;

  void doIntent(AddressesEvent event) {
    switch (event) {
      case GetCustomerAddressesEvent():
        _getCustomerAddresses();
      case AddCustomerAddressEvent():
        _addCustomerAddress(event.request);
      case UpdateCustomerAddressEvent():
        _updateCustomerAddress(event.addressId, event.request);
      case DeleteCustomerAddressEvent():
        _deleteCustomerAddress(event.addressId);
    }
  }

  Future<void> _getCustomerAddresses() async {
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

  Future<void> _addCustomerAddress(CustomerAddressRequestEntity request) async {
    await _runAction(() => _addCustomerAddressUseCase(request));
    if (state.action.isSuccess) {
      _getCustomerAddresses();
    }
  }

  Future<void> _updateCustomerAddress(
    String addressId,
    CustomerAddressRequestEntity request,
  ) async {
    await _runAction(() => _updateCustomerAddressUseCase(addressId, request));
    if (state.action.isSuccess) {
      _getCustomerAddresses();
    }
  }

  Future<void> _deleteCustomerAddress(String addressId) async {
    await _runAction(() => _deleteCustomerAddressUseCase(addressId));
    if (state.action.isSuccess) {
      _getCustomerAddresses();
    }
  }

  Future<void> _runAction(Future<ApiResult<void>> Function() action) async {
    emit(
      state.copyWith(
        action: state.action.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
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
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }
}
