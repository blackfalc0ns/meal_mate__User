import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_pricing_preview_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_checkout_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/repo/payment_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_restaurant_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';

class RecordingSummaryRepo implements SubscriptionSummaryRepository {
  @override
  Future<ApiResult<SubscriptionPricingPreviewResponseDto>> getPricingPreview(
    SubscriptionSummaryRequestEntity request,
  ) => throw UnimplementedError();

  Completer<ApiResult<SubscriptionSummaryEntity>>? nextCompleter;
  ApiResult<SubscriptionSummaryEntity>? immediateResult;
  final List<SubscriptionSummaryRequestEntity> recordedRequests = [];

  @override
  Future<ApiResult<SubscriptionSummaryEntity>> getSummary(
    SubscriptionSummaryRequestEntity request,
  ) async {
    recordedRequests.add(request);
    if (nextCompleter != null) {
      return nextCompleter!.future;
    }
    return immediateResult ??
        ApiSuccessResult(data: _buildSummary(canCheckout: true));
  }

  @override
  Future<ApiResult<SubscriptionReadinessEntity>> getReadiness(
    SubscriptionSummaryRequestEntity request,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<SubscriptionRestaurantAvailabilityEntity>>
  getRestaurantAvailability(SubscriptionSummaryRequestEntity request) {
    throw UnimplementedError();
  }
}

class FakeCheckoutSubscriptionUseCase extends CheckoutSubscriptionUseCase {
  FakeCheckoutSubscriptionUseCase() : super(_NoopPaymentRepo());
  int checkoutCallCount = 0;

