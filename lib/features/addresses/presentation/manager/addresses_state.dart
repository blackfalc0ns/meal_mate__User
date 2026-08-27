import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';

class AddressesState {
  const AddressesState({
    this.addresses = const CustomerAddressesState(),
    this.locations = const LocationsCatalogState(),
    this.action = const AddressesActionState(),
  });

  final CustomerAddressesState addresses;
  final LocationsCatalogState locations;
  final AddressesActionState action;

  AddressesState copyWith({
    CustomerAddressesState? addresses,
    LocationsCatalogState? locations,
    AddressesActionState? action,
  }) {
    return AddressesState(
      addresses: addresses ?? this.addresses,
      locations: locations ?? this.locations,
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

  CustomerAddressEntity? get currentDeliveryAddress {
    for (final item in items) {
      if (item.isDeliveryActive) return item;
    }
    return defaultAddress;
  }

  String? get pendingDeliveryChangeNotice {
    for (final item in items) {
      final notice = item.deliveryChangeNotice;
      if (notice != null && notice.isNotEmpty) return notice;
    }
    return null;
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

class LocationsCatalogState {
  const LocationsCatalogState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.selectedGovernorate,
    this.selectedArea,
    this.selectedBlock,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final LocationsCatalogEntity? data;
  final LocationGovernorateEntity? selectedGovernorate;
  final LocationAreaEntity? selectedArea;
  final LocationBlockEntity? selectedBlock;
  final Failure? failure;

  List<LocationGovernorateEntity> get governorates {
    return data?.governorates ?? const [];
  }

  List<LocationAreaEntity> get areas {
    return selectedGovernorate?.areas ?? const [];
  }

  List<LocationBlockEntity> get blocks {
    return selectedArea?.blocks ?? const [];
  }

  LocationsCatalogState copyWith({
    bool? isLoading,
    bool? isSuccess,
    LocationsCatalogEntity? data,
    LocationGovernorateEntity? selectedGovernorate,
    LocationAreaEntity? selectedArea,
    LocationBlockEntity? selectedBlock,
    Failure? failure,
    bool clearFailure = false,
    bool clearSelectedGovernorate = false,
    bool clearSelectedArea = false,
    bool clearSelectedBlock = false,
  }) {
    return LocationsCatalogState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      selectedGovernorate: clearSelectedGovernorate
          ? null
          : selectedGovernorate ?? this.selectedGovernorate,
      selectedArea: clearSelectedArea
          ? null
          : selectedArea ?? this.selectedArea,
      selectedBlock: clearSelectedBlock
          ? null
          : selectedBlock ?? this.selectedBlock,
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
    this.address,
    this.deliveryChangeNotice,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Failure? failure;
  final CustomerAddressEntity? address;
  final String? deliveryChangeNotice;

  String? get displayErrorMessage {
    final code = failure?.code.trim();
    if (code != null && code.isNotEmpty && code != 'unknown') {
      return code;
    }
    return errorMessage;
  }

  AddressesActionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Failure? failure,
    CustomerAddressEntity? address,
    String? deliveryChangeNotice,
    bool clearError = false,
    bool clearAddress = false,
  }) {
    return AddressesActionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
      address: clearAddress ? null : address ?? this.address,
      deliveryChangeNotice: clearError
          ? null
          : deliveryChangeNotice ?? this.deliveryChangeNotice,
    );
  }
}
