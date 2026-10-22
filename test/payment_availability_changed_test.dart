import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_checkout_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/repo/payment_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class CountingCheckoutUseCase extends CheckoutSubscriptionUseCase {
  CountingCheckoutUseCase() : super(_NoopPaymentRepo());
  int checkoutCallCount = 0;
  ApiResult<PaymentCheckoutEntity>? checkoutResult;

  @override
  Future<ApiResult<PaymentCheckoutEntity>> call(
    PaymentCheckoutRequestEntity request,
  ) async {
    checkoutCallCount++;
    return checkoutResult ??
        ApiErrorResult(
          failure: Failure(
            errorMessage:
                'Checkout eligibility or restaurant snapshot changed. Refresh and try again.',
            code: SubscriptionErrorCodes.restaurantNotEligible,
          ),
        );
  }
}

class _NoopPaymentRepo
    implements PaymentRepository, SubscriptionCheckoutRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SubscriptionSummaryEntity _buildSummary({
  required bool canCheckout,
  String? checkoutBlockReason,
}) {
  return SubscriptionSummaryEntity(
    programId: 'prog-1',
    programNameAr: 'برنامج',
    programNameEn: 'Program',
    bundleId: 'bundle-1',
    bundleNameAr: 'باقة',
    bundleNameEn: 'Bundle',
    restaurantCount: 1,
    tier: 'Basic',
    tierNameAr: 'أساسي',
    tierNameEn: 'Basic',
    durationDays: 26,
    chosenStartDate: '2026-10-08',
    startDate: '2026-10-11',
    endDate: '2026-11-05',
    serviceDates: const ['2026-10-11'],
    slotRequirements: const [],
    basePrice: 100.0,
    campaignDiscount: 0.0,
    promoDiscount: 0.0,
    walletCredit: 0.0,
    gatewayFee: 0.0,
    finalPrice: 100.0,
    currencyCode: 'KWD',
    canCheckout: canCheckout,
    checkoutBlockReason: checkoutBlockReason,
    restaurants: const [
      SubscriptionSummaryRestaurantEntity(
        restaurantId: 'rest-1',
        nameAr: 'مطعم 1',
        nameEn: 'Restaurant 1',
        tier: 'Basic',
      ),
    ],
    termsAcceptanceRequired: false,
    checkoutEndpoint: '/api/v1/customer/subscriptions/checkout',
    includeFriday: false,
    fridayDays: 0,
    totalServiceDays: 26,
    includes: const SubscriptionSummaryIncludesEntity(
      titleAr: '',
      titleEn: '',
      items: [],
    ),
  );
}

