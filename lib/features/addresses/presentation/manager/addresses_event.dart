import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';

sealed class AddressesEvent {
  const AddressesEvent();
}

class GetCustomerAddressesEvent extends AddressesEvent {
  const GetCustomerAddressesEvent();
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
