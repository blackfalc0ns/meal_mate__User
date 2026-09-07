import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('family plan continues to allergies before member addresses', () {
    final source = File(
      'lib/features/family_package_days/presentation/screens/'
      'family_package_days_setup_screen.dart',
    ).readAsStringSync();

    expect(source, contains('AppRoutes.familyAllergies'));
    expect(source, isNot(contains('AppRoutes.familyAddresses')));
  });

  test('family address editor receives the current member id', () {
    final source = File(
      'lib/features/addresses/presentation/screens/'
      'address_choose_location_screen.dart',
    ).readAsStringSync();

    expect(source, contains('this.familyMemberId'));
    expect(source, contains('configureFamilyMember'));
  });

  test('family addresses continue to payment after the last member', () {
    final source = File(
      'lib/features/family_addresses/presentation/screens/'
      'family_addresses_screen.dart',
    ).readAsStringSync();

    expect(source, contains('AppRoutes.familyPaymentSetup'));
    expect(source, isNot(contains('AppRoutes.familyAllergies')));
  });

  test('family allergies require a selection and continue to addresses', () {
    final source = File(
      'lib/features/family_allergies/presentation/screens/'
      'family_allergies_screen.dart',
    ).readAsStringSync();

    expect(source, contains('AppRoutes.familyAddresses'));
    expect(source, isNot(contains('AppRoutes.familyPaymentSetup')));
    expect(source, isNot(contains('family_skip')));
  });

  test('family allergies use the Figma allergy and preference sections', () {
    final source = File(
      'lib/features/family_allergies/presentation/widgets/'
      'family_allergies_content.dart',
    ).readAsStringSync();

    expect(source, contains('FamilyAllergySelectionSection'));
    expect(source, contains('FamilyNoAllergiesTile'));
    expect(source, contains('FamilyAllergiesInformationNote'));
    expect(source, contains('FamilyAllergiesActions'));
    expect(source, isNot(contains('FilterChip(')));
  });
}
