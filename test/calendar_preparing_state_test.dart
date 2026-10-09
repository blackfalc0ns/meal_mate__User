import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/repo/payment_repository.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_calendar_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_payment_status_usecase.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_billing_repository.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_billing_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _NoopPaymentRepo implements PaymentRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopBillingRepo implements SubscriptionBillingRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePaymentMethodsUseCase extends GetPaymentMethodsUseCase {
  _FakePaymentMethodsUseCase() : super(_NoopPaymentRepo());

  @override
  Future<ApiResult<List<PaymentMethodEntity>>> call({
    required double amount,
  }) async => const ApiSuccessResult(data: []);
}

class _RecordingCheckoutUseCase extends CheckoutSubscriptionUseCase {
  _RecordingCheckoutUseCase() : super(_NoopPaymentRepo());
  int postCount = 0;

  @override
  Future<ApiResult<PaymentCheckoutEntity>> call(dynamic request) async {
    postCount++;
    return const ApiSuccessResult(
      data: PaymentCheckoutEntity(
        subscriptionId: 'sub-1',
        paymentUrl: 'https://pay.example.com',
        holdExpiresAtUtc: '2026-10-08T12:00:00Z',
        chosenStartDate: '2026-10-08',
        startDate: '2026-10-11',
        finalPrice: 100.0,
        priceSnapshotId: 'price-1',
        restaurantPoolSnapshotId: 'pool-1',
        paymentStatus: 'Pending',
      ),
    );
  }
}

class _FakeGetSubscriptionPaymentStatusUseCase
    extends GetSubscriptionPaymentStatusUseCase {
  _FakeGetSubscriptionPaymentStatusUseCase() : super(_NoopPaymentRepo());

  @override
  Future<ApiResult<PaymentStatusEntity>> call(String subscriptionId) async =>
      const ApiSuccessResult(
        data: PaymentStatusEntity(
          paymentStatus: 'Paid',
          isPaid: true,
          isFailed: false,
          amount: 100,
          currencyCode: 'KWD',
        ),
      );
}

class _FakeCalendarUseCase extends GetSubscriptionCalendarUseCase {
  _FakeCalendarUseCase() : super(_NoopPaymentRepo());

  final List<ApiResult<dynamic>> responses = [];
  Completer<ApiResult<dynamic>>? inFlightCompleter;
  int callCount = 0;

  @override
  Future<ApiResult<dynamic>> call(String subscriptionId) async {
    callCount++;
    if (inFlightCompleter != null) {
      return inFlightCompleter!.future;
    }
    if (responses.isNotEmpty) {
      return responses.removeAt(0);
    }
    return const ApiSuccessResult(
      data: CalendarResponseDto(
        subscriptionId: 'sub-1',
        isFulfillmentReady: true,
        days: [CalendarDayResponseDto(id: 'day-1', date: '2026-10-11')],
      ),
    );
  }
}

class _FakeGetCurrentSubscriptionUseCase
    extends GetCurrentCustomerSubscriptionUseCase {
  _FakeGetCurrentSubscriptionUseCase() : super(_NoopBillingRepo());

  @override
  Future<ApiResult<SubscriptionBillingCurrentEntity>> call() async =>
      const ApiSuccessResult(
        data: SubscriptionBillingCurrentEntity(emptyStateCode: ''),
      );
}

class _FakeBillingUseCase extends GetSubscriptionBillingUseCase {
  _FakeBillingUseCase() : super(_NoopBillingRepo());

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

  late SharedPrefHelper sharedPrefHelper;
  late _RecordingCheckoutUseCase checkoutUseCase;
  late _FakeCalendarUseCase calendarUseCase;
  late PaymentViewModel viewModel;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    sharedPrefHelper = SharedPrefHelper(prefs);
    checkoutUseCase = _RecordingCheckoutUseCase();
    calendarUseCase = _FakeCalendarUseCase();

