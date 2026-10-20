import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/offers/data/data_source/offers_remote_data_source.dart';
import 'package:meal_meat_user/features/offers/data/models/request/create_campaign_checkout_session_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/evaluate_offer_discount_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/get_customer_available_offers_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/start_campaign_payment_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_checkout_session_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_payment_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/evaluate_offer_discount_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/repo/offers_repository_impl.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_campaign_payment_status_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/start_campaign_payment_usecase.dart';

class FakeOffersRemoteDataSource implements OffersRemoteDataSource {
  GetCustomerAvailableOffersRequestDto? availableOffersRequest;
  CampaignPaymentResponseDto? startPaymentResult;
  CampaignPaymentResponseDto? getStatusResult;
  Exception? exceptionToThrow;

  @override
  Future<CampaignPaymentResponseDto> startCampaignPayment(
    String sessionId,
    StartCampaignPaymentRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return startPaymentResult!;
  }

  @override
  Future<CampaignPaymentResponseDto> getCampaignPaymentStatus(
    String sessionId,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return getStatusResult!;
  }

  @override
  Future<CampaignCheckoutSessionResponseDto> createCampaignCheckoutSession(
    CreateCampaignCheckoutSessionRequestDto request,
  ) => throw UnimplementedError();

  @override
  Future<EvaluateOfferDiscountResponseDto> evaluateOffer(
    EvaluateOfferDiscountRequestDto request,
  ) => throw UnimplementedError();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeTokenService implements TokenService {
  @override
  Future<String?> getCurrentUserId() async => 'user-123';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MissingCustomerTokenService implements TokenService {
  @override
  Future<String?> getCurrentUserId() async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeOffersRemoteDataSource fakeRemoteDataSource;
  late FakeTokenService fakeTokenService;
  late OffersRepositoryImpl repository;

  setUp(() {
    fakeRemoteDataSource = FakeOffersRemoteDataSource();
    fakeTokenService = FakeTokenService();
    repository = OffersRepositoryImpl(fakeRemoteDataSource, fakeTokenService);
  });

  group('OffersRepositoryImpl Campaign Payment Tests', () {
    test(
      'does not send a fabricated customer id when authentication is missing',
      () async {
        final missingTokenRepository = OffersRepositoryImpl(
          fakeRemoteDataSource,
          MissingCustomerTokenService(),
        );

        final result = await missingTokenRepository.getAvailableOffers();

        expect(result, isA<ApiErrorResult<List<OfferEntity>>>());
        expect(fakeRemoteDataSource.availableOffersRequest, isNull);
      },
    );

    test('startCampaignPayment returns success mapped entity', () async {
      fakeRemoteDataSource.startPaymentResult =
          const CampaignPaymentResponseDto(
            sessionId: 'sess-1',
            paymentId: 'pz-1',
            paymentUrl: 'https://pay.test/1',
            amount: 25.0,
            currency: 'KWD',
            status: 'Pending',
          );

      final result = await repository.startCampaignPayment(
        const StartCampaignPaymentRequestEntity(
          sessionId: 'sess-1',
          idempotencyKey: 'key-1',
        ),
      );

      expect(result, isA<ApiSuccessResult<CampaignPaymentEntity>>());
      final data = (result as ApiSuccessResult<CampaignPaymentEntity>).data;
      expect(data.sessionId, 'sess-1');
      expect(data.paymentId, 'pz-1');
      expect(data.paymentUrl, 'https://pay.test/1');
      expect(data.amount, 25.0);
      expect(data.status, CampaignPaymentStatus.pending);
    });

    test(
      'getCampaignPaymentStatus returns success mapped entity for terminal Paid',
      () async {
        fakeRemoteDataSource.getStatusResult = const CampaignPaymentResponseDto(
          sessionId: 'sess-1',
          paymentId: 'pz-1',
          status: 'Paid',
          isPaid: true,
          isFailed: false,
          amount: 25.0,
          currency: 'KWD',
          subscriptionId: 'sub-789',
        );

        final result = await repository.getCampaignPaymentStatus('sess-1');

        expect(result, isA<ApiSuccessResult<CampaignPaymentEntity>>());
        final data = (result as ApiSuccessResult<CampaignPaymentEntity>).data;
        expect(data.sessionId, 'sess-1');
        expect(data.status, CampaignPaymentStatus.paid);
        expect(data.isAuthoritativePaid, true);
        expect(data.subscriptionId, 'sub-789');
      },
    );

    test(
      'startCampaignPayment propagates DioException typed failure (e.g. 409 conflict)',
      () async {
        fakeRemoteDataSource.exceptionToThrow = DioException(
          requestOptions: RequestOptions(
            path: '/api/v1/customer/campaigns/sess-1/payment',
          ),
          response: Response(
            statusCode: 409,
            data: {'errorCode': 'SessionExpired', 'message': 'Session expired'},
            requestOptions: RequestOptions(
              path: '/api/v1/customer/campaigns/sess-1/payment',
            ),
          ),
          type: DioExceptionType.badResponse,
        );

        final result = await repository.startCampaignPayment(
          const StartCampaignPaymentRequestEntity(
            sessionId: 'sess-1',
            idempotencyKey: 'key-1',
          ),
        );

        expect(result, isA<ApiErrorResult<CampaignPaymentEntity>>());
        final failure =
            (result as ApiErrorResult<CampaignPaymentEntity>).failure;
        expect(failure.exception.statusCode, 409);
        expect(failure.code, 'SessionExpired');
      },
    );

    test(
      'getCampaignPaymentStatus propagates DioException typed failure (e.g. 404 not found)',
      () async {
        fakeRemoteDataSource.exceptionToThrow = DioException(
          requestOptions: RequestOptions(
            path: '/api/v1/customer/campaigns/sess-missing/payment',
          ),
          response: Response(
            statusCode: 404,
            data: {
              'errorCode': 'SessionNotFound',
              'message': 'Session not found',
            },
            requestOptions: RequestOptions(
              path: '/api/v1/customer/campaigns/sess-missing/payment',
            ),
          ),
          type: DioExceptionType.badResponse,
        );

        final result = await repository.getCampaignPaymentStatus(
          'sess-missing',
        );

        expect(result, isA<ApiErrorResult<CampaignPaymentEntity>>());
        final failure =
            (result as ApiErrorResult<CampaignPaymentEntity>).failure;
        expect(failure.exception.statusCode, 404);
        expect(failure.code, 'SessionNotFound');
      },
    );

    test('UseCases delegate properly to repository', () async {
      fakeRemoteDataSource.startPaymentResult =
          const CampaignPaymentResponseDto(
            sessionId: 'sess-uc',
            status: 'Pending',
          );
      fakeRemoteDataSource.getStatusResult = const CampaignPaymentResponseDto(
        sessionId: 'sess-uc',
        status: 'Paid',
      );

      final startUseCase = StartCampaignPaymentUseCase(repository);
      final statusUseCase = GetCampaignPaymentStatusUseCase(repository);

      final startRes = await startUseCase(
        const StartCampaignPaymentRequestEntity(
          sessionId: 'sess-uc',
          idempotencyKey: 'k-1',
        ),
      );
      expect(startRes, isA<ApiSuccessResult<CampaignPaymentEntity>>());

      final statusRes = await statusUseCase('sess-uc');
      expect(statusRes, isA<ApiSuccessResult<CampaignPaymentEntity>>());
    });
  });
}
