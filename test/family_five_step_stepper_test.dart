import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('family stepper contains five setup stages after family creation', () {
    final source = File(
      'lib/features/family_shared/presentation/widgets/'
      'family_program_stepper.dart',
    ).readAsStringSync();

    expect(source, contains('family_step_program'));
    expect(source, contains('family_step_location'));
    expect(source, contains('family_step_allergies'));
    expect(source, contains('family_step_package_days'));
    expect(source, contains('family_step_payment'));
    expect(
      source,
      contains('final stepCount = includeFamilyCreationStep ? 6 : 5'),
    );
  });

  test('family screens select their matching step', () {
    final locationSource = File(
      'lib/features/addresses/presentation/widgets/sections/'
      'address_choose_location_stepper_section.dart',
    ).readAsStringSync();
    final allergySource = File(
      'lib/features/family_allergies/presentation/widgets/'
      'family_allergies_header.dart',
    ).readAsStringSync();
    final packageSource = File(
      'lib/features/family_package_days/presentation/widgets/'
      'family_package_days_content.dart',
    ).readAsStringSync();
    final paymentSource = File(
      'lib/features/family_summary/presentation/widgets/'
      'family_summary_content.dart',
    ).readAsStringSync();

    expect(locationSource, contains('currentStep: 2'));
    expect(allergySource, contains('currentStep: 3'));
    expect(packageSource, contains('currentStep: 4'));
    expect(paymentSource, contains('currentStep: 5'));
  });
}
