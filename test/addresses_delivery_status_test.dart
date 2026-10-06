import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';

void main() {
  test('current delivery address prefers delivery active over default', () {
    const pendingDefaultAddress = CustomerAddressEntity(
      addressId: 'pending-default',
      label: 'New default',
      addressLine: 'New default address',
      isDefault: true,
      isDeliveryActive: false,
      notifyOnDelivery: true,
    );
    const activeDeliveryAddress = CustomerAddressEntity(
      addressId: 'active-delivery',
      label: 'Current delivery',
      addressLine: 'Current delivery address',
      isDefault: false,
      isDeliveryActive: true,
      notifyOnDelivery: true,
    );

    const state = CustomerAddressesState(
      items: [pendingDefaultAddress, activeDeliveryAddress],
    );

    expect(state.currentDeliveryAddress, activeDeliveryAddress);
  });

  test('action display error prefers backend code over backend detail', () {
    final failure = Failure(
      errorMessage: 'This address is currently used for delivery.',
      code: 'address.active_delivery_cannot_delete',
    );
    final state = AddressesActionState(
      errorMessage: failure.errorMessage,
      failure: failure,
    );

    expect(state.displayErrorMessage, 'address.active_delivery_cannot_delete');
  });

  test('pending delivery notice comes from the refreshed address list', () {
    const notice = 'Delivery changes activate after 72 hours.';
    const activeDeliveryAddress = CustomerAddressEntity(
      addressId: 'active-delivery',
      label: 'Current delivery',
      addressLine: 'Current delivery address',
      isDefault: false,
      isDeliveryActive: true,
      notifyOnDelivery: true,
    );
    const pendingDefaultAddress = CustomerAddressEntity(
      addressId: 'pending-default',
      label: 'Pending default',
      addressLine: 'Pending default address',
      isDefault: true,
      isDeliveryActive: false,
      notifyOnDelivery: true,
      deliveryChangeNotice: notice,
    );

    const state = CustomerAddressesState(
      items: [activeDeliveryAddress, pendingDefaultAddress],
    );

    expect(state.pendingDeliveryChangeNotice, notice);
  });
}
