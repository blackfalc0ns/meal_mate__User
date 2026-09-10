import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/models/family_address_options.dart';

void main() {
  const first = CustomerAddressEntity(
    addressId: 'address-1',
    label: 'Home',
    addressLine: 'First',
    isDefault: true,
    notifyOnDelivery: true,
  );
  const duplicate = CustomerAddressEntity(
    addressId: 'address-1',
    label: 'Duplicate',
    addressLine: 'Second',
    isDefault: false,
    notifyOnDelivery: false,
  );

  test('returns one dropdown option for each non-empty address id', () {
    final options = buildFamilyAddressOptions(const [first, duplicate]);

    expect(options, [same(first)]);
  });

  test('keeps a selected member address missing from the fetched list', () {
    final options = buildFamilyAddressOptions(const [], selectedAddress: first);

    expect(options, [same(first)]);
    expect(
      resolveFamilyAddressSelection(options, selectedAddressId: 'address-1'),
      'address-1',
    );
  });
}
