import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_allergies/data/models/request/family_member_allergies_request_dto.dart';

void main() {
  test('NONE is sent as a real family allergy selection', () {
    expect(
      const FamilyMemberAllergiesRequestDto(
        allergies: [FamilyMemberAllergyRequestDto(code: 'NONE')],
      ).toJson(),
      {
        'allergies': [
          {'code': 'NONE'},
        ],
      },
    );
  });

  test('allergen severity is included when selected', () {
    expect(
      const FamilyMemberAllergiesRequestDto(
        allergies: [
          FamilyMemberAllergyRequestDto(code: 'MILK', severity: 'High'),
        ],
      ).toJson(),
      {
        'allergies': [
          {'code': 'MILK', 'severity': 'High'},
        ],
      },
    );
  });
}
