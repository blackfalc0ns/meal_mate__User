import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_campaign_payment_status_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/start_campaign_payment_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/campaign_payment_event.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/campaign_payment_view_model.dart';

class MockOffersRepository implements OffersRepository {
  ApiResult<CampaignPaymentEntity>? startPaymentResult;
  final List<ApiResult<CampaignPaymentEntity>> statusResults = [];
  int statusCallCount = 0;
  StartCampaignPaymentRequestEntity? lastStartRequest;

  @override
  Future<ApiResult<CampaignPaymentEntity>> startCampaignPayment(
    StartCampaignPaymentRequestEntity request,
  ) async {
    lastStartRequest = request;
    return startPaymentResult!;
  }

  @override
  Future<ApiResult<CampaignPaymentEntity>> getCampaignPaymentStatus(
    String sessionId,
  ) async {
    statusCallCount++;
    if (statusResults.isNotEmpty) {
      return statusResults.removeAt(0);
    }
    return startPaymentResult!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockOffersRepository repository;
  late StartCampaignPaymentUseCase startUseCase;
  late GetCampaignPaymentStatusUseCase getStatusUseCase;
  late CampaignPaymentViewModel viewModel;

  setUp(() {
    repository = MockOffersRepository();
    startUseCase = StartCampaignPaymentUseCase(repository);
    getStatusUseCase = GetCampaignPaymentStatusUseCase(repository);
    viewModel = CampaignPaymentViewModel.withSchedule(
      startUseCase,
      getStatusUseCase,
      backoffScheduleOverride: () => [
        Duration.zero,
        Duration.zero,
        Duration.zero,
      ],
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  group('CampaignPaymentViewModel Tests', () {
    test('initial state is idle and clean', () {
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.isPolling, false);
      expect(viewModel.state.status, CampaignPaymentStatus.pending);
      expect(viewModel.state.sessionId, isNull);
      expect(viewModel.state.paymentId, isNull);
      expect(viewModel.state.paymentUrl, isNull);
    });

    test(
      'start payment success stores sessionId, paymentUrl, and stable idempotencyKey',
      () async {
        repository.startPaymentResult = const ApiSuccessResult(
          data: CampaignPaymentEntity(
            sessionId: 'session-123',
            paymentId: 'pz-111',
            paymentUrl: 'https://pay.test/pz-111',
            amount: 12.5,
            currency: 'KWD',
            status: CampaignPaymentStatus.pending,
            rawStatus: 'Pending',
          ),
        );

        viewModel.doIntent(const StartPaymentIntent(sessionId: 'session-123'));

        // Wait for async processing
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.sessionId, 'session-123');
        expect(viewModel.state.paymentId, 'pz-111');
        expect(viewModel.state.paymentUrl, 'https://pay.test/pz-111');
        expect(viewModel.state.amount, 12.5);
        expect(viewModel.state.idempotencyKey, isNotNull);
        expect(
          viewModel.state.idempotencyKey,
          repository.lastStartRequest?.idempotencyKey,
        );
      },
    );

    test('parallel start payment taps are suppressed while loading', () async {
      repository.startPaymentResult = const ApiSuccessResult(
        data: CampaignPaymentEntity(
          sessionId: 'session-123',
          status: CampaignPaymentStatus.pending,
          rawStatus: 'Pending',
        ),
      );

      // Trigger first intent
      viewModel.doIntent(const StartPaymentIntent(sessionId: 'session-123'));
      expect(viewModel.state.isLoading, true);

      // Trigger second intent while still loading
      viewModel.doIntent(const StartPaymentIntent(sessionId: 'session-123'));

      await Future<void>.delayed(Duration.zero);
      expect(repository.lastStartRequest?.sessionId, 'session-123');
    });

    test(
      'retry keeps the SAME idempotency key as the failed attempt',
      () async {
        repository.startPaymentResult = ApiErrorResult(
          failure: Failure(
            errorMessage: 'Server Busy',
            code: 'ServiceUnavailable',
            exception: const ApiException(
              errorType: ApiErrorType.serverError,
              statusCode: 503,
              message: 'Server Busy',
            ),
          ),
        );

        viewModel.doIntent(
          const StartPaymentIntent(sessionId: 'session-retry'),
        );
        await Future<void>.delayed(Duration.zero);

        final originalKey = viewModel.state.idempotencyKey;
        expect(originalKey, isNotNull);
        expect(viewModel.state.serverErrorCode, 'ServiceUnavailable');

        // Now set success for retry
        repository.startPaymentResult = const ApiSuccessResult(
          data: CampaignPaymentEntity(
            sessionId: 'session-retry',
            paymentUrl: 'https://pay.test/retry',
            status: CampaignPaymentStatus.pending,
            rawStatus: 'Pending',
          ),
        );

        viewModel.doIntent(const RetryPaymentIntent());
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.state.idempotencyKey, originalKey);
        expect(repository.lastStartRequest?.idempotencyKey, originalKey);
        expect(viewModel.state.paymentUrl, 'https://pay.test/retry');
      },
    );

    test(
      'polling continues on Pending and stops when terminal Paid arrives',
      () async {
        repository.statusResults.addAll([
          const ApiSuccessResult(
            data: CampaignPaymentEntity(
              sessionId: 'session-poll',
              status: CampaignPaymentStatus.pending,
              rawStatus: 'Pending',
            ),
          ),
          const ApiSuccessResult(
            data: CampaignPaymentEntity(
              sessionId: 'session-poll',
              status: CampaignPaymentStatus.pending,
              rawStatus: 'Pending',
            ),
          ),
          const ApiSuccessResult(
            data: CampaignPaymentEntity(
              sessionId: 'session-poll',
              status: CampaignPaymentStatus.paid,
              rawStatus: 'Paid',
              isPaid: true,
              subscriptionId: 'sub-created-999',
            ),
          ),
        ]);

        viewModel.doIntent(
          const HandleReturnIntent(
            sessionId: 'session-poll',
            paymentId: 'pz-poll',
          ),
        );

        // Allow polling loop to run with Duration.zero backoff
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(viewModel.state.isPolling, false);
        expect(viewModel.state.status, CampaignPaymentStatus.paid);
        expect(viewModel.state.isSuccess, true);
        expect(viewModel.state.subscriptionId, 'sub-created-999');
        expect(repository.statusCallCount, 3);
      },
    );

    test('polling stops immediately when terminal Failed arrives', () async {
      repository.statusResults.addAll([
        const ApiSuccessResult(
          data: CampaignPaymentEntity(
            sessionId: 'session-fail',
            status: CampaignPaymentStatus.failed,
            rawStatus: 'Failed',
            isFailed: true,
          ),
        ),
      ]);

      viewModel.doIntent(const HandleReturnIntent(sessionId: 'session-fail'));

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(viewModel.state.isPolling, false);
      expect(viewModel.state.status, CampaignPaymentStatus.failed);
      expect(viewModel.state.isFailed, true);
      expect(repository.statusCallCount, 1);
    });

    test('polling stops immediately on 404 or 409 error', () async {
      repository.statusResults.addAll([
        ApiErrorResult(
          failure: Failure(
            errorMessage: 'Session Expired',
            code: 'SessionExpired',
            exception: const ApiException(
              errorType: ApiErrorType.conflict,
              statusCode: 409,
              message: 'Session Expired',
            ),
          ),
        ),
      ]);

      viewModel.doIntent(
        const HandleReturnIntent(sessionId: 'session-conflict'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(viewModel.state.isPolling, false);
      expect(viewModel.state.serverErrorCode, 'SessionExpired');
      expect(repository.statusCallCount, 1);
    });

    test('disposal cancels active polling loop cleanly', () async {
      repository.statusResults.addAll([
        const ApiSuccessResult(
          data: CampaignPaymentEntity(
            sessionId: 'session-dispose',
            status: CampaignPaymentStatus.pending,
            rawStatus: 'Pending',
          ),
        ),
      ]);

      viewModel.doIntent(
        const HandleReturnIntent(sessionId: 'session-dispose'),
      );
      await viewModel.close();

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(repository.statusCallCount, lessThanOrEqualTo(2));
    });
  });
}
