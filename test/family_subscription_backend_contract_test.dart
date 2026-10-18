import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/mapper/family_subscription_setup_mapper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_lookup_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_member_lookup_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_member_response_dto.dart';
import 'package:meal_meat_user/features/family_package_days/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/features/family_programs/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/family_programs/data/mapper/subscription_bundle_mapper.dart';

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

    test('maps the expanded current family response', () {
      final entity = FamilyFlowCurrentResponseDto.fromJson({
        'familyGroupId': 'family-1',
        'name': 'My family',
        'status': 'Draft',
        'packageName': 'Family package',
        'members': [
          {
            'memberId': 'member-1',
            'role': 'Manager',
            'displayName': 'Ahmed',
            'relationshipCode': 'self',
            'gender': 'Male',
            'ageYears': 30,
            'setupStatus': 'NotStarted',
            'includeFriday': false,
            'isCurrentUser': true,
            'deliveryAddress': {
              'id': 'address-1',
              'label': 'Home',
              'addressLine': 'Salmiya, block 4',
              'regionId': 'region-1',
              'latitude': 29.34,
              'longitude': 48.07,
              'isDefault': true,
              'notifyOnDelivery': true,
            },
            'allergies': [],
            'allergiesCompleted': true,
            'dislikedFoods': [],
            'dietaryPreferences': [],
            'dietaryCompleted': false,
            'hasNoAllergies': true,
            'hasNoDietaryRestriction': false,
          },
        ],
      }).toEntity();

      final member = entity.members.single;
      expect(entity.packageName('en'), 'Family package');
      expect(member.role, 1);
      expect(member.gender, 1);
      expect(member.setupStatus, 0);
      expect(member.deliveryAddress?.addressId, 'address-1');
      expect(member.deliveryAddress?.addressLine, 'Salmiya, block 4');
      expect(member.allergies, isEmpty);
      expect(member.dislikedFoods, isEmpty);
      expect(member.dietaryPreferences, isEmpty);
      expect(member.allergiesCompleted, isTrue);
      expect(member.dietaryCompleted, isFalse);
      expect(member.hasNoAllergies, isTrue);
      expect(member.hasNoDietaryRestriction, isFalse);
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

    test('reset plan sends explicit nulls for the four pricing fields', () {
      expect(FamilyMemberPlanWriteRequestDto.clear().toJson(), {
        'programId': null,
        'bundleId': null,
        'tier': null,
        'durationDays': null,
      });
    });

    test('add member omits phone when it is absent', () {
      expect(
        const FamilyMemberWriteRequestDto(
          displayName: 'Sara',
          relationshipCode: 'spouse',
          gender: 2,
          ageYears: 28,
        ).toJson(),
        {
          'displayName': 'Sara',
          'relationshipCode': 'spouse',
          'gender': 2,
          'ageYears': 28,
        },
      );
    });
  });

  test('maps every documented member setup status', () {
    for (final entry in const {
      'NotStarted': 0,
      'InProgress': 1,
      'Ready': 2,
    }.entries) {
      final dto = FamilyMemberResponseDto.fromJson({
        'memberId': 'member',
        'setupStatus': entry.key,
      });
      expect(dto.setupStatus, entry.value);
    }
  });

  test('parses family program bundle with availability and badge correctly', () {
    final availableJson = {
      'bundleId': 'ae827912-199d-49e8-b1fc-3390fc96b2e6',
      'programId': 'dd12dfbc-3987-4e38-83af-664b6963c04c',
      'code': 'PKG-BL1S',
      'nameAr': 'ريوق + غداء + سناك',
      'description': 'ريوق + غداء + سناك',
      'imageUrl': null,
      'mealsPerDay': 3,
      'breakfastCount': 1,
      'lunchCount': 1,
      'dinnerCount': 0,
      'snackCount': 1,
      'slotRequirements': [
        {'slot': 'breakfast', 'count': 1},
        {'slot': 'lunch', 'count': 1},
        {'slot': 'snack', 'count': 1},
      ],
      'sortOrder': 1,
      'descriptionAr': 'ريوق + غداء + سناك',
      'slots': [
        {'code': 'breakfast', 'nameAr': 'الإفطار', 'quantity': 1, 'name': 'الإفطار'},
        {'code': 'lunch', 'nameAr': 'الغداء', 'quantity': 1, 'name': 'الغداء'},
        {'code': 'snack', 'nameAr': 'سناك', 'quantity': 1, 'name': 'سناك'},
      ],
      'restaurantCount': 4,
      'restaurants': [
        {
          'restaurantId': 'f8575d1f-943e-455b-bd45-12b5af4eb097',
          'logoUrl': 'https://ik.imagekit.io/f7h9cj23x/catalog/restaurants/logo-diet-care.png',
        },
      ],
      'selectionCount': 53,
      'isMostSelected': true,
      'badge': {
        'code': 'MOST_SELECTED',
        'nameAr': 'الأكثر اختيارًا',
        'name': 'الأكثر اختيارًا',
      },
      'availability': {
        'scope': 'coverage',
        'status': 'selection_required',
        'canSelect': true,
        'coveredRestaurantCount': 4,
        'eligibleRestaurantCount': null,
        'messageCode': null,
      },
      'name': 'ريوق + غداء + سناك',
    };

    final unavailableJson = {
      'bundleId': 'f3c1c948-d6eb-470c-93eb-42b71113c64f',
      'programId': 'dd12dfbc-3987-4e38-83af-664b6963c04c',
      'code': 'PKG-LD2S',
      'nameAr': 'غداء + عشاء + ٢ سناك',
      'description': 'غداء + عشاء + ٢ سناك',
      'imageUrl': null,
      'mealsPerDay': 4,
      'breakfastCount': 0,
      'lunchCount': 1,
      'dinnerCount': 1,
      'snackCount': 2,
      'slotRequirements': [
        {'slot': 'lunch', 'count': 1},
        {'slot': 'dinner', 'count': 1},
        {'slot': 'snack', 'count': 2},
      ],
      'sortOrder': 2,
      'descriptionAr': 'غداء + عشاء + ٢ سناك',
      'slots': [
        {'code': 'lunch', 'nameAr': 'الغداء', 'quantity': 1, 'name': 'الغداء'},
        {'code': 'dinner', 'nameAr': 'العشاء', 'quantity': 1, 'name': 'العشاء'},
        {'code': 'snack', 'nameAr': 'سناك', 'quantity': 2, 'name': 'سناك'},
      ],
      'restaurantCount': 0,
      'restaurants': <Map<String, dynamic>>[],
      'selectionCount': 0,
      'isMostSelected': false,
      'badge': null,
      'availability': {
        'scope': 'coverage',
        'status': 'no_restaurants_for_selection',
        'canSelect': false,
        'coveredRestaurantCount': 4,
        'eligibleRestaurantCount': null,
        'messageCode': 'subscription_flow.no_prepared_restaurants',
      },
      'name': 'غداء + عشاء + ٢ سناك',
    };

    final availableDto = FamilyBundleResponseDto.fromJson(availableJson);
    final availableEntity = availableDto.toEntity();
    expect(availableEntity.canSelect, isTrue);
    expect(availableEntity.badge?.name('ar'), 'الأكثر اختيارًا');
    expect(availableEntity.badge?.name('en'), 'الأكثر اختيارًا');
    expect(availableEntity.restaurantCount, 4);

    final unavailableDto = FamilyBundleResponseDto.fromJson(unavailableJson);
    final unavailableEntity = unavailableDto.toEntity();
    expect(unavailableEntity.canSelect, isFalse);
    expect(
      unavailableEntity.disabledReason,
      'subscription_flow.no_prepared_restaurants',
    );
  });
}
