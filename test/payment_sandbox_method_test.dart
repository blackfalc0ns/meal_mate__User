import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

void main() {
  group('Sandbox Payment Method Tests', () {
    test('maps SANDBOX_WITHOUT_PAYMENT with paymentMethodId -1 correctly', () {
      const dto = PaymentMethodResponseDto(
        paymentMethodId: -1,
        code: 'SANDBOX_WITHOUT_PAYMENT',
        nameAr: 'إكمال بدون دفع — تجربة',
        name: 'إكمال بدون دفع — تجربة',
        isAvailable: true,
      );

      final entity = dto.toEntity();

      expect(entity.id, -1);
      expect(entity.type, PaymentMethodType.sandbox);
      expect(entity.title, 'إكمال بدون دفع — تجربة');
      expect(entity.isAvailable, isTrue);
    });

    test('PaymentCheckoutRequestEntity allows paymentMethodId -1 for sandbox', () {
      const request = PaymentCheckoutRequestEntity(
        programId: 'prog-1',
        bundleId: 'bundle-1',
        tier: 'Standard',
        durationDays: 12,
        startDate: '2026-10-05',
        callbackUrl: 'mealmate://payment/success',
        errorUrl: 'mealmate://payment/error',
        includeFriday: false,
        paymentMethodId: -1,
        correlationId: 'test-correlation-id',
      );

      expect(request.isComplete, isTrue);
    });
  });
}
