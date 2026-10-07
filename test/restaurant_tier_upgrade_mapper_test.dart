import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/mapper/restaurant_tier_upgrade_mapper.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_options_response_dto.dart';

void main() {
  test('maps upgrade payment methods from the API response', () {
    final response = SubscriptionUpgradeOptionsResponseDto.fromJson({
      'canUpgrade': true,
      'currentTier': 'Basic',
      'remainingServiceDays': 12,
      'totalServiceDays': 12,
      'upgradeEndpoint':
          '/api/v1/customer/subscriptions/sub-1/upgrade-requests',
      'options': [
        {
          'targetTier': 'Platinum',
          'tierNameAr': 'بلاتينيوم',
          'selectable': true,
          'priceDifference': 15.25,
          'currencyCode': 'KWD',
        },
      ],
      'paymentMethods': [
        {
          'paymentMethodId': 3,
          'code': 'PAYZAH',
          'nameAr': 'بيزاه',
          'integrationType': 'HOSTED',
          'serviceCharge': 1.153,
          'totalAmount': 15.25,
          'currencyCode': 'KWD',
          'isAvailable': true,
          'unavailableReason': null,
          'imageUrl': 'https://payzah.net/imgs/payzah.png',
          'name': 'Payzah',
        },
      ],
    });

    final entity = RestaurantTierUpgradeMapper.toOptionsEntity(response);

    expect(entity.paymentMethods, hasLength(1));
    expect(entity.paymentMethods.single.id, 3);
    expect(entity.paymentMethods.single.title, 'بيزاه');
    expect(entity.paymentMethods.single.code, 'PAYZAH');
    expect(entity.paymentMethods.single.integrationType, 'HOSTED');
    expect(entity.paymentMethods.single.serviceCharge, 1.153);
    expect(entity.paymentMethods.single.totalAmount, 15.25);
    expect(entity.paymentMethods.single.currencyCode, 'KWD');
    expect(entity.paymentMethods.single.isAvailable, isTrue);
    expect(
      entity.paymentMethods.single.imageUrl,
      'https://payzah.net/imgs/payzah.png',
    );
  });

  test('historical: preserves legacy MyFatoorah method mapping in historical options responses', () {
    final response = SubscriptionUpgradeOptionsResponseDto.fromJson({
      'subscriptionId': 'sub-old',
      'currentTier': 'Silver',
      'options': [],
      'paymentMethods': [
        {
          'paymentMethodId': 6,
          'code': 'md',
          'nameAr': 'مدى',
          'integrationType': 'MYFATOORAH_HOSTED',
          'serviceCharge': 1.153,
          'totalAmount': 15.25,
          'currencyCode': 'KWD',
          'isAvailable': true,
          'unavailableReason': null,
          'imageUrl': 'https://demo.myfatoorah.com/imgs/payment-methods/md.png',
          'name': 'مدى',
        },
      ],
    });

    final entity = RestaurantTierUpgradeMapper.toOptionsEntity(response);
    expect(entity.paymentMethods.single.id, 6);
    expect(entity.paymentMethods.single.integrationType, 'MYFATOORAH_HOSTED');
  });
}
