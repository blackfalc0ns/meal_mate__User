import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
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
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_payment_methods_usecase.dart';
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
  Completer<void>? saveGate;

  @override
  Future<PaymentAttempt?> readForCustomer(String customerId) async {
    if (shouldThrow) throw Exception('Storage error');
    if (attempt?.ownerCustomerId == customerId) return attempt;
    return null;
  }

  @override
  Future<void> save(PaymentAttempt attempt) async {
    if (shouldThrow) throw Exception('Storage write error');
    if (saveGate != null) await saveGate!.future;
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
  late SubscriptionCheckoutViewModel checkoutViewModel;

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

    checkoutViewModel = SubscriptionCheckoutViewModel(
      fakeMethodsUseCase,
      fakeCheckoutUseCase,
    );
    viewModel = PaymentViewModel(
      fakeStatusUseCase,
      fakeCalendarUseCase,
      fakeSharedPrefHelper,
      paymentAttemptStore: fakeStore,
      tokenService: fakeTokenService,
      getSubscriptionBillingUseCase: fakeBillingUseCase,
    );
  });

  tearDown(() async {
    await checkoutViewModel.close();
    await viewModel.close();
  });

  SubscriptionCheckoutArgs buildSubscriptionCheckoutArgs({
    double finalPrice = 100.0,
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

  Future<void> submitCheckout() async {
    checkoutViewModel.doIntent(
      SubmitSubscriptionCheckoutEvent(buildSubscriptionCheckoutArgs()),
    );
    await pumpEventQueue();
    final checkout = checkoutViewModel.state.checkout;
    if (checkout != null) {
      viewModel.doIntent(InitCheckoutSessionEvent(checkout));
      await pumpEventQueue();
    }
  }

  group('Payment Checkout Lifecycle & State Machine Tests', () {
    test(
      'successful checkout stores PaymentAttempt before gateway navigation',
      () async {
        checkoutViewModel.doIntent(
          const SelectCheckoutPaymentMethodEvent(
            PaymentMethodEntity(
              id: 3,
              type: PaymentMethodType.payzah,
              title: 'Payzah',
              subtitle: '',
              isAvailable: true,
            ),
          ),
        );

        await submitCheckout();
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
      'gateway session is ready only after recovery persistence completes',
      () async {
        fakeStore.saveGate = Completer<void>();
        final response =
            fakeCheckoutUseCase.response
                as ApiSuccessResult<PaymentCheckoutEntity>;
        viewModel.doIntent(InitCheckoutSessionEvent(response.data));
        await pumpEventQueue();
        expect(viewModel.state.isSessionInitializing, isTrue);
        expect(viewModel.state.isSessionReady, isFalse);
        expect(fakeStore.attempt, isNull);

        fakeStore.saveGate!.complete();
        await pumpEventQueue();
        expect(viewModel.state.isSessionInitializing, isFalse);
        expect(viewModel.state.isSessionReady, isTrue);
        expect(fakeStore.attempt?.paymentId, 'pz-attempt-1');
      },
    );

    test(
      'failure to store PaymentAttempt aborts checkout and reports error',
      () async {
        fakeStore.shouldThrow = true;

        checkoutViewModel.doIntent(
          const SelectCheckoutPaymentMethodEvent(
            PaymentMethodEntity(
              id: 3,
              type: PaymentMethodType.payzah,
              title: 'Payzah',
              subtitle: '',
              isAvailable: true,
            ),
          ),
        );

        await submitCheckout();
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.state.checkout, isNull);
        expect(viewModel.state.checkoutFailure, isNotNull);
        expect(viewModel.state.isSessionReady, isFalse);
        expect(
          viewModel.state.checkoutFailure!.code,
          equals('checkout.attempt_persistence_failed'),
        );
      },
    );

    for (final missingOwner in [false, true]) {
      test(
        'gateway session rejects missing ${missingOwner ? "owner" : "payment handle"}',
        () async {
          fakeTokenService.userId = missingOwner ? null : 'cust-123';
          final checkout = PaymentCheckoutEntity(
            subscriptionId: 'sub-test-1',
            paymentUrl: 'https://payzah.net/checkout/1',
            holdExpiresAtUtc: '',
            chosenStartDate: '',
            startDate: '',
            finalPrice: 100,
            priceSnapshotId: '',
            restaurantPoolSnapshotId: '',
            paymentStatus: 'PendingPayment',
            paymentId: missingOwner ? 'pz-attempt-1' : null,
          );
          viewModel.doIntent(InitCheckoutSessionEvent(checkout));
          await pumpEventQueue();
          expect(viewModel.state.isSessionReady, isFalse);
          expect(viewModel.state.isSessionInitializing, isFalse);
          expect(
            viewModel.state.checkoutFailure?.code,
            'checkout.attempt_persistence_failed',
          );
          expect(fakeStore.attempt, isNull);
        },
      );
    }

    for (final matching in [false, true]) {
      test(
        'session preserves review only for matching stored attempt ($matching)',
        () async {
          fakeStore.attempt = PaymentAttempt(
            schemaVersion: 1,
            ownerCustomerId: 'cust-123',
            subscriptionId: matching ? 'sub-test-1' : 'unrelated-subscription',
            paymentId: matching ? 'pz-attempt-1' : 'unrelated-payment',
            createdAtUtc: DateTime.now().toUtc(),
            reviewRequired: true,
          );
          final response =
              fakeCheckoutUseCase.response
                  as ApiSuccessResult<PaymentCheckoutEntity>;
          viewModel.doIntent(InitCheckoutSessionEvent(response.data));
          await pumpEventQueue();
          expect(viewModel.state.isSessionReady, isTrue);
          expect(viewModel.state.isReviewRequired, matching);
          expect(fakeStore.attempt?.subscriptionId, 'sub-test-1');
          expect(fakeStore.attempt?.paymentId, 'pz-attempt-1');
          expect(fakeStore.attempt?.reviewRequired, matching);
        },
      );
    }

    for (final status in ['SuspendedForReview', 'PaymentFailed', 'Paid']) {
      test(
        'no-ID recovery for subscription B preserves unrelated attempt A on $status',
        () async {
          final unrelated = PaymentAttempt(
            schemaVersion: 1,
            ownerCustomerId: 'cust-123',
            subscriptionId: 'subscription-A',
            paymentId: 'payment-A',
            createdAtUtc: DateTime.utc(2026, 10, 22),
            reviewRequired: true,
          );
          fakeStore.attempt = unrelated;
          fakeStatusUseCase.defaultResponse = ApiSuccessResult(
            data: PaymentStatusEntity(
              paymentStatus: status,
              isPaid: status == 'Paid',
              isFailed: status == 'PaymentFailed',
              amount: 100,
              currencyCode: 'KWD',
            ),
          );
          viewModel.doIntent(
            const InitCheckoutSessionEvent(
              PaymentCheckoutEntity(
                subscriptionId: 'subscription-B',
                paymentUrl: '',
                holdExpiresAtUtc: '',
                chosenStartDate: '',
                startDate: '',
                finalPrice: 100,
                priceSnapshotId: '',
                restaurantPoolSnapshotId: '',
                paymentStatus: 'PendingPayment',
              ),
            ),
          );
          await pumpEventQueue();
          expect(viewModel.state.checkout?.subscriptionId, 'subscription-B');
          expect(viewModel.state.paymentStatus?.paymentStatus, status);
          expect(fakeStore.attempt, same(unrelated));
          expect(fakeStore.attempt?.paymentId, 'payment-A');
          expect(fakeStore.attempt?.reviewRequired, isTrue);
          expect(fakeStore.attempt?.lastPresentedFinalStatus, isNull);
        },
      );
    }

    test(
      'review callback cannot persist review on a different payment handle',
      () async {
        final unrelated = PaymentAttempt(
          schemaVersion: 1,
          ownerCustomerId: 'cust-123',
          subscriptionId: 'subscription-A',
          paymentId: 'payment-A',
          createdAtUtc: DateTime.utc(2026, 10, 22),
          reviewRequired: false,
        );
        fakeStore.attempt = unrelated;
        viewModel.doIntent(
          const HandlePaymentReturnEvent(
            PaymentReturn(
              destination: PaymentReturnDestination.review,
              paymentId: 'payment-B',
            ),
          ),
        );
        await pumpEventQueue();
        expect(fakeStore.attempt, same(unrelated));
        expect(fakeStore.attempt?.reviewRequired, isFalse);
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
