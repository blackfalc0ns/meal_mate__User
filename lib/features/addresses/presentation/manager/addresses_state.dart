import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';

class AddressesState {
  const AddressesState({
    this.addresses = const CustomerAddressesState(),
    this.action = const AddressesActionState(),
  });

  final CustomerAddressesState addresses;
  final AddressesActionState action;

  AddressesState copyWith({
    CustomerAddressesState? addresses,
    AddressesActionState? action,
  }) {
    return AddressesState(
      addresses: addresses ?? this.addresses,
      action: action ?? this.action,
    );
  }
}

class CustomerAddressesState {
  const CustomerAddressesState({
    this.isLoading = false,
    this.isSuccess = false,
    this.items = const [],
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final List<CustomerAddressEntity> items;
  final Failure? failure;

  CustomerAddressEntity? get defaultAddress {
    for (final item in items) {
      if (item.isDefault) return item;
    }
    return items.isEmpty ? null : items.first;
  }

  CustomerAddressesState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<CustomerAddressEntity>? items,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return CustomerAddressesState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      items: items ?? this.items,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}

class AddressesActionState {
  const AddressesActionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Failure? failure;

  AddressesActionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return AddressesActionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}
