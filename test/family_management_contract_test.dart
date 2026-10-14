import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_access_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_permissions_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/family_management_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';

void main() {
  group('Family Management, Capabilities, and Conflict Safety Tests', () {
    test('FamilyMemberPermissionsRequestDto serializes expectedVersion and 8 root toggles', () {
      const dto = FamilyMemberPermissionsRequestDto(
        editDailyMeals: true,
        changeDeliveryTime: false,
        viewProgram: true,
        changeProgram: false,
        editMealsAndDays: true,
        editAddress: false,
        unitExchange: true,
        changePassword: true,
        expectedVersion: 4,
      );

      final json = dto.toJson();
      expect(json['expectedVersion'], 4);
      expect(json['editDailyMeals'], isTrue);
      expect(json['changeDeliveryTime'], isFalse);
      expect(json['viewProgram'], isTrue);
      expect(json['changeProgram'], isFalse);
      expect(json['editMealsAndDays'], isTrue);
      expect(json['editAddress'], isFalse);
      expect(json['unitExchange'], isTrue);
      expect(json['changePassword'], isTrue);
    });

    test('FamilyMemberAccessRequestDto serializes expectedVersion and access pause', () {
      const dto = FamilyMemberAccessRequestDto(
        hasSeparateAccount: true,
        isPaused: true,
        expectedVersion: 7,
      );

      final json = dto.toJson();
      expect(json['expectedVersion'], 7);
      expect(json['hasSeparateAccount'], isTrue);
      expect(json['isPaused'], isTrue);
    });

    test('FamilyMemberPermissionsResponseDto parses version and maps to entity', () {
      final dto = FamilyMemberPermissionsResponseDto.fromJson({
        'memberId': 'mem-100',
        'currentVersion': 3,
        'editDailyMeals': true,
        'changeDeliveryTime': false,
        'viewProgram': true,
        'changeProgram': false,
        'editMealsAndDays': true,
        'editAddress': false,
        'unitExchange': false,
        'changePassword': true,
        'groups': [
          {
            'code': 'meals',
            'labelAr': 'الوجبات',
            'labelEn': 'Meals',
            'permissions': [
              {
                'key': 'editDailyMeals',
                'labelAr': 'تعديل الوجبات اليومية',
                'labelEn': 'Edit Daily Meals',
                'value': true,
              }
            ],
          }
        ],
      });

      expect(dto.version, 3);
      final entity = dto.toEntity('en');
      expect(entity.memberId, 'mem-100');
      expect(entity.version, 3);
      expect(entity.values['editDailyMeals'], isTrue);
      expect(entity.values['editAddress'], isFalse);
      expect(entity.groups.first.label, 'Meals');
    });

    test('FamilyMemberAccessResponseDto parses version and maps to entity', () {
      final dto = FamilyMemberAccessResponseDto.fromJson({
        'memberId': 'mem-200',
        'version': 8,
        'hasSeparateAccount': true,
        'isPaused': false,
        'hasExistingLogin': true,
      });

      expect(dto.version, 8);
      final entity = dto.toEntity();
      expect(entity.memberId, 'mem-200');
      expect(entity.version, 8);
      expect(entity.hasSeparateAccount, isTrue);
      expect(entity.isPaused, isFalse);
    });

    test('Manager self-management rule: manager role is identified', () {
      const member = FamilyMemberSummaryEntity(
        memberId: 'mgr-1',
        displayName: 'Mom',
        role: 1, // Manager
        ageYears: 35,
        isPaused: false,
        subscriptionId: 'sub-1',
        programName: 'Weight Loss',
        remainingDays: 20,
        setupStatus: 2,
      );

      expect(member.isManager, isTrue);
      expect(member.hasPlan, isTrue);

      const nonManager = FamilyMemberSummaryEntity(
        memberId: 'child-1',
        displayName: 'Kid',
        role: 2, // Member
        ageYears: 10,
        isPaused: false,
        subscriptionId: 'sub-2',
        programName: 'Kids Program',
        remainingDays: 20,
        setupStatus: 2,
      );

      expect(nonManager.isManager, isFalse);
    });
  });
}
