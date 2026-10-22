import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class CountingGetPaymentMethodsUseCase implements GetPaymentMethodsUseCase {
  int callCount = 0;
  List<PaymentMethodEntity> returnMethods = [];

  @override
  Future<ApiResult<List<PaymentMethodEntity>>> call({double? amount}) async {
    callCount++;
    return ApiSuccessResult(data: returnMethods);
  }
}

class SpyCheckoutSubscriptionUseCase implements CheckoutSubscriptionUseCase {
  int callCount = 0;
  PaymentCheckoutRequestEntity? lastRequest;

  @override
  Future<ApiResult<PaymentCheckoutEntity>> call(
    PaymentCheckoutRequestEntity request,
  ) async {
    callCount++;
    lastRequest = request;
    return const ApiSuccessResult(
      data: PaymentCheckoutEntity(
        subscriptionId: 'sub-1',
        paymentUrl: 'https://sandbox.payzah.net/pay',
        holdExpiresAtUtc: '2026-10-08T00:00:00Z',
        chosenStartDate: '2026-10-10',
        startDate: '2026-10-10',
        finalPrice: 50.0,
        priceSnapshotId: 'snap-1',
        restaurantPoolSnapshotId: 'pool-1',
        paymentStatus: 'PendingPayment',
        paymentId: 'pz-track-1',
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CountingGetPaymentMethodsUseCase methodsUseCase;
  late SpyCheckoutSubscriptionUseCase checkoutUseCase;
  late SubscriptionCheckoutViewModel viewModel;

  setUp(() async {
    methodsUseCase = CountingGetPaymentMethodsUseCase();
    checkoutUseCase = SpyCheckoutSubscriptionUseCase();

    viewModel = SubscriptionCheckoutViewModel(methodsUseCase, checkoutUseCase);
  });

  tearDown(() async {
    await viewModel.close();
  });

  SubscriptionCheckoutArgs createSubscriptionCheckoutArgs({
    double price = 50.0,
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
        tier: 'Standard',
        tierNameAr: 'عادي',
        tierNameEn: 'Standard',
        durationDays: 14,
        chosenStartDate: '2026-10-10',
        startDate: '2026-10-10',
        endDate: '2026-10-24',
        serviceDates: const ['2026-10-10'],
        slotRequirements: const [],
        basePrice: price,
        campaignDiscount: 0,
        promoDiscount: 0,
        walletCredit: 0,
        gatewayFee: 0,
        finalPrice: price,
        currencyCode: 'KWD',
        canCheckout: true,
        restaurants: const [],
        termsAcceptanceRequired: false,
        checkoutEndpoint: '/checkout',
        includeFriday: false,
        fridayDays: 0,
        totalServiceDays: 14,
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
        durationDays: 14,
        startDate: '2026-10-10',
        includeFriday: false,
      ),
      restaurantId: 'rest-1',
    );
  }

  group('Payment Methods Refresh & Selection Tests', () {
    test(
      'wallet with null id is disabled and selection/checkout ignores it',
      () async {
        const walletMethod = PaymentMethodEntity(
          id: null,
          type: PaymentMethodType.wallet,
          title: 'MealMate Wallet',
          subtitle: 'Unavailable',
          isAvailable: false,
          unavailableReason: 'wallet_not_implemented',
        );
        const payzahMethod = PaymentMethodEntity(
          id: 7,
          type: PaymentMethodType.payzah,
          title: 'Payzah hosted',
          subtitle: 'Pay securely',
          isAvailable: true,
        );

        methodsUseCase.returnMethods = [walletMethod, payzahMethod];

        final args = createSubscriptionCheckoutArgs();
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args));

        await pumpEventQueue();

        expect(viewModel.state.methods.length, 2);
        expect(viewModel.state.selectedMethod?.id, 7);

        // Attempt to select disabled wallet method
        viewModel.doIntent(
          const SelectCheckoutPaymentMethodEvent(walletMethod),
        );
        await pumpEventQueue();

        // Selected method must remain Payzah
        expect(viewModel.state.selectedMethod?.id, 7);

        // Trigger checkout
        viewModel.doIntent(SubmitSubscriptionCheckoutEvent(args));
        await pumpEventQueue();

        // Checkout called once with Payzah ID 7
        expect(checkoutUseCase.callCount, 1);
        expect(checkoutUseCase.lastRequest?.paymentMethodId, 7);
      },
    );

    test(
      'opening screen twice sends two requests and replaces old selection',
      () async {
        const initialMethod = PaymentMethodEntity(
          id: 3,
          type: PaymentMethodType.payzah,
          title: 'Payzah initial',
          subtitle: '',
          isAvailable: true,
        );
        methodsUseCase.returnMethods = [initialMethod];

        final args1 = createSubscriptionCheckoutArgs();
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args1));
        await pumpEventQueue();

        expect(methodsUseCase.callCount, 1);
        expect(viewModel.state.selectedMethod?.id, 3);

        // Second route entry / refresh
        const newMethod = PaymentMethodEntity(
          id: 9,
          type: PaymentMethodType.payzah,
          title: 'Payzah updated',
          subtitle: '',
          isAvailable: true,
        );
        methodsUseCase.returnMethods = [newMethod];

        final args2 = createSubscriptionCheckoutArgs();
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args2));
        await pumpEventQueue();

