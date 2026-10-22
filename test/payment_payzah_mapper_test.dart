import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_checkout_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/payment_method_response_dto.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/mapper/restaurant_tier_upgrade_mapper.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_options_response_dto.dart';

void main() {
  group('Payment Method Payzah Mapping', () {
    test(
      'hosted checkout uses the returned id and keeps unknown fees null',
      () {
        final method = PaymentMethodResponseDto.fromJson({
          'paymentMethodId': 7,
          'code': 'PAYZAH',
          'integrationType': 'PAYZAH_HOSTED',
          'isAvailable': true,
          'nameEn': 'Payzah hosted checkout',
          'serviceCharge': null,
          'totalAmount': null,
          'currencyCode': 'KWD',
        }).toEntity();
        expect(method.id, 7);
        expect(method.type, PaymentMethodType.payzah);
        expect(method.serviceCharge, isNull);
        expect(method.totalAmount, isNull);
      },
    );

    test(
      'maps active Payzah provider with arbitrary positive ID and code PAYZAH',
      () {
        const dto = PaymentMethodResponseDto(
          id: 99,
          paymentMethodId: 99,
          code: 'PAYZAH',
          integrationType: 'PAYZAH_HOSTED',
          nameAr: 'بايزة',
          nameEn: 'Payzah',
          isAvailable: true,
        );

        final entity = dto.toEntity();

        expect(entity.id, 99);
        expect(entity.type, PaymentMethodType.payzah);
        expect(entity.isAvailable, isTrue);
      },
    );

    test('preserves unavailable Payzah method', () {
      const dto = PaymentMethodResponseDto(
        id: 3,
        paymentMethodId: 3,
        code: 'PAYZAH',
        name: 'Payzah',
        isAvailable: false,
        unavailableReason: 'maintenance',
      );

      final entity = dto.toEntity();

      expect(entity.id, 3);
      expect(entity.type, PaymentMethodType.payzah);
      expect(entity.isAvailable, isFalse);
      expect(entity.unavailableReason, 'maintenance');
    });

    test(
      'wallet with null ID maps with isAvailable false and unavailableReason',
      () {
        final method = PaymentMethodResponseDto.fromJson({
          'paymentMethodId': null,
          'code': 'MEALMATE_WALLET',
          'integrationType': null,
          'isAvailable': false,
          'unavailableReason': 'wallet_not_implemented',
          'nameEn': 'MealMate Wallet',
        }).toEntity();

        expect(method.id, isNull);
        expect(method.type, PaymentMethodType.wallet);
        expect(method.isAvailable, isFalse);
        expect(method.unavailableReason, 'wallet_not_implemented');
      },
    );

    test(
      'legacy sandbox method maps to unknown so it cannot bypass real checkout',
      () {
        const sandboxDto = PaymentMethodResponseDto(
          id: -1,
          paymentMethodId: -1,
          code: 'SANDBOX',
          isAvailable: true,
        );
        expect(sandboxDto.toEntity().type, PaymentMethodType.unknown);
      },
    );

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
