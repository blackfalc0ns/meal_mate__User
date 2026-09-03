import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/profile/data/mapper/profile_billing_mapper.dart';
import 'package:meal_meat_user/features/profile/data/models/response/profile_billing_response_dto.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_state.dart';

void main() {
  group('ProfileBillingFreezeResponseDto and Mapper Tests', () {
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

      final dto = ProfileBillingFreezeResponseDto.fromJson(json);

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
      const dto = ProfileBillingFreezeResponseDto(
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

    test('ProfileBillingActionState stores freezeResult and clears it correctly', () {
      const dto = ProfileBillingFreezeResponseDto(
        id: '123',
        subscriptionId: 'sub-456',
        freezeStartDate: '2026-09-07',
        freezeEndDate: '2026-09-13',
        freezeDays: 7,
        reason: 'Holiday',
        status: 'Approved',
      );
      final entity = dto.toEntity();

      var state = const ProfileBillingActionState();
      expect(state.freezeResult, isNull);

      state = state.copyWith(
        type: 'freeze',
        isSuccess: true,
        freezeResult: entity,
      );
      expect(state.freezeResult, isNotNull);
      expect(state.freezeResult?.id, '123');

      state = state.copyWith(clearFreezeResult: true);
      expect(state.freezeResult, isNull);
    });
  });
}
