import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_payment_status_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_calendar_usecase.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/resume_subscription_usecase.dart';

class _Status implements GetSubscriptionPaymentStatusUseCase {
  PaymentStatusEntity status = const PaymentStatusEntity(
    paymentStatus: 'Pending',
    isPaid: false,
    isFailed: false,
    amount: 100,
    currencyCode: 'KWD',
  );
  @override
  Future<ApiResult<PaymentStatusEntity>> call(String subscriptionId) async =>
      ApiSuccessResult(data: status);
}

class _Calendar implements GetSubscriptionCalendarUseCase {
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Resume implements ResumeSubscriptionUseCase {
  int calls = 0;
  String? subscriptionId;
  ApiResult<SubscriptionBillingResumeEntity> result = ApiSuccessResult(
    data: SubscriptionBillingResumeEntity(
      subscriptionId: 'subscription',
      paymentUrl: 'https://example.com/renewed',
      holdExpiresAtUtc: DateTime.utc(2026, 10, 21, 12, 30),
      serverTimeUtc: DateTime.utc(2026, 10, 21, 12, 15),
      finalPrice: 100,
      paymentStatus: 'PendingPayment',
    ),
  );
  @override
  Future<ApiResult<SubscriptionBillingResumeEntity>> call({
    required String subscriptionId,
    String? startDate,
    int? paymentMethodId,
  }) async {
    calls++;
    this.subscriptionId = subscriptionId;
    return result;
  }
}

const checkout = PaymentCheckoutEntity(
  subscriptionId: 'subscription',
  paymentUrl: 'https://example.com/expired',
  holdExpiresAtUtc: '2026-10-21T12:15:00Z',
  chosenStartDate: '2026-10-25',
  startDate: '2026-10-25',
  finalPrice: 100,
  priceSnapshotId: 'price',
  restaurantPoolSnapshotId: 'pool',
  paymentStatus: 'PendingPayment',
  paymentId: 'attempt',
);
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PaymentViewModel vm;
  late _Resume resume;
  late _Status status;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    resume = _Resume();
    status = _Status();
    vm = PaymentViewModel(
      status,
      _Calendar(),
      SharedPrefHelper(await SharedPreferences.getInstance()),
      resumeSubscriptionUseCase: resume,
    );
  });
  tearDown(() => vm.close());
  test(
    'resume renews existing subscription hold and preserves payment recovery handle',
    () async {
      vm.doIntent(const InitCheckoutSessionEvent(checkout));
      await pumpEventQueue();
      vm.doIntent(const RenewPaymentHoldEvent());
      await pumpEventQueue();
      expect(resume.subscriptionId, 'subscription');
      expect(vm.state.checkout?.paymentUrl, 'https://example.com/renewed');
      expect(
        vm.state.checkout?.serverTimeUtc,
        DateTime.utc(2026, 10, 21, 12, 15),
      );
      expect(vm.state.checkout?.paymentId, 'attempt');
      expect(vm.state.isHoldRenewing, false);
    },
  );
  test(
    'capacity conflict preserves expired checkout and exposes date recovery',
    () async {
      resume.result = ApiErrorResult(
        failure: Failure(errorMessage: '', code: 'checkout.quote_changed'),
      );
      vm.doIntent(const InitCheckoutSessionEvent(checkout));
      await pumpEventQueue();
      vm.doIntent(const RenewPaymentHoldEvent());
      await pumpEventQueue();
      expect(vm.state.isAvailabilityChangedFailure, true);
      expect(vm.state.checkout, same(checkout));
    },
  );
  test(
    'resume without trusted hold metadata cannot reenable payment',
    () async {
      resume.result = const ApiSuccessResult(
        data: SubscriptionBillingResumeEntity(
          subscriptionId: 'subscription',
          paymentUrl: 'https://example.com/renewed',
          holdExpiresAtUtc: null,
          finalPrice: 100,
          paymentStatus: 'PendingPayment',
        ),
      );
      vm.doIntent(const InitCheckoutSessionEvent(checkout));
      await pumpEventQueue();
      vm.doIntent(const RenewPaymentHoldEvent());
      await pumpEventQueue();
      expect(vm.state.checkout, same(checkout));
      expect(vm.state.checkoutFailure, isNotNull);
    },
  );
  test('pending launched charge cannot be replaced by hold renewal', () async {
    vm.doIntent(const InitCheckoutSessionEvent(checkout));
    await pumpEventQueue();
    vm.doIntent(const MarkPaymentLaunchedEvent());
    vm.doIntent(const RenewPaymentHoldEvent());
    await pumpEventQueue();
    expect(resume.calls, 0);
    expect(vm.state.checkout, same(checkout));
    expect(vm.state.checkout?.paymentUrl, 'https://example.com/expired');
    expect(vm.state.isHoldRenewing, false);
    expect(
      vm.state.isPaymentPending,
      false,
    ); // Original web route remains mounted for callbacks.
  });
  test(
    'only a server-confirmed terminal failure allows launched checkout renewal',
    () async {
      status.status = const PaymentStatusEntity(
        paymentStatus: 'Expired',
        isPaid: false,
        isFailed: true,
        amount: 100,
        currencyCode: 'KWD',
      );
      vm.doIntent(const InitCheckoutSessionEvent(checkout));
      await pumpEventQueue();
      vm.doIntent(const MarkPaymentLaunchedEvent());
      vm.doIntent(const RenewPaymentHoldEvent());
      await pumpEventQueue();
      expect(resume.calls, 1);
      expect(vm.state.checkout?.paymentUrl, 'https://example.com/renewed');
    },
  );
  test('family payment never calls individual resume endpoint', () async {
    vm.doIntent(const InitCheckoutSessionEvent(checkout, flowType: 'family'));
    await pumpEventQueue();
    vm.doIntent(const RenewPaymentHoldEvent());
    await pumpEventQueue();
    expect(resume.calls, 0);
  });
}
