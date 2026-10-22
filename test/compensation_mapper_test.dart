import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/compensations/data/models/response/compensation_response_dto.dart';
import 'package:meal_meat_user/features/compensations/data/mapper/compensation_mapper.dart';

void main() {
  test('missing identity and timing never enable a compensation choice', () {
    final item = CompensationResponseDto.fromJson({
      'status': 'PendingChoice',
      'eligibleForAlternativeDay': true,
    }).toEntity();
    expect(item.canChoose, isFalse);
  });

  test('maps refund amounts and legacy alternative eligibility', () {
    final item = CompensationResponseDto.fromJson({
      'compensationId': 'c1',
      'status': 'PendingChoice',
      'eligibleForFreeDay': true,
      'serverTimeUtc': '2026-10-21T12:00:00Z',
      'choiceDeadlineUtc': '2026-10-22T12:00:00Z',
      'refundBreakdown': {'cardRefundAmount': 3, 'walletRefundAmount': 1.5},
    }).toEntity();
    expect(item.canChoose, isTrue);
    expect(item.eligibleForAlternativeDay, isTrue);
    expect(item.cardRefundAmount, 3);
    expect(item.walletRefundAmount, 1.5);
  });

  test(
    'explicit eligibility overrides legacy alias and expiry is not settlement',
    () {
      final item = CompensationResponseDto.fromJson({
        'compensationId': 'c1',
        'status': 'AutoRefundInitiated',
        'eligibleForAlternativeDay': false,
        'eligibleForFreeDay': true,
      }).toEntity();
      expect(item.eligibleForAlternativeDay, isFalse);
      expect(item.canChoose, isFalse);
      expect(item.status, 'AutoRefundInitiated');
    },
  );
}
