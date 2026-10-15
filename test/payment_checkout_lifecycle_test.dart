import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/payment/payment_attempt.dart';
import 'package:meal_meat_user/core/payment/payment_attempt_store.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
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
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_billing_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fixtures/payment_fixtures.dart';

class _FakeStore implements PaymentAttemptStore {
  PaymentAttempt? attempt;
  bool shouldThrow = false;

  @override
  Future<PaymentAttempt?> readForCustomer(String customerId) async {
    if (shouldThrow) throw Exception('Storage error');
    if (attempt?.ownerCustomerId == customerId) return attempt;
    return null;
  }

  @override
  Future<void> save(PaymentAttempt attempt) async {
    if (shouldThrow) throw Exception('Storage write error');
    this.attempt = attempt;
  }

  @override
  Future<void> removeForCustomer(String customerId) async {
    if (attempt?.ownerCustomerId == customerId) attempt = null;
  }
}

class _FakeTokenService implements TokenService {
  String? userId = 'cust-123';

  @override
  Future<String?> getCurrentUserId() async => userId;

  @override
  Future<bool> hasValidSessionTokens() async => userId != null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeMethodsUseCase implements GetPaymentMethodsUseCase {
  @override
  Future<ApiResult<List<PaymentMethodEntity>>> call({
    required double amount,
  }) async => const ApiSuccessResult(data: []);
}

class _FakeCheckoutUseCase implements CheckoutSubscriptionUseCase {
  int callCount = 0;
  ApiResult<PaymentCheckoutEntity> response = const ApiSuccessResult(
    data: PaymentCheckoutEntity(
      subscriptionId: 'sub-test-1',
      paymentUrl: 'https://payzah.net/checkout/1',
      holdExpiresAtUtc: '',
      chosenStartDate: '',
      startDate: '2026-10-10',
      finalPrice: 100,
      priceSnapshotId: '',
      restaurantPoolSnapshotId: '',
      paymentStatus: 'Pending',
      paymentId: 'pz-attempt-1',
    ),
  );

  @override
  Future<ApiResult<PaymentCheckoutEntity>> call(
    PaymentCheckoutRequestEntity request,
  ) async {
    callCount++;
    return response;
  }
}

class _FakeStatusUseCase implements GetSubscriptionPaymentStatusUseCase {
  List<ApiResult<PaymentStatusEntity>> statusQueue = [];
  ApiResult<PaymentStatusEntity> defaultResponse = const ApiSuccessResult(
    data: PaymentStatusEntity(
      paymentStatus: 'PendingPayment',
      isPaid: false,
      isFailed: false,
      amount: 100,
      currencyCode: 'KWD',
    ),
  );

  @override
  Future<ApiResult<PaymentStatusEntity>> call(String subscriptionId) async {
    if (statusQueue.isNotEmpty) {
      return statusQueue.removeAt(0);
    }
    return defaultResponse;
  }
}

class _FakeCalendarUseCase implements GetSubscriptionCalendarUseCase {
  @override
  Future<ApiResult<dynamic>> call(String subscriptionId) async =>
      const ApiSuccessResult(data: true);
}

class _FakeCurrentSubUseCase implements GetCurrentCustomerSubscriptionUseCase {
  List<ApiResult<SubscriptionBillingCurrentEntity>> queue = [];
  ApiResult<SubscriptionBillingCurrentEntity> defaultResponse =
      ApiSuccessResult(data: PaymentFixtures.activeCurrentEntity());

