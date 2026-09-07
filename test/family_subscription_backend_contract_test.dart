import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/mapper/family_subscription_setup_mapper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_lookup_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_member_lookup_response_dto.dart';
import 'package:meal_meat_user/features/family_package_days/data/models/request/family_member_plan_write_request_dto.dart';

void main() {
  group('family subscription backend contract', () {
    test('maps documented family statuses', () {
      for (final entry in const {
        'Draft': 1,
        'CheckoutPending': 2,
        'Active': 3,
      }.entries) {
        final dto = FamilyFlowCurrentResponseDto.fromJson({
          'status': entry.key,
        });

        expect(dto.status, entry.value);
      }
    });

    test('maps member subscription identity and contact fields', () {
      final entity = FamilyFlowCurrentResponseDto.fromJson({
        'members': [
          {
            'memberId': 'member-1',
            'memberSubscriptionId': 'subscription-1',
            'phoneNumber': '+96551111111',
            'occupation': 'Engineer',
            'startDate': '2026-09-20',
          },
        ],
      }).toEntity();

      expect(entity.members.single.memberSubscriptionId, 'subscription-1');
      expect(entity.members.single.phoneNumber, '+96551111111');
      expect(entity.members.single.occupation, 'Engineer');
      expect(entity.members.single.startDate, '2026-09-20');
    });

    test('serializes lookup and member write requests exactly', () {
      expect(
        const FamilyMemberLookupRequestDto(phone: '+96551111111').toJson(),
        {'phone': '+96551111111'},
      );
      expect(
        const FamilyMemberWriteRequestDto(
          phone: '+96551111111',
          displayName: 'Sara Ahmed',
          occupation: 'Engineer',
          relationshipCode: 'spouse',
          gender: 2,
          ageYears: 30,
        ).toJson(),
        {
          'phone': '+96551111111',
          'displayName': 'Sara Ahmed',
          'occupation': 'Engineer',
          'relationshipCode': 'spouse',
          'gender': 2,
          'ageYears': 30,
        },
      );
    });

    test('parses found and missing phone lookup responses', () {
      final found = FamilyMemberLookupResponseDto.fromJson({
        'found': true,
        'displayName': 'Sara Ahmed',
        'ageYears': 30,
        'gender': 2,
      }).toEntity();
      final missing = FamilyMemberLookupResponseDto.fromJson({
        'found': false,
        'displayName': null,
        'ageYears': null,
        'gender': null,
      }).toEntity();

      expect(found.found, isTrue);
      expect(found.displayName, 'Sara Ahmed');
      expect(found.ageYears, 30);
      expect(found.gender, 2);
      expect(missing.found, isFalse);
      expect(missing.displayName, isNull);
    });

    test('serializes optional family plan start date using ISO date', () {
      expect(
        const FamilyMemberPlanWriteRequestDto(
          bundleId: 'bundle-1',
          durationDays: 26,
          includeFriday: false,
          tier: 2,
          startDate: '2026-09-20',
        ).toJson(),
        {
          'bundleId': 'bundle-1',
          'tier': 2,
          'durationDays': 26,
          'includeFriday': false,
          'startDate': '2026-09-20',
        },
      );
    });
  });
}
