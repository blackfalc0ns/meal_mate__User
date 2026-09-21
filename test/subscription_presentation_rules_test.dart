import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';

void main() {
  group('SubscriptionReadinessEntity restaurant coverage', () {
    test('blocks checkout when no restaurant delivers', () {
      final readiness = _readiness(
        canCheckout: false,
        deliveringRestaurantCount: 0,
      );

      expect(readiness.hasRestaurantCoverageBlock, isTrue);
    });

    test('blocks checkout for every supported backend coverage reason', () {
      const reasons = [
        'restaurant.not_eligible',
        'subscription_flow.no_restaurants_for_address',
        'checkout.no_restaurants_for_address',
      ];

      for (final reason in reasons) {
        final readiness = _readiness(checkoutBlockReason: reason);

        expect(readiness.hasRestaurantCoverageBlock, isTrue, reason: reason);
      }
    });

    test('does not block checkout when restaurant coverage is available', () {
      final readiness = _readiness();

      expect(readiness.hasRestaurantCoverageBlock, isFalse);
    });
  });

  group('SubscriptionPlanState failure presentation', () {
    test('identifies the Friday unavailable failure', () {
      final state = SubscriptionPlanState(
        failure: Failure(
          errorMessage: 'Friday is unavailable',
          code: 'subscription_flow.friday_unavailable',
        ),
      );

      expect(state.hasFridayUnavailableFailure, isTrue);
    });

    test('ignores unrelated failures', () {
      final state = SubscriptionPlanState(
        failure: Failure(errorMessage: 'Failed', code: 'unknown'),
      );

      expect(state.hasFridayUnavailableFailure, isFalse);
    });
  });
}

SubscriptionReadinessEntity _readiness({
  bool canCheckout = true,
  int deliveringRestaurantCount = 1,
  String? checkoutBlockReason,
}) {
  return SubscriptionReadinessEntity(
    isComplete: true,
    canOpenSummary: true,
    canCheckout: canCheckout,
    nextAction: 'SUMMARY',
    warningAr: '',
    warningEn: '',
    checkoutBlockReason: checkoutBlockReason,
    deliveringRestaurantCount: deliveringRestaurantCount,
    items: const [],
    restaurants: const [],
  );
}
