import 'package:flutter/foundation.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_state.dart';
import 'package:meal_meat_user/core/network/failures.dart';

export 'package:meal_meat_user/core/address/presentation/manager/address_editor_state.dart';

class AddressesState {
  const AddressesState({
    this.addresses = const CustomerAddressesState(),
    this.locations = const LocationsCatalogState(),
    this.action = const AddressesActionState(),
    this.mapAutofill = const MapAutofillState(),
    this.coveragePreview = const AddressCoveragePreviewState(),
  });

  final CustomerAddressesState addresses;
  final LocationsCatalogState locations;
  final AddressesActionState action;
  final MapAutofillState mapAutofill;
  final AddressCoveragePreviewState coveragePreview;

  AddressesState copyWith({
    CustomerAddressesState? addresses,
    LocationsCatalogState? locations,
    AddressesActionState? action,
    MapAutofillState? mapAutofill,
    AddressCoveragePreviewState? coveragePreview,
  }) {
    return AddressesState(
      addresses: addresses ?? this.addresses,
      locations: locations ?? this.locations,
      action: action ?? this.action,
      mapAutofill: mapAutofill ?? this.mapAutofill,
      coveragePreview: coveragePreview ?? this.coveragePreview,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressesState &&
          runtimeType == other.runtimeType &&
          addresses == other.addresses &&
          locations == other.locations &&
          action == other.action &&
          mapAutofill == other.mapAutofill &&
          coveragePreview == other.coveragePreview;

  @override
  int get hashCode =>
      Object.hash(addresses, locations, action, mapAutofill, coveragePreview);
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAddressesState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          isSuccess == other.isSuccess &&
          failure == other.failure &&
          listEquals(items, other.items);

  @override
  int get hashCode =>
      Object.hash(isLoading, isSuccess, failure, Object.hashAll(items));
}
