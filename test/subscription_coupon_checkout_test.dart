import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/payment/data/mapper/payment_mapper.dart';
import 'package:meal_meat_user/features/payment/data/models/request/payment_checkout_request_dto.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_calendar_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_payment_status_usecase.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        ApiSuccessResult(
          data: const [
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
        ApiSuccessResult(
          data: const PaymentCheckoutEntity(
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

class FakeGetSubscriptionPaymentStatusUseCase
    implements GetSubscriptionPaymentStatusUseCase {
  @override
  Future<ApiResult<PaymentStatusEntity>> call(String subscriptionId) async {
    return ApiSuccessResult(
      data: const PaymentStatusEntity(
        paymentStatus: 'paid',
        isPaid: true,
        isFailed: false,
        amount: 150,
        currencyCode: 'SAR',
      ),
    );
  }
}

class FakeGetSubscriptionCalendarUseCase
    implements GetSubscriptionCalendarUseCase {
  @override
  Future<ApiResult<dynamic>> call(String subscriptionId) async {
    return ApiSuccessResult(data: null);
  }
}

class FakeGetCurrentCustomerSubscriptionUseCase
    implements GetCurrentCustomerSubscriptionUseCase {
  @override
  Future<ApiResult<ProfileBillingCurrentEntity>> call() async {
    return ApiSuccessResult(
      data: const ProfileBillingCurrentEntity(emptyStateCode: ''),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeGetPaymentMethodsUseCase fakeMethodsUseCase;
  late FakeCheckoutSubscriptionUseCase fakeCheckoutUseCase;
  late FakeGetSubscriptionPaymentStatusUseCase fakeStatusUseCase;
  late FakeGetSubscriptionCalendarUseCase fakeCalendarUseCase;
  late FakeGetCurrentCustomerSubscriptionUseCase fakeCurrentSubUseCase;
  late SharedPrefHelper fakeSharedPrefs;
  late PaymentViewModel viewModel;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    fakeSharedPrefs = SharedPrefHelper(prefs);

    fakeMethodsUseCase = FakeGetPaymentMethodsUseCase();
    fakeCheckoutUseCase = FakeCheckoutSubscriptionUseCase();
    fakeStatusUseCase = FakeGetSubscriptionPaymentStatusUseCase();
    fakeCalendarUseCase = FakeGetSubscriptionCalendarUseCase();
    fakeCurrentSubUseCase = FakeGetCurrentCustomerSubscriptionUseCase();

    viewModel = PaymentViewModel(
      fakeMethodsUseCase,
      fakeCheckoutUseCase,
      fakeStatusUseCase,
      fakeCalendarUseCase,
      fakeCurrentSubUseCase,
      fakeSharedPrefs,
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  PaymentArgs buildPaymentArgs({
    double finalPrice = 200.0,
    String? promoCode = 'SAVE20',
  }) {
    return PaymentArgs(
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
    test('PaymentCheckoutRequestDto JSON includes promoCode only when not null', () {
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
    });

    test('PaymentCheckoutRequestEntity maps promoCode to PaymentCheckoutRequestDto', () {
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
    });

    test('LoadPaymentEvent passes latest summary.finalPrice to GetPaymentMethodsUseCase', () async {
      final args = buildPaymentArgs(finalPrice: 175.5);
      viewModel.doIntent(LoadPaymentEvent(args));
      await Future<void>.delayed(Duration.zero);

      expect(fakeMethodsUseCase.lastRequestedAmount, equals(175.5));
    });

    test('stale payment methods load response is discarded by generation guard', () async {
      final completer1 = Completer<ApiResult<List<PaymentMethodEntity>>>();
      fakeMethodsUseCase.completer = completer1;

      // Start first load (generation 1)
      final args1 = buildPaymentArgs(finalPrice: 200.0);
      viewModel.doIntent(LoadPaymentEvent(args1));
      await Future<void>.delayed(Duration.zero);

      // Start second load (generation 2) with different methods
      final completer2 = Completer<ApiResult<List<PaymentMethodEntity>>>();
      fakeMethodsUseCase.completer = completer2;
      final args2 = buildPaymentArgs(finalPrice: 150.0);
      viewModel.doIntent(LoadPaymentEvent(args2));
      await Future<void>.delayed(Duration.zero);

      // Complete second load first
      completer2.complete(
        ApiSuccessResult(
          data: const [
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
        ApiSuccessResult(
          data: const [
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
    });

    test('CheckoutPaymentEvent propagates promoCode from summaryRequest', () async {
      final args = buildPaymentArgs(finalPrice: 180.0, promoCode: 'SUMMER30');
      viewModel.doIntent(LoadPaymentEvent(args));
      await Future<void>.delayed(Duration.zero);

      viewModel.doIntent(CheckoutPaymentEvent(args));
      await Future<void>.delayed(Duration.zero);

      expect(fakeCheckoutUseCase.lastRequest, isNotNull);
      expect(fakeCheckoutUseCase.lastRequest!.promoCode, equals('SUMMER30'));
    });

    test('CheckoutPaymentEvent blocks zero-amount checkout with couponFullDiscountUnsupported', () async {
      final args = buildPaymentArgs(finalPrice: 0.0, promoCode: 'FREE100');
      viewModel.doIntent(LoadPaymentEvent(args));
      await Future<void>.delayed(Duration.zero);

      viewModel.doIntent(CheckoutPaymentEvent(args));
      await Future<void>.delayed(Duration.zero);

      // Checkout use case should NOT have been called
      expect(fakeCheckoutUseCase.lastRequest, isNull);
      expect(viewModel.state.isCouponCheckoutFailure, isTrue);
      expect(
        viewModel.state.checkoutFailure?.code,
        equals(SubscriptionErrorCodes.couponFullDiscountUnsupported),
      );
    });

    test('PaymentState detects coupon rejection failures accurately', () {
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

      final stateWithRejection = PaymentState(
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

      final stateWithNetwork = PaymentState(
        checkoutFailure: networkFailure,
      );
      expect(stateWithNetwork.isCouponCheckoutFailure, isFalse);
    });
  });
}