void main() {
  group('Payment Availability Changed & Non-Replay Tests (Task 5)', () {
    late CountingCheckoutUseCase fakeCheckout;
    late SubscriptionCheckoutViewModel viewModel;

    setUp(() async {
      fakeCheckout = CountingCheckoutUseCase();
      final methodsUseCase = _FakeMethodsUseCase();

      viewModel = SubscriptionCheckoutViewModel(methodsUseCase, fakeCheckout);

      const validMethod = PaymentMethodEntity(
        id: 3,
        type: PaymentMethodType.payzah,
        title: 'Payzah',
        subtitle: '',
        code: 'PAYZAH',
        integrationType: 'PAYZAH_HOSTED',
        currencyCode: 'KWD',
        isAvailable: true,
      );
      methodsUseCase.methods = [validMethod];
      viewModel.doIntent(const SelectCheckoutPaymentMethodEvent(validMethod));
      await pumpEventQueue();
    });

    tearDown(() async {
      await viewModel.close();
    });

    const summaryRequest = SubscriptionSummaryRequestEntity(
      includeFriday: false,
      durationDays: 26,
      tier: 'Basic',
      bundleId: 'bundle-1',
      programId: 'prog-1',
      startDate: '2026-10-08',
    );

    test(
      '400 restaurant.not_eligible performs exactly 1 POST, marks availability changed, does not auto-retry',
      () async {
        fakeCheckout.checkoutResult = ApiErrorResult(
          failure: Failure(
            errorMessage:
                'Checkout eligibility or restaurant snapshot changed.',
            code: SubscriptionErrorCodes.restaurantNotEligible,
          ),
        );

        final args = SubscriptionCheckoutArgs(
          summary: _buildSummary(canCheckout: true),
          summaryRequest: summaryRequest,
          restaurantId: 'rest-1',
        );

        viewModel.doIntent(SubmitSubscriptionCheckoutEvent(args));
        await pumpEventQueue();

        // Exactly 1 POST made
        expect(fakeCheckout.checkoutCallCount, equals(1));
        expect(viewModel.state.isAvailabilityChangedFailure, isTrue);
        expect(viewModel.state.isCheckoutLoading, isFalse);

        // Verify no subsequent automatic retry occurs
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(fakeCheckout.checkoutCallCount, equals(1));
      },
    );

    test(
      'Double tap while checkout in flight does not send concurrent POSTs',
      () async {
        final completer = Completer<ApiResult<PaymentCheckoutEntity>>();
        final slowCheckout = _SlowCheckoutUseCase(completer);

        final vm = SubscriptionCheckoutViewModel(
          _FakeMethodsUseCase(),
          slowCheckout,
        );

        const method = PaymentMethodEntity(
          id: 1,
          type: PaymentMethodType.payzah,
          title: 'Payzah',
          subtitle: '',
          isAvailable: true,
        );
        vm.doIntent(const SelectCheckoutPaymentMethodEvent(method));
        await pumpEventQueue();

        final args = SubscriptionCheckoutArgs(
          summary: _buildSummary(canCheckout: true),
          summaryRequest: summaryRequest,
          restaurantId: 'rest-1',
        );

        // Trigger twice immediately
        vm.doIntent(SubmitSubscriptionCheckoutEvent(args));
        vm.doIntent(SubmitSubscriptionCheckoutEvent(args));
        await pumpEventQueue();

        expect(slowCheckout.callCount, equals(1));

        completer.complete(
          const ApiSuccessResult(
            data: PaymentCheckoutEntity(
              subscriptionId: 'sub-1',
              paymentUrl: 'https://pay.example.com',
              holdExpiresAtUtc: '2026-10-08T12:00:00Z',
              chosenStartDate: '2026-10-08',
              startDate: '2026-10-11',
              finalPrice: 100.0,
              priceSnapshotId: 'snap-1',
              restaurantPoolSnapshotId: 'pool-1',
              paymentStatus: 'PendingPayment',
            ),
          ),
        );
        await pumpEventQueue();
        expect(slowCheckout.callCount, equals(1));
        vm.close();
      },
    );

    test(
      'Timeout or 5xx does not trigger automatic POST retry or leave safe recovery open',
      () async {
        fakeCheckout.checkoutResult = ApiErrorResult(
          failure: Failure(errorMessage: 'Gateway timeout', code: 'timeout'),
        );

        final args = SubscriptionCheckoutArgs(
          summary: _buildSummary(canCheckout: true),
          summaryRequest: summaryRequest,
          restaurantId: 'rest-1',
        );

        viewModel.doIntent(SubmitSubscriptionCheckoutEvent(args));
        await pumpEventQueue();

        expect(fakeCheckout.checkoutCallCount, equals(1));
        expect(viewModel.state.isAvailabilityChangedFailure, isFalse);
        expect(viewModel.state.checkoutFailure?.code, equals('timeout'));
      },
    );
  });
}

class _SlowCheckoutUseCase extends CheckoutSubscriptionUseCase {
  _SlowCheckoutUseCase(this.completer) : super(_NoopPaymentRepo());
  final Completer<ApiResult<PaymentCheckoutEntity>> completer;
  int callCount = 0;

  @override
  Future<ApiResult<PaymentCheckoutEntity>> call(
    PaymentCheckoutRequestEntity request,
  ) {
    callCount++;
    return completer.future;
  }
}

class _FakeMethodsUseCase extends GetPaymentMethodsUseCase {
  _FakeMethodsUseCase() : super(_NoopPaymentRepo());
  List<PaymentMethodEntity> methods = [];

  @override
  Future<ApiResult<List<PaymentMethodEntity>>> call({
    required double amount,
  }) async => ApiSuccessResult(data: methods);
}
