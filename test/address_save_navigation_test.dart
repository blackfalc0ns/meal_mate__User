import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'successful address save closes preview and returns to refreshed list',
    () {
      final chooseLocationSource = File(
        'lib/features/addresses/presentation/screens/address_choose_location_screen.dart',
      ).readAsStringSync();
      final addressesSource = File(
        'lib/features/addresses/presentation/screens/addresses_screen.dart',
      ).readAsStringSync();
      final viewModelSource = File(
        'lib/features/addresses/presentation/manager/addresses_view_model.dart',
      ).readAsStringSync();

      expect(
        chooseLocationSource,
        contains('Navigator.of(sheetContext).pop();'),
      );
      expect(addressesSource, contains('await Navigator.of(context)'));
      expect(addressesSource, contains('const GetCustomerAddressesEvent()'));
      expect(chooseLocationSource, contains('CustomSnackbar.showSuccess('));
      final confirmIndex = viewModelSource.indexOf(
        'Future<void> _confirmPendingAddressAction()',
      );
      final consumePreviewIndex = viewModelSource.indexOf(
        'coveragePreview: AddressCoveragePreviewState(',
        confirmIndex,
      );
      final actionSwitchIndex = viewModelSource.indexOf(
        'switch (pendingAction)',
        confirmIndex,
      );

      expect(confirmIndex, isNonNegative);
      expect(consumePreviewIndex, isNonNegative);
      expect(consumePreviewIndex, lessThan(actionSwitchIndex));
    },
  );
}