        expect(methodsUseCase.callCount, 2);
        expect(viewModel.state.selectedMethod?.id, 9);
        expect(viewModel.state.methods.first.id, 9);
      },
    );

    test(
      'retained checkout prevents repost until terminal failure resets with fresh idempotency',
      () async {
        methodsUseCase.returnMethods = const [
          PaymentMethodEntity(
            id: 5,
            type: PaymentMethodType.payzah,
            title: 'Payzah',
            subtitle: '',
            isAvailable: true,
          ),
        ];
        final args = createSubscriptionCheckoutArgs();
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args));
        await pumpEventQueue();
        viewModel.doIntent(SubmitSubscriptionCheckoutEvent(args));
        await pumpEventQueue();
        final retainedCheckout = viewModel.state.checkout;
        final originalKey = checkoutUseCase.lastRequest?.idempotencyKey;
        expect(retainedCheckout, isNotNull);
        expect(originalKey, isNotEmpty);

        // A plain return from the gateway retains the session for reopening.
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args));
        viewModel.doIntent(SubmitSubscriptionCheckoutEvent(args));
        await pumpEventQueue();
        expect(checkoutUseCase.callCount, 1);
        expect(viewModel.state.checkout, same(retainedCheckout));
        expect(checkoutUseCase.lastRequest?.idempotencyKey, originalKey);

        // Only the server-confirmed failure path releases the old checkout.
        viewModel.doIntent(const ResetSubscriptionCheckoutAfterFailureEvent());
        expect(viewModel.state.checkout, isNull);
        expect(viewModel.state.pendingSubscriptionId, isNull);
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args));
        await pumpEventQueue();
        viewModel.doIntent(SubmitSubscriptionCheckoutEvent(args));
        await pumpEventQueue();
        expect(checkoutUseCase.callCount, 2);
        expect(checkoutUseCase.lastRequest?.idempotencyKey, isNotEmpty);
        expect(checkoutUseCase.lastRequest?.idempotencyKey, isNot(originalKey));
      },
    );

    test(
      'rebuild/re-reading state without LoadSubscriptionCheckoutEvent does not trigger extra calls',
      () async {
        methodsUseCase.returnMethods = [
          const PaymentMethodEntity(
            id: 5,
            type: PaymentMethodType.payzah,
            title: 'Payzah',
            subtitle: '',
            isAvailable: true,
          ),
        ];

        final args = createSubscriptionCheckoutArgs();
        viewModel.doIntent(LoadSubscriptionCheckoutEvent(args));
        await pumpEventQueue();

        expect(methodsUseCase.callCount, 1);

        // Simulating UI rebuild by accessing state
        expect(viewModel.state.methods.length, 1);
        expect(methodsUseCase.callCount, 1);
      },
    );
  });
}
