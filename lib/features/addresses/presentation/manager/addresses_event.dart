import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';

sealed class AddressesEvent {
  const AddressesEvent();
}

class GetCustomerAddressesEvent extends AddressesEvent {
  const GetCustomerAddressesEvent();
}

class GetLocationsCatalogEvent extends AddressesEvent {
  const GetLocationsCatalogEvent({
    this.countryCode = 'KW',
    this.initialAddress,
  });

  final String countryCode;
  final CustomerAddressEntity? initialAddress;
}

class SelectAddressGovernorateEvent extends AddressesEvent {
  const SelectAddressGovernorateEvent(this.governorate);

  final LocationGovernorateEntity governorate;
}

class SelectAddressAreaEvent extends AddressesEvent {
  const SelectAddressAreaEvent(this.area);

  final LocationAreaEntity area;
}

class SelectAddressBlockEvent extends AddressesEvent {
  const SelectAddressBlockEvent(this.block);

  final LocationBlockEntity block;
}

class AddCustomerAddressEvent extends AddressesEvent {
  const AddCustomerAddressEvent(this.request);

  final CustomerAddressRequestEntity request;
}

class UpdateCustomerAddressEvent extends AddressesEvent {
  const UpdateCustomerAddressEvent({
    required this.addressId,
    required this.request,
  });

  final String addressId;
  final CustomerAddressRequestEntity request;
}

class DeleteCustomerAddressEvent extends AddressesEvent {
  const DeleteCustomerAddressEvent(this.addressId);

  final String addressId;
}

class ReverseGeocodeEvent extends AddressesEvent {
  const ReverseGeocodeEvent({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class GeocodeAddressEvent extends AddressesEvent {
  const GeocodeAddressEvent({required this.address, this.countryCode = 'KW'});

  final String address;
  final String countryCode;
}
