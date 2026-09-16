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

  test('relationship opens the picker and submits its selected code', () {
    expect(dialogSource, contains('_relationshipController'));
    expect(dialogSource, contains('readOnly: true'));
    expect(dialogSource, contains('FamilyRelationshipPickerSheet.show('));
    expect(dialogSource, contains('relationshipCode: relationshipCode'));
    expect(dialogSource, isNot(contains('_resolveRelationshipCode')));
    expect(dialogSource, contains('l10n.family_gender'));
  });

  test('member save uses the shared progress indicator and snackbar', () {
    expect(dialogSource, contains('custom_progress_indecator.dart'));
    expect(dialogSource, contains('custom_snak_bar.dart'));
    expect(dialogSource, contains('CustomProgressIndicator'));
    expect(dialogSource, contains('CustomSnackbar.showSuccess'));
  });
}
