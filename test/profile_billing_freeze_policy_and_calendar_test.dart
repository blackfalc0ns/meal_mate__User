import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/calendar_mapper.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/subscription_billing_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_billing_action_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';

void main() {
  group('Freeze Policy & Request Tests', () {
    test('SubscriptionBillingFreezeRequestDto toJson includes acknowledgeLostSelections when true', () {
      const requestWithAck = SubscriptionBillingFreezeRequestDto(
        startDate: '2026-09-07',
        endDate: '2026-09-12',
        reason: 'Travel',
        acknowledgeLostSelections: true,
      );

      final jsonWithAck = requestWithAck.toJson();
      expect(jsonWithAck['startDate'], '2026-09-07');
      expect(jsonWithAck['endDate'], '2026-09-12');
      expect(jsonWithAck['reason'], 'Travel');
      expect(jsonWithAck['acknowledgeLostSelections'], true);

      const requestWithoutAck = SubscriptionBillingFreezeRequestDto(
        startDate: '2026-09-07',
        endDate: '2026-09-12',
        reason: 'Travel',
      );

      final jsonWithoutAck = requestWithoutAck.toJson();
      expect(jsonWithoutAck['acknowledgeLostSelections'], isNull);
    });

    test('SubscriptionBillingFreezeRequestEntity maps acknowledgeLostSelections to DTO', () {
      const entity = SubscriptionBillingFreezeRequestEntity(
        startDate: '2026-09-07',
        endDate: '2026-09-12',
        reason: 'Travel',
        acknowledgeLostSelections: true,
      );

      final dto = entity.toDto();
      expect(dto.acknowledgeLostSelections, isTrue);

      const defaultEntity = SubscriptionBillingFreezeRequestEntity(
        startDate: '2026-09-07',
        endDate: '2026-09-12',
      );

      final defaultDto = defaultEntity.toDto();
      expect(defaultDto.acknowledgeLostSelections, isNull);
    });

    test('SubscriptionBillingFreezePolicyResponseDto deserializes backend policy with notice', () {
      final json = {
        'defaultDurationDays': 7,
        'startDelayDays': 3,
        'extendSubscriptionEnd': true,
        'earliestAllowedStartDate': '2026-09-06',
        'messageAr': 'يمكن تجميد الاشتراك لمدة حتى 7 أيام...',
        'noticeAr': 'عند تجميد الاشتراك: سيتم تمديد تاريخ انتهاء اشتراكك تلقائياً...',
        'message': 'يمكن تجميد الاشتراك لمدة حتى 7 أيام...',
        'notice': 'عند تجميد الاشتراك: سيتم تمديد تاريخ انتهاء اشتراكك تلقائياً...',
      };

      final dto = SubscriptionBillingFreezePolicyResponseDto.fromJson(json);
      expect(dto.defaultDurationDays, 7);
      expect(dto.startDelayDays, 3);
      expect(dto.extendSubscriptionEnd, isTrue);
      expect(dto.earliestAllowedStartDate, '2026-09-06');
      expect(dto.messageAr, contains('يمكن تجميد'));
      expect(dto.noticeAr, contains('عند تجميد'));
      expect(dto.message, contains('يمكن تجميد'));
      expect(dto.notice, contains('عند تجميد'));

      final entity = dto.toEntity();
      expect(entity.defaultDurationDays, 7);
      expect(entity.noticeAr, contains('عند تجميد'));
      expect(entity.notice, contains('عند تجميد'));
      expect(entity.messageAr, contains('يمكن تجميد'));
    });

    test('SubscriptionBillingActionState stores and clears pending freeze details', () {
      const request = SubscriptionBillingFreezeRequestEntity(
        startDate: '2026-09-07',
        endDate: '2026-09-12',
        reason: 'Holiday',
      );

      var state = const SubscriptionBillingActionState();
      expect(state.pendingFreezeRequest, isNull);
      expect(state.pendingFreezeSubscriptionId, isNull);

      state = state.copyWith(
        type: 'freeze',
        pendingFreezeRequest: request,
        pendingFreezeSubscriptionId: 'sub-123',
      );
      expect(state.pendingFreezeRequest?.startDate, '2026-09-07');
      expect(state.pendingFreezeSubscriptionId, 'sub-123');

      state = state.copyWith(clearPendingFreeze: true);
      expect(state.pendingFreezeRequest, isNull);
      expect(state.pendingFreezeSubscriptionId, isNull);
    });

    test('SubscriptionBillingPendingFreezeResponseDto deserializes exact backend response', () {
      final json = {
        'requestId': '230d3f4f-2aaa-468a-b1d8-a3c754968a5c',
        'startDate': '2026-09-07',
        'endDate': '2026-09-12',
        'freezeDays': 6,
        'status': 'Approved',
      };

      final dto = SubscriptionBillingPendingFreezeResponseDto.fromJson(json);
      expect(dto.requestId, '230d3f4f-2aaa-468a-b1d8-a3c754968a5c');
      expect(dto.startDate, '2026-09-07');
      expect(dto.endDate, '2026-09-12');
      expect(dto.freezeDays, 6);
      expect(dto.status, 'Approved');

      final entity = dto.toEntity();
      expect(entity.requestId, '230d3f4f-2aaa-468a-b1d8-a3c754968a5c');
      expect(entity.startDate, '2026-09-07');
      expect(entity.endDate, '2026-09-12');
      expect(entity.freezeDays, 6);
      expect(entity.status, 'Approved');
    });

    test('SubscriptionBillingActionsResponseDto maps actions correctly', () {
      final json = {
        'canRenew': true,
        'canFreeze': false,
        'canCancel': true,
        'canUpgrade': true,
        'freezeUnavailableReason': 'freeze_request_pending',
      };

      final dto = SubscriptionBillingActionsResponseDto.fromJson(json);
      expect(dto.canFreeze, isFalse);
      expect(dto.freezeUnavailableReason, 'freeze_request_pending');

      final entity = dto.toEntity();
      expect(entity.canFreeze, isFalse);
      expect(entity.freezeUnavailableReason, 'freeze_request_pending');
    });
  });

  group('Calendar Frozen Day Tests', () {
    test('CalendarDayEntity recognizes frozen day by status, uiStatus, or failure code', () {
      const dayFrozenStatus = CalendarDayEntity(
        dayNumber: 7,
        weekday: 'Monday',
        status: 'Frozen',
      );
      expect(dayFrozenStatus.isFrozen, isTrue);
      expect(dayFrozenStatus.isEditable, isFalse);
      expect(dayFrozenStatus.isRestaurantClosed, isTrue);

      const day12Status = CalendarDayEntity(
        dayNumber: 8,
        weekday: 'Tuesday',
        status: '12',
      );
      expect(day12Status.isFrozen, isTrue);
      expect(day12Status.isEditable, isFalse);
      expect(day12Status.isRestaurantClosed, isTrue);

      const dayUiFrozen = CalendarDayEntity(
        dayNumber: 9,
        weekday: 'Wednesday',
        uiStatus: 'frozen',
      );
      expect(dayUiFrozen.isFrozen, isTrue);
      expect(dayUiFrozen.isEditable, isFalse);

      const dayFailureReason = CalendarDayEntity(
        dayNumber: 10,
        weekday: 'Thursday',
        failureReasonCode: 'subscription.day_frozen',
      );
      expect(dayFailureReason.isFrozen, isTrue);
      expect(dayFailureReason.isEditable, isFalse);

      const dayOpen = CalendarDayEntity(
        dayNumber: 11,
        weekday: 'Friday',
        status: 'Open',
        uiStatus: 'empty',
      );
      expect(dayOpen.isFrozen, isFalse);
    });

    test('CalendarDayResponseDto safely handles numeric or string status and maps to entity', () {
      final jsonNumeric = {
        'id': 'day-1',
        'date': '2026-09-08',
        'status': 12,
        'uiStatus': 'frozen',
        'canEdit': false,
        'failureReasonCode': 'subscription.day_frozen',
      };

      final dtoNumeric = CalendarDayResponseDto.fromJson(jsonNumeric);
      expect(dtoNumeric.status, '12');
      expect(dtoNumeric.uiStatus, 'frozen');

      final entity = dtoNumeric.toEntity('en');
      expect(entity.isFrozen, isTrue);
      expect(entity.isLocked, isTrue);
      expect(entity.isEditable, isFalse);
    });
  });
}
