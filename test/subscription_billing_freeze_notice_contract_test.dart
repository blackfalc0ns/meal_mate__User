import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/subscription_billing_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';

void main() {
  group('SubscriptionBillingActions notice parsing and contract', () {
    test('current subscription preserves server freeze notices', () {
      final entity = SubscriptionBillingCurrentResponseDto.fromJson({
        'subscription': {
          'subscriptionId': 'subscription-fixture',
          'actions': {
            'canFreeze': true,
            'freezeNotice': 'Server localized freeze policy',
            'freezeNoticeAr': 'سياسة التجميد من الخادم',
            'maximumFreezeDays': 7,
          },
        },
      }).toEntity();

      expect(entity.subscription!.actions.freezeNotice,
          'Server localized freeze policy');
      expect(entity.subscription!.actions.freezeNoticeAr,
          'سياسة التجميد من الخادم');
    });

    test('actions preserve null or empty freeze notices without inventing text', () {
      final entity = SubscriptionBillingCurrentResponseDto.fromJson({
        'subscription': {
          'subscriptionId': 'subscription-fixture-null',
          'actions': {
            'canFreeze': true,
            'maximumFreezeDays': 7,
          },
        },
      }).toEntity();

      expect(entity.subscription!.actions.freezeNotice, isNull);
      expect(entity.subscription!.actions.freezeNoticeAr, isNull);
    });
  });
}
