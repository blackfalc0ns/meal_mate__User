import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_checkout_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/request/payment_checkout_request_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class FakeGetPaymentMethodsUseCase implements GetPaymentMethodsUseCase {
  double? lastRequestedAmount;
  Completer<ApiResult<List<PaymentMethodEntity>>>? completer;
  ApiResult<List<PaymentMethodEntity>>? result;

  @override
  Future<ApiResult<List<PaymentMethodEntity>>> call({double? amount}) async {
    lastRequestedAmount = amount;
    if (completer != null) {
      return completer!.future;
    }
    return result ??
        const ApiSuccessResult(
          data: [
            PaymentMethodEntity(
              id: 1,
              type: PaymentMethodType.mada,
              title: 'Mada',
              subtitle: 'Debit Card',
              isAvailable: true,
            ),
          ],
        );
  }
}

class FakeCheckoutSubscriptionUseCase implements CheckoutSubscriptionUseCase {
  PaymentCheckoutRequestEntity? lastRequest;
  ApiResult<PaymentCheckoutEntity>? result;

  @override
  Future<ApiResult<PaymentCheckoutEntity>> call(
    PaymentCheckoutRequestEntity request,
  ) async {
    lastRequest = request;
    return result ??
        const ApiSuccessResult(
          data: PaymentCheckoutEntity(
            subscriptionId: 'sub-123',
            paymentUrl: 'https://payment.gateway/pay',
            holdExpiresAtUtc: '2026-10-06T00:00:00Z',
            chosenStartDate: '2026-10-10',
            startDate: '2026-10-10',
            finalPrice: 150,
            priceSnapshotId: 'snap-1',
            restaurantPoolSnapshotId: 'pool-1',
            paymentStatus: 'pending',
          ),
        );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeGetPaymentMethodsUseCase fakeMethodsUseCase;
  late FakeCheckoutSubscriptionUseCase fakeCheckoutUseCase;
  late SubscriptionCheckoutViewModel viewModel;

  setUp(() async {
    fakeMethodsUseCase = FakeGetPaymentMethodsUseCase();
    fakeCheckoutUseCase = FakeCheckoutSubscriptionUseCase();

    viewModel = SubscriptionCheckoutViewModel(
      fakeMethodsUseCase,
      fakeCheckoutUseCase,
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  SubscriptionCheckoutArgs buildSubscriptionCheckoutArgs({
    double finalPrice = 200.0,
    String? promoCode = 'SAVE20',
  }) {
    return SubscriptionCheckoutArgs(
      summary: SubscriptionSummaryEntity(
        programId: 'prog-1',
        programNameAr: 'برنامج',
        programNameEn: 'Program',
        bundleId: 'bundle-1',
        bundleNameAr: 'باقة',
        bundleNameEn: 'Bundle',
        restaurantCount: 5,
        tier: 'Basic',
        tierNameAr: 'بيسك',
        tierNameEn: 'Basic',
        durationDays: 12,
        chosenStartDate: '2026-10-10',
        startDate: '2026-10-10',
        endDate: '2026-10-22',
        serviceDates: const ['2026-10-10'],
        slotRequirements: const [],
        basePrice: 250,
        campaignDiscount: 0,
        promoDiscount: 0,
        walletCredit: 0,
        gatewayFee: 0,
        finalPrice: finalPrice,
        currencyCode: 'SAR',
        canCheckout: true,
        restaurants: const [],
        termsAcceptanceRequired: false,
        checkoutEndpoint: '/checkout',
        includeFriday: false,
        fridayDays: 0,
        totalServiceDays: 12,
        includes: const SubscriptionSummaryIncludesEntity(
          titleAr: '',
          titleEn: '',
          items: [],
        ),
      ),
      summaryRequest: SubscriptionSummaryRequestEntity(
        programId: 'prog-1',
        bundleId: 'bundle-1',
        tier: 'Standard',
        durationDays: 12,
        startDate: '2026-10-10',
        includeFriday: false,
        promoCode: promoCode,
      ),
      restaurantId: 'rest-1',
    );
  }

  group('Payment Checkout & Coupon Integration Tests', () {
    test(
      'PaymentCheckoutRequestDto JSON includes promoCode only when not null',
      () {
        const dtoWithCoupon = PaymentCheckoutRequestDto(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tier: 'Standard',
          durationDays: 12,
          startDate: '2026-10-10',
          callbackUrl: 'mealmate://payment/success',
          errorUrl: 'mealmate://payment/error',
          includeFriday: false,
          paymentMethodId: 1,
          correlationId: 'corr-1',
          promoCode: 'SAVE20',
        );

        final jsonWith = dtoWithCoupon.toJson();
        expect(jsonWith['promoCode'], equals('SAVE20'));
        expect(jsonWith['programId'], equals('prog-1'));

        const dtoWithoutCoupon = PaymentCheckoutRequestDto(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tier: 'Standard',
          durationDays: 12,
          startDate: '2026-10-10',
          callbackUrl: 'mealmate://payment/success',
          errorUrl: 'mealmate://payment/error',
          includeFriday: false,
          paymentMethodId: 1,
          correlationId: 'corr-1',
          promoCode: null,
        );

        final jsonWithout = dtoWithoutCoupon.toJson();
        expect(jsonWithout.containsKey('promoCode'), isFalse);
      },
    );

    test(
      'PaymentCheckoutRequestEntity maps promoCode to PaymentCheckoutRequestDto',
      () {
        const entity = PaymentCheckoutRequestEntity(
          programId: 'prog-1',
          bundleId: 'bundle-1',
          tier: 'Standard',
          durationDays: 12,
          startDate: '2026-10-10',
          callbackUrl: 'mealmate://payment/success',
          errorUrl: 'mealmate://payment/error',
          includeFriday: false,
          paymentMethodId: 2,
          correlationId: 'corr-2',
          promoCode: 'TESTCODE',
        );

        final dto = entity.toDto();
        expect(dto.promoCode, equals('TESTCODE'));
        expect(dto.paymentMethodId, equals(2));
      },
    );

    test(
      'LoadSubscriptionCheckoutEvent passes latest summary.finalPrice to GetPaymentMethodsUseCase',
      () async {
        final args = buildSubscriptionCheckoutArgs(finalPrice: 175.5);
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args));
        await Future<void>.delayed(Duration.zero);

        expect(fakeMethodsUseCase.lastRequestedAmount, equals(175.5));
      },
    );

    test(
      'stale payment methods load response is discarded by generation guard',
      () async {
        final completer1 = Completer<ApiResult<List<PaymentMethodEntity>>>();
        fakeMethodsUseCase.completer = completer1;

        // Start first load (generation 1)
        final args1 = buildSubscriptionCheckoutArgs(finalPrice: 200.0);
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args1));
        await Future<void>.delayed(Duration.zero);

        // Start second load (generation 2) with different methods
        final completer2 = Completer<ApiResult<List<PaymentMethodEntity>>>();
        fakeMethodsUseCase.completer = completer2;
        final args2 = buildSubscriptionCheckoutArgs(finalPrice: 150.0);
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args2));
        await Future<void>.delayed(Duration.zero);

        // Complete second load first
        completer2.complete(
          const ApiSuccessResult(
            data: [
              PaymentMethodEntity(
                id: 2,
                type: PaymentMethodType.visa,
                title: 'Visa',
                subtitle: 'Credit Card',
                isAvailable: true,
              ),
            ],
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(viewModel.state.methods.first.id, equals(2));

        // Now complete first (stale) load with old methods
        completer1.complete(
          const ApiSuccessResult(
            data: [
              PaymentMethodEntity(
                id: 99,
                type: PaymentMethodType.mada,
                title: 'Old Mada',
                subtitle: 'Stale',
                isAvailable: true,
              ),
            ],
          ),
        );
        await Future<void>.delayed(Duration.zero);

        // State MUST retain methods from generation 2
        expect(viewModel.state.methods.first.id, equals(2));
      },
    );

    test(
      'SubmitSubscriptionCheckoutEvent propagates promoCode from summaryRequest',
      () async {
        final args = buildSubscriptionCheckoutArgs(
          finalPrice: 180.0,
          promoCode: 'SUMMER30',
        );
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args));
        await Future<void>.delayed(Duration.zero);

        viewModel.doIntent(SubmitSubscriptionCheckoutEvent(args));
        await Future<void>.delayed(Duration.zero);

        expect(fakeCheckoutUseCase.lastRequest, isNotNull);
        expect(fakeCheckoutUseCase.lastRequest!.promoCode, equals('SUMMER30'));
      },
    );

