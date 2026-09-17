import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/family_management_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_home_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_access_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_detail_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_permissions_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_summary_response_dto.dart';

void main() {
  test('parses live family home string status and roles', () {
    final dto = FamilyHomeResponseDto.fromJson(const {
      'groupId': '6054b736-4ba5-40ac-90bb-8f2f0f64f62a',
      'name': 'Family',
      'status': 'Active',
      'packageLabelAr': 'باقة عائلية',
      'quotedFinalPrice': 100.8,
      'currencyCode': 'KWD',
      'members': [
        {
          'memberId': 'manager-1',
          'displayName': 'Manager',
          'role': 'Manager',
          'todayFilledCount': null,
          'todayRequiredCount': 4,
          'programLabel': 'كيتو',
        },
        {
          'memberId': 'member-1',
          'displayName': 'Member',
          'role': 'Member',
          'todayFilledCount': null,
          'todayRequiredCount': 2,
        },
      ],
    });

    final entity = dto.toEntity('ar');

    expect(entity.status, 1);
    expect(entity.members.first.isManager, isTrue);
    expect(entity.members.last.isManager, isFalse);
    expect(entity.members.first.todayFilledCount, 0);
    expect(entity.members.first.programName, 'كيتو');
  });

  test('maps family home and keeps only enabled shortcuts', () {
    final dto = FamilyHomeResponseDto.fromJson(const {
      'groupId': 'group-1',
      'name': 'Ahmed family',
      'quotedFinalPrice': 37.5,
      'currencyCode': 'KWD',
      'shortcuts': [
        {'code': 'calendar', 'enabled': true},
        {'code': 'wallet', 'enabled': false},
      ],
      'members': [
        {
          'memberId': 'member-1',
          'displayName': 'Yousef',
          'memberSubscriptionId': 'subscription-1',
          'remainingDays': 7,
        },
      ],
    });

    final entity = dto.toEntity('en');

    expect(entity.groupId, 'group-1');
    expect(entity.price, 37.5);
    expect(entity.shortcuts.map((item) => item.code), ['calendar']);
    expect(entity.members.single.subscriptionId, 'subscription-1');
  });

  test('maps member summaries defensively and identifies missing plan', () {
    final dto = FamilyMemberSummaryResponseDto.fromJson(const {
      'memberId': 'member-1',
      'displayName': 'Yousef',
      'setupStatus': 2,
      'memberSubscriptionId': null,
    });

    final entity = dto.toEntity('en');

    expect(entity.memberId, 'member-1');
    expect(entity.hasPlan, isFalse);
    expect(entity.displayName, 'Yousef');
  });

  test('parses live members string setup status and generic program name', () {
    final dto = FamilyMemberSummaryResponseDto.fromJson(const {
      'memberId': 'member-1',
      'displayName': 'Member',
      'role': 'Member',
      'ageYears': 23,
      'memberSubscriptionId': 'subscription-1',
      'programName': 'Balanced lifestyle',
      'remainingDays': 14,
      'setupStatus': 'Ready',
    });

    final entity = dto.toEntity('en');

    expect(entity.setupStatus, 2);
    expect(entity.programName, 'Balanced lifestyle');
    expect(entity.isManager, isFalse);
  });

  test('maps member details and nullable today nutrition', () {
    final dto = FamilyMemberDetailResponseDto.fromJson(const {
      'memberId': 'member-1',
      'displayName': 'Yousef',
      'memberSubscriptionId': 'subscription-1',
      'canRenew': true,
      'renewalPath':
          '/api/v1/customer/subscriptions/subscription-1/renewal-requests',
      'todayNutrition': null,
    });

    final entity = dto.toEntity('en');

    expect(entity.subscriptionId, 'subscription-1');
    expect(entity.canRenew, isTrue);
    expect(entity.todayNutrition, isNull);
  });

  test('access request omits fields that did not change', () {
    const request = FamilyMemberAccessRequestDto(isPaused: true);

    expect(request.toJson(), {'isPaused': true});
  });

  test(
    'access response keeps generated password for one-time presentation',
    () {
      final dto = FamilyMemberAccessResponseDto.fromJson(const {
        'memberId': 'member-1',
        'hasSeparateAccount': true,
        'generatedPassword': 'one-time-password',
      });

      expect(dto.toEntity().generatedPassword, 'one-time-password');
    },
  );

  test('permissions request writes all eight root toggles and no groups', () {
    const request = FamilyMemberPermissionsRequestDto(
      editDailyMeals: true,
      changeDeliveryTime: false,
      viewProgram: true,
      changeProgram: false,
      editMealsAndDays: false,
      editAddress: false,
      unitExchange: false,
      changePassword: false,
    );

    expect(request.toJson(), hasLength(8));
    expect(request.toJson(), isNot(contains('groups')));
  });

  test('permission groups retain backend order and keys', () {
    final dto = FamilyMemberPermissionsResponseDto.fromJson(const {
      'memberId': 'member-1',
      'groups': [
        {
          'code': 'meals',
          'labelAr': 'الوجبات',
          'labelEn': 'Meals',
          'permissions': [
            {
              'key': 'editDailyMeals',
              'labelAr': 'تعديل الوجبات اليومية',
              'labelEn': 'Edit daily meals',
              'value': true,
            },
          ],
        },
      ],
    });

    final entity = dto.toEntity('en');
    expect(entity.groups.single.code, 'meals');
    expect(entity.groups.single.permissions.single.key, 'editDailyMeals');
    expect(entity.groups.single.permissions.single.value, isTrue);
  });
}
