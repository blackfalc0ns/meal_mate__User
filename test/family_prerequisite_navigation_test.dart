import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('family map starts below the setup steps and member strip', () {
    final source = File(
      'lib/features/family_addresses/presentation/screens/family_addresses_screen.dart',
    ).readAsStringSync();

    expect(source, contains('FamilyProgramMemberStrip('));
    expect(source, contains('child: FamilyAddressLocationStage('));
    expect(source, contains('FamilyAddressLocationStage('));
    expect(source, isNot(contains('fit: StackFit.expand')));
    expect(source, isNot(contains('CustomBackButton(')));
  });

  test('family program continues to member addresses', () {
    final source = File(
      'lib/features/family_programs/presentation/screens/'
      'family_program_setup_screen.dart',
    ).readAsStringSync();

    expect(source, contains('AppRoutes.familyAddresses'));
    expect(source, contains('!current.isPlanSaving'));
    expect(source, isNot(contains('AppRoutes.familyPackageDaysSetup')));
  });

  test('family plan continues to payment', () {
    final source = File(
      'lib/features/family_package_days/presentation/screens/'
      'family_package_days_setup_screen.dart',
    ).readAsStringSync();

    expect(source, contains('AppRoutes.familyPaymentSetup'));
    expect(source, isNot(contains('AppRoutes.familyAllergies')));
  });

  test('family address stage embeds the map without route navigation', () {
    final source = File(
      'lib/features/family_addresses/presentation/screens/'
      'family_addresses_screen.dart',
    ).readAsStringSync();

    expect(source, contains('FamilyAddressLocationStage'));
    expect(source, contains('FamilyProgramStepper'));
    expect(source, isNot(contains('AppRoutes.addressChooseLocation')));
  });

  test('family addresses continue to allergies after the last member', () {
    final source = File(
      'lib/features/family_addresses/presentation/screens/'
      'family_addresses_screen.dart',
    ).readAsStringSync();

    expect(source, contains('AppRoutes.familyAllergies'));
    expect(source, contains('context.pushNamed(AppRoutes.familyAllergies)'));
    expect(
      source,
      isNot(contains('pushReplacementNamed(AppRoutes.familyAllergies)')),
    );
    expect(source, isNot(contains('AppRoutes.familyPaymentSetup')));
  });

  test(
    'family allergies require a selection and continue to package setup',
    () {
      final source = File(
        'lib/features/family_allergies/presentation/screens/'
        'family_allergies_screen.dart',
      ).readAsStringSync();

      expect(source, contains('AppRoutes.familyPackageDaysSetup'));
      expect(
        source,
        contains('context.pushNamed(AppRoutes.familyPackageDaysSetup)'),
      );
      expect(
        source,
        isNot(
          contains('pushReplacementNamed(AppRoutes.familyPackageDaysSetup)'),
        ),
      );
      expect(source, isNot(contains('AppRoutes.familyPaymentSetup')));
      expect(source, isNot(contains('family_skip')));
    },
  );

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

  test(
    'family allergies switch members locally and shimmer only initially',
    () {
      final contentSource = File(
        'lib/features/family_allergies/presentation/widgets/'
        'family_allergies_content.dart',
      ).readAsStringSync();
      final screenSource = File(
        'lib/features/family_allergies/presentation/screens/'
        'family_allergies_screen.dart',
      ).readAsStringSync();
      final viewModelSource = File(
        'lib/features/family_allergies/presentation/manager/'
        'family_allergies_view_model.dart',
      ).readAsStringSync();

      expect(contentSource, contains('onSelectMember: viewModel.selectMember'));
      expect(viewModelSource, contains('void selectMember(int index)'));
      expect(screenSource, contains('FamilyAllergiesLoadingSkeleton'));
      expect(screenSource, isNot(contains('LoadingWidget.fullScreen')));
    },
  );

  test('location and allergies do not require checkout basket eligibility', () {
    final addressesSource = File(
      'lib/features/family_addresses/presentation/manager/'
      'family_addresses_view_model.dart',
    ).readAsStringSync();
    final allergiesSource = File(
      'lib/features/family_allergies/presentation/manager/'
      'family_allergies_view_model.dart',
    ).readAsStringSync();

    expect(addressesSource, isNot(contains('isInCheckoutBasket')));
    expect(allergiesSource, isNot(contains('isInCheckoutBasket')));
  });
}
