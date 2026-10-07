import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/subscription_billing_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_action_type.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';

void main() {
  group('SubscriptionBillingFreezeResponseDto and Mapper Tests', () {
    test('deserializes exact backend JSON response correctly', () {
      final json = {
        'id': '9a38f712-8812-4c21-9988-123456789abc',
        'subscriptionId': '2d877030-dbbf-4160-9a7a-4602784c3215',
        'freezeStartDate': '2026-09-07',
        'freezeEndDate': '2026-09-13',
        'freezeDays': 7,
        'reason': 'سفر مؤقت',
        'status': 'Approved',
        'approvedByUserId': null,
        'processedAtUtc': '2026-09-03T16:26:00Z',
        'createdAtUtc': '2026-09-03T16:26:00Z',
      };

      final dto = SubscriptionBillingFreezeResponseDto.fromJson(json);

      expect(dto.id, '9a38f712-8812-4c21-9988-123456789abc');
      expect(dto.subscriptionId, '2d877030-dbbf-4160-9a7a-4602784c3215');
      expect(dto.freezeStartDate, '2026-09-07');
      expect(dto.freezeEndDate, '2026-09-13');
      expect(dto.freezeDays, 7);
      expect(dto.reason, 'سفر مؤقت');
      expect(dto.status, 'Approved');
      expect(dto.approvedByUserId, isNull);
      expect(dto.processedAtUtc, '2026-09-03T16:26:00Z');
      expect(dto.createdAtUtc, '2026-09-03T16:26:00Z');
    });

    test('maps DTO to Domain Entity with safe defaults', () {
      const dto = SubscriptionBillingFreezeResponseDto(
        id: '123',
        subscriptionId: 'sub-456',
        freezeStartDate: '2026-09-07',
        freezeEndDate: '2026-09-13',
        freezeDays: 7,
        reason: 'Holiday',
        status: 'Approved',
      );

      final entity = dto.toEntity();

      expect(entity.id, '123');
      expect(entity.subscriptionId, 'sub-456');
      expect(entity.freezeStartDate, '2026-09-07');
      expect(entity.freezeEndDate, '2026-09-13');
      expect(entity.freezeDays, 7);
      expect(entity.reason, 'Holiday');
      expect(entity.status, 'Approved');
      expect(entity.approvedByUserId, isNull);
      expect(entity.processedAtUtc, '');
      expect(entity.createdAtUtc, '');
    });

    test(
      'SubscriptionBillingActionState stores freezeResult and clears it correctly',
      () {
        const dto = SubscriptionBillingFreezeResponseDto(
          id: '123',
          subscriptionId: 'sub-456',
          freezeStartDate: '2026-09-07',
          freezeEndDate: '2026-09-13',
          freezeDays: 7,
          reason: 'Holiday',
          status: 'Approved',
        );
        final entity = dto.toEntity();

        var state = const SubscriptionBillingActionState();
        expect(state.freezeResult, isNull);

        state = state.copyWith(
          type: SubscriptionBillingActionType.freeze,
          isSuccess: true,
          freezeResult: entity,
        );
        expect(state.freezeResult, isNotNull);
        expect(state.freezeResult?.id, '123');

        state = state.copyWith(clearFreezeResult: true);
        expect(state.freezeResult, isNull);
      },
    );

    test('maps freeze details response current freeze and history', () {
      final dto = SubscriptionBillingFreezeDetailsResponseDto.fromJson({
        'subscriptionId': 'sub-1',
        'subscriptionStatus': 'Scheduled',
        'subscriptionStatusNameAr': 'scheduled ar',
        'hasFreeze': true,
        'isCurrentlyFrozen': false,
        'currentFreeze': {
          'requestId': 'freeze-1',
          'startDate': '2026-09-07',
          'endDate': '2026-09-12',
          'freezeDays': 6,
          'frozenServiceDaysCount': 5,
          'status': 'Approved',
          'statusNameAr': 'approved ar',
          'isCurrentlyActive': false,
          'isUpcoming': true,
          'reason': 'travel',
          'createdAtUtc': '2026-09-03T14:18:47.743613Z',
          'processedAtUtc': '2026-09-03T14:18:47.743302Z',
          'frozenServiceDates': ['2026-09-07', '2026-09-08'],
          'compensationDates': ['2026-09-20', '2026-09-21'],
          'subscriptionEndDate': '2026-09-24',
          'summaryAr': 'summary ar',
          'summaryEn': 'summary en',
        },
        'freezeHistory': [
          {
            'requestId': 'freeze-1',
            'startDate': '2026-09-07',
            'endDate': '2026-09-12',
            'freezeDays': 6,
            'status': 'Approved',
            'statusNameAr': 'approved ar',
            'reason': 'travel',
            'createdAtUtc': '2026-09-03T14:18:47.743613Z',
            'processedAtUtc': '2026-09-03T14:18:47.743302Z',
          },
        ],
        'noticeAr': 'notice ar',
        'noticeEn': 'notice en',
      });

      final entity = dto.toEntity();

      expect(entity.subscriptionId, 'sub-1');
      expect(entity.hasFreeze, isTrue);
      expect(entity.isCurrentlyFrozen, isFalse);
      expect(entity.currentFreeze?.requestId, 'freeze-1');
      expect(entity.currentFreeze?.frozenServiceDates, [
        '2026-09-07',
        '2026-09-08',
      ]);
      expect(entity.freezeHistory.single.statusNameAr, 'approved ar');
      expect(entity.noticeAr, 'notice ar');
      expect(entity.noticeEn, 'notice en');
    });
  });
}
