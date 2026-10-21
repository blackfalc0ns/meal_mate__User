import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_management/member/data/mapper/family_member_request_mapper.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/update_family_member_access_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/update_family_member_permissions_request_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_write_request_entity.dart';

void main() {
  test(
    'access request keeps false flags and credential operation key on the wire',
    () {
      const request = UpdateFamilyMemberAccessRequestEntity(
        hasSeparateAccount: false,
        generateTemporaryPassword: true,
        credentialOperationKey: 'retry-key',
      );
      expect(request.toDto().toJson(), {
        'removeAccess': false,
        'hasSeparateAccount': false,
        'generateTemporaryPassword': true,
        'credentialOperationKey': 'retry-key',
      });
    },
  );
  test(
    'permission patch preserves version and false values while excluding obsolete keys',
    () {
      const request = UpdateFamilyMemberPermissionsRequestEntity(
        expectedVersion: 8,
        patch: {
          'editDailyMeals': false,
          'changeProgram': true,
          'changeDeliveryTime': true,
        },
      );
      expect(request.toDto().toJson(), {
        'expectedVersion': 8,
        'editDailyMeals': false,
      });
    },
  );
  test(
    'basic info request preserves fields and omits absent optional values',
    () {
      const request = FamilyMemberWriteRequestEntity(
        displayName: 'Member',
        relationshipCode: 'child',
        gender: 1,
        ageYears: 12,
        occupation: 'Student',
      );
      expect(request.toDto().toJson(), {
        'displayName': 'Member',
        'relationshipCode': 'child',
        'gender': 1,
        'ageYears': 12,
        'occupation': 'Student',
      });
    },
  );
}