    test(
      'SubmitSubscriptionCheckoutEvent blocks zero-amount checkout with couponFullDiscountUnsupported',
      () async {
        final args = buildSubscriptionCheckoutArgs(
          finalPrice: 0.0,
          promoCode: 'FREE100',
        );
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args));
        await Future<void>.delayed(Duration.zero);

        viewModel.doIntent(SubmitSubscriptionCheckoutEvent(args));
        await Future<void>.delayed(Duration.zero);

        // Checkout use case should NOT have been called
        expect(fakeCheckoutUseCase.lastRequest, isNull);
        expect(viewModel.state.isCouponCheckoutFailure, isTrue);
        expect(
          viewModel.state.checkoutFailure?.code,
          equals(SubscriptionErrorCodes.couponFullDiscountUnsupported),
        );
      },
    );

    test(
      'SubscriptionCheckoutState detects coupon rejection failures accurately',
      () {
        final couponRejectedFailure = ServerFailure(
          code: SubscriptionErrorCodes.couponRejected,
          errorMessage: 'Coupon rejected',
          exception: const ApiException(
            message: 'Coupon rejected',
            statusCode: 400,
            errorType: ApiErrorType.badRequest,
            backendErrorCode: SubscriptionErrorCodes.couponRejected,
          ),
        );

        final stateWithRejection = SubscriptionCheckoutState(
          checkoutFailure: couponRejectedFailure,
        );
        expect(stateWithRejection.isCouponCheckoutFailure, isTrue);

        final networkFailure = ServerFailure(
          code: 'network.timeout',
          errorMessage: 'Timeout',
          exception: const ApiException(
            message: 'Timeout',
            errorType: ApiErrorType.connectionTimeout,
          ),
        );

        final stateWithNetwork = SubscriptionCheckoutState(
          checkoutFailure: networkFailure,
        );
        expect(stateWithNetwork.isCouponCheckoutFailure, isFalse);
      },
    );
  });
}
