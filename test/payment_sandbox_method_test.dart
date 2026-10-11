import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

void main() {
  group('Legacy Sandbox Payment Method Rejection Tests', () {
    test(
      'legacy SANDBOX_WITHOUT_PAYMENT with paymentMethodId -1 maps to unknown and is invalid',
      () {
        const dto = PaymentMethodResponseDto(
          paymentMethodId: -1,
          code: 'SANDBOX_WITHOUT_PAYMENT',
          nameAr: 'إكمال بدون دفع — تجربة',
          name: 'إكمال بدون دفع — تجربة',
          isAvailable: true,
        );

        final entity = dto.toEntity();

        expect(entity.id, -1);
        expect(entity.type, PaymentMethodType.unknown);
      },
    );

    test(
      'PaymentCheckoutRequestEntity strictly rejects paymentMethodId -1 for live checkout',
      () {
        const request = PaymentCheckoutRequestEntity(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tier: 'Standard',
          durationDays: 12,
          startDate: '2026-10-05',
          callbackUrl: 'mealmate://checkout/success',
          errorUrl: 'mealmate://checkout/error',
          includeFriday: false,
          paymentMethodId: -1,
          correlationId: 'test-correlation-id',
        );

        expect(request.isComplete, isFalse);
      },
    );
  });
}