    viewModel = PaymentViewModel(
      _FakePaymentMethodsUseCase(),
      checkoutUseCase,
      _FakeGetSubscriptionPaymentStatusUseCase(),
      calendarUseCase,
      _FakeGetCurrentSubscriptionUseCase(),
      sharedPrefHelper,
      getSubscriptionBillingUseCase: _FakeBillingUseCase(),
      pollingBackoffOverride: () => [
        Duration.zero,
        Duration.zero,
        Duration.zero,
        Duration.zero,
      ],
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  group('Calendar Fulfillment Preparing State & Polling (Task 6)', () {
    test(
      'GET calendar 409 calendar.fulfillment_not_ready enters preparing state without fake success or additional checkout POSTs',
      () async {
        calendarUseCase.responses.addAll([
          ApiErrorResult(
            failure: Failure(
              code: 'calendar.fulfillment_not_ready',
              errorMessage: 'Calendar is preparing',
              exception: const ApiException(
                errorType: ApiErrorType.conflict,
                backendErrorCode: 'calendar.fulfillment_not_ready',
                message: 'Calendar is preparing',
              ),
            ),
          ),
          ApiErrorResult(
            failure: Failure(
              code: 'calendar.fulfillment_not_ready',
              errorMessage: 'Calendar is preparing',
              exception: const ApiException(
                errorType: ApiErrorType.conflict,
                backendErrorCode: 'calendar.fulfillment_not_ready',
                message: 'Calendar is preparing',
              ),
            ),
          ),
          ApiErrorResult(
            failure: Failure(
              code: 'calendar.fulfillment_not_ready',
              errorMessage: 'Calendar is preparing',
              exception: const ApiException(
                errorType: ApiErrorType.conflict,
                backendErrorCode: 'calendar.fulfillment_not_ready',
                message: 'Calendar is preparing',
              ),
            ),
          ),
          ApiErrorResult(
            failure: Failure(
              code: 'calendar.fulfillment_not_ready',
              errorMessage: 'Calendar is preparing',
              exception: const ApiException(
                errorType: ApiErrorType.conflict,
                backendErrorCode: 'calendar.fulfillment_not_ready',
                message: 'Calendar is preparing',
              ),
            ),
          ),
        ]);

        viewModel.doIntent(const PollSubscriptionCalendarEvent('sub-1'));

        // Wait for polling attempts to complete
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Checkout was NEVER called during calendar polling
        expect(checkoutUseCase.postCount, 0);

        // Calendar should NOT be marked as success
        expect(viewModel.state.isCalendarSuccess, isFalse);

        // Fulfillment should be marked as not ready
        expect(viewModel.state.isCalendarFulfillmentNotReady, isTrue);
      },
    );

    test(
      '200 with empty days remains waiting and does not produce fake success',
      () async {
        calendarUseCase.responses.addAll([
          const ApiSuccessResult(
            data: CalendarResponseDto(
              subscriptionId: 'sub-1',
              isFulfillmentReady: true,
              days: [], // empty days!
            ),
          ),
          const ApiSuccessResult(
            data: CalendarResponseDto(
              subscriptionId: 'sub-1',
              isFulfillmentReady: true,
              days: [],
            ),
          ),
          const ApiSuccessResult(
            data: CalendarResponseDto(
              subscriptionId: 'sub-1',
              isFulfillmentReady: true,
              days: [],
            ),
          ),
          const ApiSuccessResult(
            data: CalendarResponseDto(
              subscriptionId: 'sub-1',
              isFulfillmentReady: true,
              days: [],
            ),
          ),
        ]);

        viewModel.doIntent(const PollSubscriptionCalendarEvent('sub-1'));

        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(viewModel.state.isCalendarSuccess, isFalse);
        expect(viewModel.state.isCalendarFulfillmentNotReady, isTrue);
      },
    );

    test(
      'Transition from 409 to 200 with actual days resolves to calendar success exactly once',
      () async {
        calendarUseCase.responses.addAll([
          ApiErrorResult(
            failure: Failure(
              code: 'calendar.fulfillment_not_ready',
              errorMessage: 'Calendar is preparing',
              exception: const ApiException(
                errorType: ApiErrorType.conflict,
                backendErrorCode: 'calendar.fulfillment_not_ready',
                message: 'Calendar is preparing',
              ),
            ),
          ),
          const ApiSuccessResult(
            data: CalendarResponseDto(
              subscriptionId: 'sub-1',
              isFulfillmentReady: true,
              days: [CalendarDayResponseDto(id: 'day-1', date: '2026-10-11')],
            ),
          ),
        ]);

        viewModel.doIntent(const PollSubscriptionCalendarEvent('sub-1'));

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(viewModel.state.isCalendarSuccess, isTrue);
        expect(viewModel.state.isCalendarLoading, isFalse);
        expect(viewModel.state.calendarFailure, isNull);
      },
    );

    test(
      'Concurrent refresh while calendar is loading does not trigger overlapping polling',
      () async {
        final completer = Completer<ApiResult<dynamic>>();
        calendarUseCase.inFlightCompleter = completer;

        viewModel.doIntent(const PollSubscriptionCalendarEvent('sub-1'));

        // Immediate duplicate trigger while call is in flight
        viewModel.doIntent(const PollSubscriptionCalendarEvent('sub-1'));

        expect(calendarUseCase.callCount, 1);

        completer.complete(
          const ApiSuccessResult(
            data: CalendarResponseDto(
              subscriptionId: 'sub-1',
              isFulfillmentReady: true,
              days: [CalendarDayResponseDto(id: 'day-1', date: '2026-10-11')],
            ),
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(calendarUseCase.callCount, 1);
      },
    );
  });
}