  @override
  Future<ApiResult<PaymentCheckoutEntity>> call(
    PaymentCheckoutRequestEntity request,
  ) async {
    checkoutCallCount++;
    return const ApiSuccessResult(
      data: PaymentCheckoutEntity(
        subscriptionId: 'sub-1',
        paymentUrl: 'https://pay.example.com',
        holdExpiresAtUtc: '2026-10-08T12:00:00Z',
        chosenStartDate: '2026-10-08',
        startDate: '2026-10-11',
        finalPrice: 85.0,
        priceSnapshotId: 'snap-1',
        restaurantPoolSnapshotId: 'pool-1',
        paymentStatus: 'PendingPayment',
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
  double basePrice = 100.0,
  double campaignDiscount = 10.0,
  double promoDiscount = 5.0,
  double finalPrice = 85.0,
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
    basePrice: basePrice,
    campaignDiscount: campaignDiscount,
    promoDiscount: promoDiscount,
    walletCredit: 0.0,
    gatewayFee: 0.0,
    finalPrice: finalPrice,
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
  group('Subscription Checkout Permission & Refresh Tests (Task 4)', () {
    late RecordingSummaryRepo repo;
    late GetSubscriptionSummaryUseCase useCase;
    late SubscriptionSummaryViewModel viewModel;

    setUp(() {
      repo = RecordingSummaryRepo();
      useCase = GetSubscriptionSummaryUseCase(repo);
      viewModel = SubscriptionSummaryViewModel(useCase);
    });

    tearDown(() async {
      await viewModel.close();
    });

    const testRequest = SubscriptionSummaryRequestEntity(
      includeFriday: false,
      durationDays: 26,
      tier: 'Basic',
      bundleId: 'bundle-1',
      programId: 'prog-1',
      startDate: '2026-10-08',
    );

    test(
      'canCheckout=false with non-empty restaurants disables checkout permission',
      () async {
        repo.immediateResult = ApiSuccessResult(
          data: _buildSummary(
            canCheckout: false,
            checkoutBlockReason: 'checkout.address_required',
          ),
        );

        viewModel.doIntent(const GetSubscriptionSummaryEvent(testRequest));
        await pumpEventQueue();

        expect(viewModel.state.summary, isNotNull);
        expect(viewModel.state.summary!.restaurants.isNotEmpty, isTrue);
        expect(viewModel.state.canCheckout, isFalse);
      },
    );

    test(
      'isSummaryRefreshing=true disables checkout during active refresh of approved summary',
      () async {
        // First load succeeds with canCheckout=true
        repo.immediateResult = ApiSuccessResult(
          data: _buildSummary(canCheckout: true),
        );
        viewModel.doIntent(const GetSubscriptionSummaryEvent(testRequest));
        await pumpEventQueue();

        expect(viewModel.state.canCheckout, isTrue);

        // Now start a new refresh request that is pending
        final refreshCompleter =
            Completer<ApiResult<SubscriptionSummaryEntity>>();
        repo.nextCompleter = refreshCompleter;

        viewModel.doIntent(const GetSubscriptionSummaryEvent(testRequest));
        await pumpEventQueue();

        expect(viewModel.state.isSummaryRefreshing, isTrue);
        // While refreshing, canCheckout must be false
        expect(viewModel.state.canCheckout, isFalse);

        // Complete refresh
        refreshCompleter.complete(
          ApiSuccessResult(data: _buildSummary(canCheckout: true)),
        );
        await pumpEventQueue();

        expect(viewModel.state.isSummaryRefreshing, isFalse);
        expect(viewModel.state.canCheckout, isTrue);
      },
    );

    test(
      'Failure on refresh does not restore approval of old summary',
      () async {
        // Initial success
        repo.immediateResult = ApiSuccessResult(
          data: _buildSummary(canCheckout: true),
        );
        viewModel.doIntent(const GetSubscriptionSummaryEvent(testRequest));
        await pumpEventQueue();
        expect(viewModel.state.canCheckout, isTrue);

        // Refresh fails
        repo.nextCompleter = null;
        repo.immediateResult = ApiErrorResult(
          failure: Failure(errorMessage: 'Network timeout', code: 'timeout'),
        );
        viewModel.doIntent(const GetSubscriptionSummaryEvent(testRequest));
        await pumpEventQueue();

        expect(viewModel.state.failure, isNotNull);
        expect(viewModel.state.canCheckout, isFalse);
      },
    );

    test(
      'Display finalPrice directly from server without re-calculating discounts',
      () async {
        repo.immediateResult = ApiSuccessResult(
          data: _buildSummary(
            canCheckout: true,
            basePrice: 100.0,
            campaignDiscount: 10.0,
            promoDiscount: 5.0,
            finalPrice: 85.0,
          ),
        );
        viewModel.doIntent(const GetSubscriptionSummaryEvent(testRequest));
        await pumpEventQueue();

        final summary = viewModel.state.summary!;
        expect(summary.finalPrice, equals(85.0));
        expect(summary.basePrice, equals(100.0));
        expect(summary.campaignDiscount, equals(10.0));
        expect(summary.promoDiscount, equals(5.0));
      },
    );

    test(
      'SubscriptionCheckoutViewModel guards against checkout when canCheckout is false',
      () async {
        final fakeCheckout = FakeCheckoutSubscriptionUseCase();
        final fakeMethods = _FakeGetPaymentMethodsUseCase();

        final paymentVm = SubscriptionCheckoutViewModel(
          fakeMethods,
          fakeCheckout,
        );

        // Load methods to select a valid payment method
        const validMethod = PaymentMethodEntity(
          id: 1,
          type: PaymentMethodType.payzah,
          title: 'KNet',
          subtitle: '',
          code: 'knet',
          integrationType: 'hosted',
          currencyCode: 'KWD',
          isAvailable: true,
        );
        fakeMethods.methodsToReturn = [validMethod];

        paymentVm.doIntent(const SelectCheckoutPaymentMethodEvent(validMethod));
        await pumpEventQueue();

        final blockedSummary = _buildSummary(canCheckout: false);
        final paymentArgs = SubscriptionCheckoutArgs(
          summary: blockedSummary,
          summaryRequest: testRequest,
          restaurantId: 'rest-1',
        );

        paymentVm.doIntent(SubmitSubscriptionCheckoutEvent(paymentArgs));
        await pumpEventQueue();

        expect(fakeCheckout.checkoutCallCount, equals(0));
        paymentVm.close();
      },
    );
  });
}

class _FakeGetPaymentMethodsUseCase extends GetPaymentMethodsUseCase {
  _FakeGetPaymentMethodsUseCase() : super(_NoopPaymentRepo());
  List<PaymentMethodEntity> methodsToReturn = [];

  @override
  Future<ApiResult<List<PaymentMethodEntity>>> call({
    required double amount,
  }) async => ApiSuccessResult(data: methodsToReturn);
}
