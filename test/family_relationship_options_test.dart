import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/models/family_relationship_options.dart';

void main() {
  const primaryCode = '586f0221-19a5-418e-8094-4bd955c7375e';

  test('keeps the edited member relationship in the dropdown options', () {
    const relationships = [
      FamilyRelationshipEntity(
        code: primaryCode,
        nameAr: 'مدير الأسرة',
        nameEn: 'Family manager',
        forDependents: false,
        isPrimary: true,
      ),
      FamilyRelationshipEntity(
        code: 'child',
        nameAr: 'ابن',
        nameEn: 'Child',
        forDependents: true,
        isPrimary: false,
      ),
    ];

    final options = buildFamilyRelationshipOptions(
      relationships,
      selectedCode: primaryCode,
    );

    expect(options.map((option) => option.code), [primaryCode, 'child']);
  });

  test('returns one dropdown option for each non-empty code', () {
    const relationships = [
      FamilyRelationshipEntity(
        code: 'child',
        nameAr: 'ابن',
        nameEn: 'Child',
        forDependents: true,
        isPrimary: false,
      ),
      FamilyRelationshipEntity(
        code: 'child',
        nameAr: 'طفل',
        nameEn: 'Child duplicate',
        forDependents: true,
        isPrimary: false,
      ),
      FamilyRelationshipEntity(
        code: '',
        nameAr: '',
        nameEn: '',
        forDependents: true,
        isPrimary: false,
      ),
    ];

    final options = buildFamilyRelationshipOptions(relationships);

    expect(options.map((option) => option.code), ['child']);
  });

  test('falls back when the selected code is not an available option', () {
    const relationships = [
      FamilyRelationshipEntity(
        code: 'child',
        nameAr: 'ابن',
        nameEn: 'Child',
        forDependents: true,
        isPrimary: false,
      ),
    ];

    expect(
      resolveFamilyRelationshipSelection(
        relationships,
        selectedCode: 'missing',
      ),
      'child',
    );
  });

  test('keeps an exact selected code that contains surrounding spaces', () {
    const relationship = FamilyRelationshipEntity(
      code: ' primary ',
      nameAr: 'مدير الأسرة',
      nameEn: 'Family manager',
      forDependents: false,
      isPrimary: true,
    );

    final options = buildFamilyRelationshipOptions(const [
      relationship,
    ], selectedCode: relationship.code);

    expect(options, [same(relationship)]);
  });

  test('add mode never admits a non-dependent duplicate', () {
    const primary = FamilyRelationshipEntity(
      code: 'child',
      nameAr: 'أساسي',
      nameEn: 'Primary',
      forDependents: false,
      isPrimary: true,
    );
    const dependent = FamilyRelationshipEntity(
      code: 'child',
      nameAr: 'ابن',
      nameEn: 'Child',
      forDependents: true,
      isPrimary: false,
    );

    final options = buildFamilyRelationshipOptions(
      const [primary, dependent],
      selectedCode: 'child',
      includeSelectedRelationship: false,
    );

    expect(options, [same(dependent)]);
  });
}
