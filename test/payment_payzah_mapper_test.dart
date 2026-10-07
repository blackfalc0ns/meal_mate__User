import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/mapper/restaurant_tier_upgrade_mapper.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_options_response_dto.dart';

void main() {
  group('Payment Method Payzah Mapping', () {
    test('maps active Payzah provider with ID 3 and code PAYZAH', () {
      const dto = PaymentMethodResponseDto(
        id: 3,
        paymentMethodId: 3,
        code: 'PAYZAH',
        nameAr: 'بايزة',
        nameEn: 'Payzah',
        name: 'Payzah',
        isAvailable: true,
      );

      final entity = dto.toEntity();

      expect(entity.id, 3);
      expect(entity.type, PaymentMethodType.payzah);
      expect(entity.isAvailable, isTrue);
    });

    test('preserves unavailable Payzah method', () {
      const dto = PaymentMethodResponseDto(
        id: 3,
        paymentMethodId: 3,
        code: 'PAYZAH',
        name: 'Payzah',
        isAvailable: false,
      );

      final entity = dto.toEntity();

      expect(entity.id, 3);
      expect(entity.type, PaymentMethodType.payzah);
      expect(entity.isAvailable, isFalse);
    });

    test('conflicting code and ID maps to unknown instead of silent fallback', () {
      // Code is PAYZAH but ID is 99 (not 3)
      const conflictingIdDto = PaymentMethodResponseDto(
        id: 99,
        paymentMethodId: 99,
        code: 'PAYZAH',
        isAvailable: true,
      );
      expect(conflictingIdDto.toEntity().type, PaymentMethodType.unknown);

      // ID is 3 but code is VISA (conflict)
      const conflictingCodeDto = PaymentMethodResponseDto(
        id: 3,
        paymentMethodId: 3,
        code: 'VISA',
        isAvailable: true,
      );
      expect(conflictingCodeDto.toEntity().type, PaymentMethodType.unknown);
    });

    test('unknown provider does not silently become mada or Payzah', () {
      const dto = PaymentMethodResponseDto(
        id: 42,
        paymentMethodId: 42,
        code: 'UNKNOWN_GATEWAY',
        name: 'Mystery Gateway',
        isAvailable: true,
      );

      final entity = dto.toEntity();

      expect(entity.type, PaymentMethodType.unknown);
    });

    test('wallet and sandbox methods remain correctly mapped', () {
      const walletDto = PaymentMethodResponseDto(
        id: 2,
        paymentMethodId: 2,
        code: 'WALLET',
        name: 'المحفظة',
        isAvailable: true,
        walletBalance: 25.5,
      );
      expect(walletDto.toEntity().type, PaymentMethodType.wallet);
      expect(walletDto.toEntity().walletBalance, 25.5);

      const sandboxDto = PaymentMethodResponseDto(
        id: -1,
        paymentMethodId: -1,
        code: 'SANDBOX',
        isAvailable: true,
      );
      expect(sandboxDto.toEntity().type, PaymentMethodType.sandbox);
    });
  });

  group('Nullable fees and totals in Upgrade mapping', () {
    test('missing fee and total remain null, never coerced to 0.0', () {
      const methodDto = SubscriptionUpgradePaymentMethodResponseDto(
        id: 3,
        paymentMethodId: 3,
        code: 'PAYZAH',
        nameAr: 'بايزة',
        serviceCharge: null,
        totalAmount: null,
        isAvailable: true,
      );

      final entity = methodDto.toEntity();

      expect(entity.id, 3);
      expect(entity.serviceCharge, isNull);
      expect(entity.totalAmount, isNull);
    });

    test('explicit zero fee or total remains 0.0', () {
      const methodDto = SubscriptionUpgradePaymentMethodResponseDto(
        id: 3,
        paymentMethodId: 3,
        code: 'PAYZAH',
        serviceCharge: 0.0,
        totalAmount: 15.0,
        isAvailable: true,
      );

      final entity = methodDto.toEntity();

      expect(entity.serviceCharge, 0.0);
      expect(entity.totalAmount, 15.0);
    });
  });
}