  @override
  Future<ApiResult<SubscriptionBillingCurrentEntity>> call() async {
    if (queue.isNotEmpty) {
      return queue.removeAt(0);
    }
    return defaultResponse;
  }
}

class _FakeBillingUseCase implements GetSubscriptionBillingUseCase {
  @override
  Future<ApiResult<SubscriptionBillingEntity>> call() async =>
      const ApiSuccessResult(
        data: SubscriptionBillingEntity(
          current: SubscriptionBillingCurrentEntity(emptyStateCode: ''),
          invoices: [],
          paymentMethod: SubscriptionBillingPaymentMethodEntity(
            hasSavedMethod: false,
            brand: '',
            last4: '',
            expiry: '',
            gateway: '',
            emptyStateCode: '',
          ),
          freezePolicy: SubscriptionBillingFreezePolicyEntity.empty,
        ),
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeStore fakeStore;
  late _FakeTokenService fakeTokenService;
  late _FakeMethodsUseCase fakeMethodsUseCase;
  late _FakeCheckoutUseCase fakeCheckoutUseCase;
  late _FakeStatusUseCase fakeStatusUseCase;
  late _FakeCalendarUseCase fakeCalendarUseCase;
  late _FakeCurrentSubUseCase fakeCurrentSubUseCase;
  late _FakeBillingUseCase fakeBillingUseCase;
  late SharedPrefHelper fakeSharedPrefHelper;
  late PaymentViewModel viewModel;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    fakeSharedPrefHelper = SharedPrefHelper(prefs);

    fakeStore = _FakeStore();
    fakeTokenService = _FakeTokenService();
    fakeMethodsUseCase = _FakeMethodsUseCase();
    fakeCheckoutUseCase = _FakeCheckoutUseCase();
    fakeStatusUseCase = _FakeStatusUseCase();
    fakeCalendarUseCase = _FakeCalendarUseCase();
    fakeCurrentSubUseCase = _FakeCurrentSubUseCase();
    fakeBillingUseCase = _FakeBillingUseCase();

    viewModel = PaymentViewModel(
      fakeMethodsUseCase,
      fakeCheckoutUseCase,
      fakeStatusUseCase,
      fakeCalendarUseCase,
      fakeCurrentSubUseCase,
      fakeSharedPrefHelper,
      paymentAttemptStore: fakeStore,
      tokenService: fakeTokenService,
      getSubscriptionBillingUseCase: fakeBillingUseCase,
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

  group('Payment Checkout Lifecycle & State Machine Tests', () {
    test(
      'successful checkout stores PaymentAttempt before gateway navigation',
      () async {
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

        expect(viewModel.state.checkout, isNotNull);
        expect(fakeStore.attempt, isNotNull);
        expect(fakeStore.attempt!.subscriptionId, equals('sub-test-1'));
        expect(fakeStore.attempt!.paymentId, equals('pz-attempt-1'));
        expect(fakeStore.attempt!.ownerCustomerId, equals('cust-123'));
        expect(fakeStore.attempt!.reviewRequired, isFalse);
      },
    );

    test(
      'failure to store PaymentAttempt aborts checkout and reports error',
      () async {
        fakeStore.shouldThrow = true;

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

        expect(viewModel.state.checkout, isNull);
        expect(viewModel.state.checkoutFailure, isNotNull);
        expect(
          viewModel.state.checkoutFailure!.code,
          equals('checkout.attempt_persistence_failed'),
        );
      },
    );

    test(
      'transitions PendingPayment -> Paid -> Active fulfill subscription',
      () async {
        fakeStore.attempt = PaymentAttempt(
          schemaVersion: 1,
          ownerCustomerId: 'cust-123',
          subscriptionId: 'sub-test-1',
          paymentId: 'pz-attempt-1',
          createdAtUtc: DateTime.now().toUtc(),
        );
        fakeStatusUseCase.defaultResponse = const ApiSuccessResult(
          data: PaymentStatusEntity(
            paymentStatus: 'Paid',
            isPaid: true,
            isFailed: false,
            amount: 100,
            currencyCode: 'KWD',
          ),
        );
        fakeCurrentSubUseCase.defaultResponse = ApiSuccessResult(
          data: PaymentFixtures.activeCurrentEntity(
            subscriptionId: 'sub-test-1',
          ),
        );

        viewModel.doIntent(const VerifyPaymentFulfillmentEvent('sub-test-1'));
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.state.isFulfillmentSuccess, isTrue);
        expect(viewModel.state.isPaymentFailed, isFalse);
        expect(fakeStore.attempt?.lastPresentedFinalStatus, equals('active'));
      },
    );

    test(
      'review link sets conservative reviewRequired and persists lock',
      () async {
        fakeStore.attempt = PaymentAttempt(
          schemaVersion: 1,
          ownerCustomerId: 'cust-123',
          subscriptionId: 'sub-test-1',
          paymentId: 'pz-attempt-1',
          createdAtUtc: DateTime.now().toUtc(),
          reviewRequired: false,
        );

        fakeStatusUseCase.defaultResponse = const ApiSuccessResult(
          data: PaymentStatusEntity(
            paymentStatus: 'SuspendedForReview',
            isPaid: false,
            isFailed: false,
            amount: 100,
            currencyCode: 'KWD',
          ),
        );

        viewModel.doIntent(
          const HandlePaymentReturnEvent(
            PaymentReturn(
              destination: PaymentReturnDestination.review,
              paymentId: 'pz-attempt-1',
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.state.isReviewRequired, isTrue);
        expect(fakeStore.attempt?.reviewRequired, isTrue);
      },
    );

    test(
      'server terminal PaymentFailed lifts reviewRequired lock and shows failure',
      () async {
        fakeStore.attempt = PaymentAttempt(
          schemaVersion: 1,
          ownerCustomerId: 'cust-123',
          subscriptionId: 'sub-test-1',
          paymentId: 'pz-attempt-1',
          createdAtUtc: DateTime.now().toUtc(),
          reviewRequired: true,
        );

        fakeStatusUseCase.defaultResponse = const ApiSuccessResult(
          data: PaymentStatusEntity(
            paymentStatus: 'PaymentFailed',
            isPaid: false,
            isFailed: true,
            amount: 100,
            currencyCode: 'KWD',
          ),
        );

        viewModel.doIntent(const VerifyPaymentFulfillmentEvent('sub-test-1'));
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.state.isPaymentFailed, isTrue);
        expect(viewModel.state.isReviewRequired, isFalse);
        expect(fakeStore.attempt?.reviewRequired, isFalse);
        expect(fakeStore.attempt?.lastPresentedFinalStatus, equals('failed'));
      },
    );

    test(
      'network 5xx error during review preserves reviewRequired lock',
      () async {
        fakeStore.attempt = PaymentAttempt(
          schemaVersion: 1,
          ownerCustomerId: 'cust-123',
          subscriptionId: 'sub-test-1',
          paymentId: 'pz-attempt-1',
          createdAtUtc: DateTime.now().toUtc(),
          reviewRequired: true,
        );

        fakeStatusUseCase.defaultResponse = ApiErrorResult(
          failure: ServerFailure(
            code: 'server_error',
            errorMessage: 'Server 500 error',
            exception: const ApiException(
              message: 'Server error',
              statusCode: 500,
              errorType: ApiErrorType.serverError,
            ),
          ),
        );

        viewModel.doIntent(
          const HandlePaymentReturnEvent(
            PaymentReturn(
              destination: PaymentReturnDestination.review,
              paymentId: 'pz-attempt-1',
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.state.isReviewRequired, isTrue);
        expect(fakeStore.attempt?.reviewRequired, isTrue);
      },
    );
  });
}
