import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_management/overview/data/mapper/family_overview_mapper.dart';
import 'package:meal_meat_user/features/family_management/overview/data/models/response/api/family_home_response_dto.dart';
import 'package:meal_meat_user/features/family_management/overview/data/models/response/api/family_member_summary_response_dto.dart';

void main() {
  group('FamilyManagement serialization & mapping tests', () {
    test(
      'FamilyMemberWriteRequestDto serialization preserves ageYears and excludes nulls',
      () {
        const dto = FamilyMemberWriteRequestDto(
          displayName: 'Ahmad',
          relationshipCode: 'SON',
          gender: 1,
          ageYears: 12,
          phone: null,
        );

        final json = dto.toJson();
        expect(json['displayName'], 'Ahmad');
        expect(json['ageYears'], 12);
        expect(json['gender'], 1);
        expect(json.containsKey('phone'), isFalse);
      },
    );

    test(
      'UpdateFamilyMemberPermissionsRequestDto sends expectedVersion and 8 base flags without groups',
      () {
        const dto = UpdateFamilyMemberPermissionsRequestDto(
          editDailyMeals: true,
          changeDeliveryTime: false,
          viewProgram: true,
          changeProgram: false,
          editMealsAndDays: false,
          editAddress: true,
          unitExchange: false,
          changePassword: false,
          expectedVersion: 4,
          viewCalendar: true,
        );

        final json = dto.toJson();
        expect(json['expectedVersion'], 4);
        expect(json['editDailyMeals'], isTrue);
        expect(json['viewCalendar'], isTrue);
        expect(json.containsKey('groups'), isFalse);
      },
    );

    test(
      'FamilyHomeResponseDto deserializes defensively and maps to home entity',
      () {
        final json = {
          'groupId': 'grp-123',
          'name': 'عائلة أحمد',
          'status': 1,
          'packageLabelAr': 'باقة التوفير',
          'packageLabelEn': 'Saving Package',
          'quotedFinalPrice': 450.0,
          'currencyCode': 'SAR',
          'members': [
            {
              'memberId': 'm-1',
              'displayName': 'سارة',
              'role': 2,
              'isPaused': false,
              'setupStatus': 1,
            },
          ],
        };

        final dto = FamilyHomeResponseDto.fromJson(json);
        expect(dto.groupId, 'grp-123');
        expect(dto.name, 'عائلة أحمد');
        expect(dto.packageLabelAr, 'باقة التوفير');
        expect(dto.quotedFinalPrice, 450.0);
        expect(dto.members?.length, 1);
        expect(dto.members?.first.displayName, 'سارة');

        final entity = FamilyOverviewMapper.toHomeEntity(dto, locale: 'ar');
        expect(entity.groupId, 'grp-123');
        expect(entity.name, 'عائلة أحمد');
        expect(entity.packageName, 'باقة التوفير');
        expect(entity.price, 450.0);
        expect(entity.currencyCode, 'SAR');
      },
    );

    test(
      'FamilyMemberSummaryResponseDto deserializes and maps to member summary entity',
      () {
        final json = {
          'memberId': 'm-1',
          'displayName': 'خالد',
          'role': 1,
          'isPaused': false,
          'memberSubscriptionId': 'sub-curr-1',
          'programNameAr': 'كيتو',
          'remainingDays': 10,
          'setupStatus': 1,
        };

        final dto = FamilyMemberSummaryResponseDto.fromJson(json);
        expect(dto.memberId, 'm-1');
        expect(dto.displayName, 'خالد');

        final entity = FamilyOverviewMapper.toMemberSummaryEntity(
          dto,
          locale: 'ar',
        );
        expect(entity.memberId, 'm-1');
        expect(entity.displayName, 'خالد');
        expect(entity.isManager, isTrue);
        expect(entity.effectiveSubscriptionId, 'sub-curr-1');
        expect(entity.remainingDays, 10);
        expect(entity.programName, 'كيتو');
      },
    );

    test(
      'UpdateFamilyMemberAccessRequestDto serialization includes generateTemporaryPassword only when specified',
      () {
        const dtoWithoutReset = UpdateFamilyMemberAccessRequestDto(
          hasSeparateAccount: true,
        );
        final jsonWithoutReset = dtoWithoutReset.toJson();
        expect(jsonWithoutReset['hasSeparateAccount'], isTrue);
        expect(
          jsonWithoutReset.containsKey('generateTemporaryPassword'),
          isFalse,
        );

        const dtoWithReset = UpdateFamilyMemberAccessRequestDto(
          hasSeparateAccount: true,
          generateTemporaryPassword: true,
        );
        final jsonWithReset = dtoWithReset.toJson();
        expect(jsonWithReset['hasSeparateAccount'], isTrue);
        expect(jsonWithReset['generateTemporaryPassword'], isTrue);
      },
    );
  });
}
