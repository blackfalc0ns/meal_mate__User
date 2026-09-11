import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final dialogSource = File(
    'lib/features/family_subscription_setup/presentation/widgets/'
    'family_add_member_dialog.dart',
  ).readAsStringSync();

  test('member form omits occupation and delivery address controls', () {
    expect(dialogSource, isNot(contains('_occupationController')));
    expect(dialogSource, isNot(contains('family_occupation')));
    expect(dialogSource, isNot(contains('family_address_select')));
    expect(dialogSource, isNot(contains('_selectedAddressId')));
  });

  test('relationship is a text field and gender has the correct label', () {
    expect(dialogSource, contains('_relationshipController'));
    expect(dialogSource, isNot(contains('DropdownButton<String>')));
    expect(dialogSource, contains('l10n.family_gender'));
  });

  test('member save uses the shared progress indicator and snackbar', () {
    expect(dialogSource, contains('custom_progress_indecator.dart'));
    expect(dialogSource, contains('custom_snak_bar.dart'));
    expect(dialogSource, contains('CustomProgressIndicator'));
    expect(dialogSource, contains('CustomSnackbar.showSuccess'));
  });
}
