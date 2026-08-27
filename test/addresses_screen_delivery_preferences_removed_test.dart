import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('addresses screen does not include delivery preferences section', () {
    final source = File(
      'lib/features/addresses/presentation/screens/addresses_screen.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('DeliveryPreferencesCard')));
    expect(source, isNot(contains('addresses_delivery_preferences')));
  });
}
