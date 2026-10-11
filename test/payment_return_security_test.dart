import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_calendar_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_payment_status_usecase.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fixtures/payment_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockPaymentMethodsUseCase mockPaymentMethodsUseCase;
  late _MockCheckoutSubscriptionUseCase mockCheckoutUseCase;
  late _MockGetSubscriptionPaymentStatusUseCase mockStatusUseCase;
  late _MockGetSubscriptionCalendarUseCase mockCalendarUseCase;
  late _MockGetCurrentSubscriptionUseCase mockCurrentSubUseCase;
  late SharedPrefHelper mockSharedPrefHelper;
  late PaymentViewModel viewModel;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    mockSharedPrefHelper = SharedPrefHelper(prefs);

    mockPaymentMethodsUseCase = _MockPaymentMethodsUseCase();
    mockCheckoutUseCase = _MockCheckoutSubscriptionUseCase();
    mockStatusUseCase = _MockGetSubscriptionPaymentStatusUseCase();
    mockCalendarUseCase = _MockGetSubscriptionCalendarUseCase();
    mockCurrentSubUseCase = _MockGetCurrentSubscriptionUseCase();

    viewModel = PaymentViewModel(
      mockPaymentMethodsUseCase,
      mockCheckoutUseCase,
      mockStatusUseCase,
      mockCalendarUseCase,
      mockCurrentSubUseCase,
      mockSharedPrefHelper,
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  PaymentArgs buildPaymentArgs({double finalPrice = 100.0}) {
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
        basePrice: 100,
        campaignDiscount: 0,
        promoDiscount: 0,
        walletCredit: 0,
        gatewayFee: 0,
        finalPrice: finalPrice,
        currencyCode: 'KWD',
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
      summaryRequest: const SubscriptionSummaryRequestEntity(
        programId: 'prog-1',
        bundleId: 'bundle-1',
        tier: 'Standard',
        durationDays: 12,
        startDate: '2026-10-10',
        includeFriday: false,
      ),
      restaurantId: 'rest-1',
    );
  }

  group('Payment Return Security Tests', () {
    test(
      'spoofed success return link does not fulfill payment when server status is unpaid',
      () async {
        mockStatusUseCase.response = const ApiSuccessResult(
          data: PaymentStatusEntity(
            paymentStatus: 'Pending',
            isPaid: false,
            isFailed: false,
            amount: 100,
            currencyCode: 'KWD',
          ),
        );

        // Initialize checkout
        mockCheckoutUseCase.response = const ApiSuccessResult(
          data: PaymentCheckoutEntity(
            subscriptionId: 'sub-123',
            paymentUrl: 'https://payzah.net/checkout/123',
            holdExpiresAtUtc: '',
            chosenStartDate: '',
            startDate: '2026-10-10',
            finalPrice: 100,
            priceSnapshotId: '',
            restaurantPoolSnapshotId: '',
            paymentStatus: 'Pending',
          ),
        );

        viewModel.doIntent(
          const SelectPaymentMethodEvent(
            PaymentMethodEntity(
              id: 3,
              type: PaymentMethodType.payzah,
              title: 'Payzah',
              subtitle: '',
              isAvailable: true,
            ),
          ),
        );
        viewModel.doIntent(CheckoutPaymentEvent(buildPaymentArgs()));
        await Future<void>.delayed(Duration.zero);

        // Incoming spoofed return
        const spoofedReturn = PaymentReturn(
          destination: PaymentReturnDestination.success,
          paymentId: 'pz-track-spoofed',
        );

        viewModel.doIntent(const HandlePaymentReturnEvent(spoofedReturn));
        await Future<void>.delayed(Duration.zero);

        // Verify that fulfillment is NOT marked success
        expect(viewModel.state.isFulfillmentSuccess, isFalse);
      },
    );

    test(
      'review return immediately blocks new payments and sets isReviewRequired',
      () async {
        mockStatusUseCase.response = const ApiSuccessResult(
          data: PaymentStatusEntity(
            paymentStatus: 'SuspendedForReview',
            isPaid: false,
            isFailed: false,
            amount: 100,
            currencyCode: 'KWD',
          ),
        );

        mockCheckoutUseCase.response = const ApiSuccessResult(
          data: PaymentCheckoutEntity(
            subscriptionId: 'sub-review-123',
            paymentUrl: 'https://payzah.net/checkout/123',
            holdExpiresAtUtc: '',
            chosenStartDate: '',
            startDate: '2026-10-10',
            finalPrice: 100,
            priceSnapshotId: '',
            restaurantPoolSnapshotId: '',
            paymentStatus: 'Pending',
          ),
        );

        viewModel.doIntent(
          const SelectPaymentMethodEvent(
            PaymentMethodEntity(
              id: 3,
              type: PaymentMethodType.payzah,
              title: 'Payzah',
              subtitle: '',
              isAvailable: true,
            ),
          ),
        );
        viewModel.doIntent(CheckoutPaymentEvent(buildPaymentArgs()));
        await Future<void>.delayed(Duration.zero);

        const reviewReturn = PaymentReturn(
          destination: PaymentReturnDestination.review,
          paymentId: 'pz-track-review-1',
        );
        viewModel.doIntent(const HandlePaymentReturnEvent(reviewReturn));
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.state.isReviewRequired, isTrue);

        final initialCalls = mockCheckoutUseCase.callCount;
        viewModel.doIntent(CheckoutPaymentEvent(buildPaymentArgs()));
        await Future<void>.delayed(Duration.zero);
        expect(mockCheckoutUseCase.callCount, equals(initialCalls));
      },
    );

    test(
      'review state cannot be cleared by subsequent spoofed error or success return',
      () async {
        viewModel.doIntent(
          const HandlePaymentReturnEvent(
            PaymentReturn(
              destination: PaymentReturnDestination.review,
              paymentId: 'pz-track-1',
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(viewModel.state.isReviewRequired, isTrue);

        // Subsequent forged error return
        viewModel.doIntent(
          const HandlePaymentReturnEvent(
            PaymentReturn(
              destination: PaymentReturnDestination.error,
              paymentId: 'pz-track-1',
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(viewModel.state.isReviewRequired, isTrue);

        // Subsequent forged success return
        viewModel.doIntent(
          const HandlePaymentReturnEvent(
            PaymentReturn(
              destination: PaymentReturnDestination.success,
              paymentId: 'pz-track-1',
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(viewModel.state.isReviewRequired, isTrue);
      },
    );

    test('error return cannot override an already accepted payment', () async {
      mockStatusUseCase.response = const ApiSuccessResult(
        data: PaymentStatusEntity(
          paymentStatus: 'Paid',
          isPaid: true,
          isFailed: false,
          amount: 100,
          currencyCode: 'KWD',
        ),
      );

      viewModel.doIntent(const VerifyPaymentFulfillmentEvent('sub-accepted-1'));
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.isFulfillmentSuccess, isTrue);

      // Late error return arrived
      viewModel.doIntent(
        const HandlePaymentReturnEvent(
          PaymentReturn(
            destination: PaymentReturnDestination.error,
            paymentId: 'pz-track-late-err',
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isFulfillmentSuccess, isTrue);
      expect(viewModel.state.isPaymentFailed, isFalse);
    });

    test('duplicate checkout clicks while loading are debounced', () async {
      final completer = Completer<ApiResult<PaymentCheckoutEntity>>();
      mockCheckoutUseCase.futureOverride = completer.future;

      viewModel.doIntent(
        const SelectPaymentMethodEvent(
          PaymentMethodEntity(
            id: 3,
            type: PaymentMethodType.payzah,
            title: 'Payzah',
            subtitle: '',
            isAvailable: true,
          ),
        ),
      );

      viewModel.doIntent(CheckoutPaymentEvent(buildPaymentArgs()));
      viewModel.doIntent(CheckoutPaymentEvent(buildPaymentArgs()));
      viewModel.doIntent(CheckoutPaymentEvent(buildPaymentArgs()));

      expect(mockCheckoutUseCase.callCount, equals(1));
      completer.complete(
        const ApiSuccessResult(
          data: PaymentCheckoutEntity(
            subscriptionId: 'sub-1',
            paymentUrl: 'https://payzah.net/checkout/1',
            holdExpiresAtUtc: '',
            chosenStartDate: '',
            startDate: '',
            finalPrice: 100,
            priceSnapshotId: '',
            restaurantPoolSnapshotId: '',
            paymentStatus: '',
          ),
        ),
      );
    });
  });
}

class _MockPaymentMethodsUseCase implements GetPaymentMethodsUseCase {
  @override
  Future<ApiResult<List<PaymentMethodEntity>>> call({double? amount}) async {
    return const ApiSuccessResult(data: []);
  }
}

class _MockCheckoutSubscriptionUseCase implements CheckoutSubscriptionUseCase {
  ApiResult<PaymentCheckoutEntity> response = const ApiSuccessResult(
    data: PaymentCheckoutEntity(
      subscriptionId: 'sub-1',
      paymentUrl: 'https://payzah.net/checkout/1',
      holdExpiresAtUtc: '',
      chosenStartDate: '',
      startDate: '',
      finalPrice: 100,
      priceSnapshotId: '',
      restaurantPoolSnapshotId: '',
      paymentStatus: '',
    ),
  );
  Future<ApiResult<PaymentCheckoutEntity>>? futureOverride;
  int callCount = 0;

  @override
  Future<ApiResult<PaymentCheckoutEntity>> call(
    PaymentCheckoutRequestEntity request,
  ) {
    callCount++;
    return futureOverride ?? Future.value(response);
  }
}

class _MockGetSubscriptionPaymentStatusUseCase
    implements GetSubscriptionPaymentStatusUseCase {
  ApiResult<PaymentStatusEntity> response = const ApiSuccessResult(
    data: PaymentStatusEntity(
      paymentStatus: 'Paid',
      isPaid: true,
      isFailed: false,
      amount: 100,
      currencyCode: 'KWD',
    ),
  );

  @override
  Future<ApiResult<PaymentStatusEntity>> call(String subscriptionId) async {
    return response;
  }
}

class _MockGetSubscriptionCalendarUseCase
    implements GetSubscriptionCalendarUseCase {
  @override
  Future<ApiResult<dynamic>> call(String subscriptionId) async =>
      const ApiSuccessResult(data: true);
}

class _MockGetCurrentSubscriptionUseCase
    implements GetCurrentCustomerSubscriptionUseCase {
  ApiResult<SubscriptionBillingCurrentEntity> response = ApiSuccessResult(
    data: PaymentFixtures.activeCurrentEntity(),
  );

  @override
  Future<ApiResult<SubscriptionBillingCurrentEntity>> call() async => response;
}
