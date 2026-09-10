import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/models/family_member_form_validation.dart';

void main() {
  test('rejects an incomplete phone before submitting a family member', () {
    expect(
      validateFamilyMemberPhone(null),
      FamilyMemberPhoneValidationError.invalid,
    );
    expect(
      validateFamilyMemberPhone('   '),
      FamilyMemberPhoneValidationError.invalid,
    );
  });

  test('accepts a resolved international phone', () {
    expect(validateFamilyMemberPhone('+96551111111'), isNull);
  });

  test('rejects an empty member name', () {
    expect(
      validateFamilyMemberName('   '),
      FamilyMemberNameValidationError.required,
    );
    expect(validateFamilyMemberName('Ahmed'), isNull);
  });

  test('accepts only ages from 1 through 120', () {
    expect(validateFamilyMemberAge(''), FamilyMemberAgeValidationError.invalid);
    expect(
      validateFamilyMemberAge('0'),
      FamilyMemberAgeValidationError.invalid,
    );
    expect(
      validateFamilyMemberAge('323'),
      FamilyMemberAgeValidationError.invalid,
    );
    expect(validateFamilyMemberAge('33'), isNull);
    expect(validateFamilyMemberAge('120'), isNull);
  });
}
