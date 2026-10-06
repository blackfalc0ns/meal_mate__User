import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';

List<CustomerAddressEntity> buildFamilyAddressOptions(
  List<CustomerAddressEntity> addresses, {
  CustomerAddressEntity? selectedAddress,
}) {
  final uniqueAddresses = <String, CustomerAddressEntity>{};

  for (final address in addresses) {
    final addressId = address.addressId;
    if (addressId.trim().isEmpty) continue;
    uniqueAddresses.putIfAbsent(addressId, () => address);
  }

  if (selectedAddress != null && selectedAddress.addressId.trim().isNotEmpty) {
    uniqueAddresses.putIfAbsent(
      selectedAddress.addressId,
      () => selectedAddress,
    );
  }

  return uniqueAddresses.values.toList(growable: false);
}

String? resolveFamilyAddressSelection(
  List<CustomerAddressEntity> options, {
  String? selectedAddressId,
}) {
  if (selectedAddressId != null &&
      options.any((address) => address.addressId == selectedAddressId)) {
    return selectedAddressId;
  }
  return options.firstOrNull?.addressId;
}
