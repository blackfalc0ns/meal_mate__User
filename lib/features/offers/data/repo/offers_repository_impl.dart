import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:dio/dio.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_checkout_session_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/services/campaign_checkout_attempt_store.dart';
import 'package:meal_meat_user/features/offers/data/services/campaign_payment_attempt_store.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_flow_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_quote_request_entity.dart';
import 'package:meal_meat_user/features/offers/data/mapper/campaign_flow_mapper.dart';
import 'package:meal_meat_user/features/offers/data/models/request/campaign_quote_request_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/offers/data/data_source/offers_remote_data_source.dart';
import 'package:meal_meat_user/features/offers/data/mapper/campaign_payment_mapper.dart';
import 'package:meal_meat_user/features/offers/data/mapper/offer_mapper.dart';
import 'package:meal_meat_user/features/offers/data/mapper/offer_purchase_options_mapper.dart';
import 'package:meal_meat_user/features/offers/data/models/request/create_campaign_checkout_session_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/evaluate_offer_discount_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/validate_discount_request_dto.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_session_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_calendar_entry_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_eligible_restaurant_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_evaluation_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_hub_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/validate_discount_result_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@Injectable(as: OffersRepository)
class OffersRepositoryImpl implements OffersRepository {
  const OffersRepositoryImpl(
    this._remoteDataSource,
    this._tokenService, {
    this.campaignPaymentAttemptStore,
    this.campaignCheckoutAttemptStore,
  });

  final CampaignCheckoutAttemptStore? campaignCheckoutAttemptStore;

  final CampaignPaymentAttemptStore? campaignPaymentAttemptStore;

  final OffersRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;

  @override
  Future<ApiResult<List<OfferEntity>>> getAvailableOffers({
    double? cartAmount,
    int? durationDays,
    String? deliveryGovernorate,
    String? programId,
    String? bundleId,
    String? restaurantId,
    int? page,
    int? pageSize,
    String? search,
    String? category,
    bool? eligibleOnly,
    bool? includeCampaigns,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getAvailableOffers(
        cartAmount: (cartAmount != null && cartAmount > 0) ? cartAmount : null,
        durationDays: durationDays,
        deliveryGovernorate: deliveryGovernorate,
        programId: programId,
        bundleId: bundleId,
        restaurantId: restaurantId,
        page: page,
        pageSize: pageSize,
        search: search,
        category: category,
        eligibleOnly: eligibleOnly,
        includeCampaigns: includeCampaigns,
      );
      return response.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<OffersHubEntity>> getOffersHub() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getOffersHub();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<OfferEntity>> getOfferDetails(String offerId) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getOfferPurchaseDetails(offerId);
      final offer = response.offer;
      if (offer == null) {
        throw const FormatException('Offer details missing offer');
      }
      return offer.toEntity().copyWith(
        serverNowUtc: DateTime.tryParse(response.serverNowUtc ?? ''),
        serverObservedAtUtc: DateTime.now().toUtc(),
      );
    });
  }

  @override
  Future<ApiResult<OfferPurchaseOptionsEntity>> getOfferPurchaseOptions(
    String offerId, {
    String? startDate,
    bool? includeFriday,
  }) => safeApiCall(() async {
    final response = await _remoteDataSource.getOfferPurchaseOptions(
      offerId,
      startDate: startDate,
      includeFriday: includeFriday,
    );
    return response.toEntity(fallbackOfferId: offerId);
  });

  @override
  Future<ApiResult<List<OfferEligibleRestaurantEntity>>>
  getOfferEligibleRestaurants(String offerId) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getOfferEligibleRestaurants(
        offerId,
      );
      return response.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<OfferEntity>>> getSavedOffers() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSavedOffers();
      return response.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<void>> saveOffer(String offerId) {
    return safeApiCall(() async {
      await _remoteDataSource.saveOffer(offerId);
    });
  }

  @override
  Future<ApiResult<void>> unsaveOffer(String offerId) {
    return safeApiCall(() async {
      await _remoteDataSource.unsaveOffer(offerId);
    });
  }

  @override
  Future<ApiResult<List<OfferCalendarEntryEntity>>> getOfferCalendar() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getOfferCalendar();
      return response.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<OfferCalendarEntryEntity>> addOfferToCalendar(
    String offerId,
    String scheduledDate,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.addOfferToCalendar(
        offerId,
        scheduledDate,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> removeOfferFromCalendar(String offerId, String date) {
    return safeApiCall(() async {
      await _remoteDataSource.removeOfferFromCalendar(offerId, date);
    });
  }

  @override
  Future<ApiResult<ValidateDiscountResultEntity>> validateDiscount({
    required String code,
    dynamic programId,
    dynamic bundleId,
  }) {
    return safeApiCall(() async {
      final request = ValidateDiscountRequestDto(
        code: code,
        programId: programId,
        bundleId: bundleId,
      );
      final response = await _remoteDataSource.validateDiscount(request);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<OfferEvaluationEntity>> evaluateOffer({
    String? offerId,
    String? promoCode,
    double cartAmount = 0.0,
    int durationDays = 26,
    String? deliveryGovernorate,
    String? programId,
    String? bundleId,
    String? restaurantId,
  }) {
    return safeApiCall(() async {
      final customerId = await _tokenService.getCurrentUserId();
      final hasPromo = promoCode != null && promoCode.trim().isNotEmpty;
      final request = EvaluateOfferDiscountRequestDto(
        offerId: offerId,
        customerId: customerId ?? '',
        cartAmount: cartAmount,
        durationDays: durationDays,
        deliveryGovernorate: deliveryGovernorate,
        programId: programId,
        bundleId: bundleId,
        restaurantId: restaurantId,
        hasPromoCode: hasPromo,
        promoCode: hasPromo ? promoCode.trim().toUpperCase() : null,
      );
      final response = await _remoteDataSource.evaluateOffer(request);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CampaignSessionEntity>> createCampaignCheckoutSession({
    double? expectedFinalPrice,
    String? quoteId,
    String? idempotencyKey,
    required String campaignId,
    required String bundleId,
    required int durationDays,
    List<String>? requestedServiceDates,
    String? deliveryGovernorate,
  }) {
    return safeApiCall(() async {
      final customerId = await _tokenService.getCurrentUserId();
      if (customerId == null || customerId.isEmpty) {
        throw StateError('Authenticated customer id is required');
      }
      final request = CreateCampaignCheckoutSessionRequestDto(
        quoteId: quoteId,
        idempotencyKey: idempotencyKey,
        campaignId: campaignId,
        bundleId: bundleId,
        customerId: customerId,
        durationDays: durationDays,
        requestedServiceDates: requestedServiceDates,
        deliveryGovernorate: deliveryGovernorate,
      );
      final persisted = quoteId == null
          ? request
          : await campaignCheckoutAttemptStore?.restoreOrSave(
                  request,
                  expectedFinalPrice: expectedFinalPrice,
                ) ??
                request;
      final response = await _createCampaignSession(persisted);
      if (quoteId != null && response.sessionId?.isNotEmpty == true) {
        await campaignCheckoutAttemptStore?.saveSession(customerId, {
          ...response.toJson(),
          'campaignId': campaignId,
          'bundleId': bundleId,
          'customerId': customerId,
          'durationDays': durationDays,
        });
      }
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CampaignPaymentEntity>> startCampaignPayment(
    StartCampaignPaymentRequestEntity request,
  ) {
    return safeApiCall(() async {
      final persisted =
          await campaignPaymentAttemptStore?.restoreOrSave(request) ?? request;
      final response = await _remoteDataSource.startCampaignPayment(
        persisted.sessionId,
        persisted.toDto(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CampaignPaymentEntity>> getCampaignPaymentStatus(
    String sessionId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCampaignPaymentStatus(
        sessionId,
      );
      final payment = response.toEntity();
      if (payment.isTerminal) {
        final owner = await _tokenService.getCurrentUserId();
        if (owner != null) {
          final saved = await campaignCheckoutAttemptStore?.readSession(owner);
          if (saved?['sessionId'] == sessionId) {
            await campaignCheckoutAttemptStore?.clearPending(owner);
          }
        }
      }
      return payment;
    });
  }

  @override
  Future<ApiResult<CampaignPageEntity>> getCampaigns({
    int pageSize = 20,
    String? cursor,
  }) => safeApiCall(
    () async => (await _remoteDataSource.getCampaigns(
      pageSize: pageSize,
      cursor: cursor,
    )).toEntity(),
  );
  @override
  Future<ApiResult<CampaignDetailsEntity>> getCampaignDetails(
    String campaignId, {
    String? bundleId,
    int? durationDays,
  }) => safeApiCall(
    () async => (await _remoteDataSource.getCampaignDetails(
      campaignId,
      bundleId: bundleId,
      durationDays: durationDays,
    )).toEntity(),
  );
  @override
  Future<ApiResult<CampaignQuoteEntity>> getCampaignQuote(
    CampaignQuoteRequestEntity request,
  ) => safeApiCall(() async {
    final customerId = await _tokenService.getCurrentUserId();
    if (customerId == null || customerId.isEmpty) {
      throw StateError('Authenticated customer id is required');
    }
    return (await _remoteDataSource.getCampaignQuote(
      CampaignQuoteRequestDto(
        customerId: customerId,
        campaignId: request.campaignId,
        programId: request.programId,
        campaignBundleId: request.campaignBundleId,
        durationDays: request.durationDays,
        startDate: request.startDate,
        addressId: request.addressId,
        promoCode: request.promoCode,
      ),
    )).toEntity();
  });
  @override
  Future<ApiResult<CampaignSessionEntity?>> restoreCampaignCheckoutSession() =>
      safeApiCall(() async {
        final owner = await _tokenService.getCurrentUserId();
        if (owner == null || owner.isEmpty) {
          throw StateError('Authenticated customer is required');
        }
        final pending = await campaignCheckoutAttemptStore?.readPending(owner);
        if (pending == null) return null;
        final saved = await campaignCheckoutAttemptStore?.readSession(owner);
        if (saved != null) {
          final response = CampaignCheckoutSessionResponseDto.fromJson(saved);
          await _validateCampaignPrice(owner, response);
          return response.toEntity();
        }
        final response = await _createCampaignSession(pending);
        if (response.sessionId?.isNotEmpty != true) {
          throw StateError('Campaign session missing');
        }
        final data = {
          ...response.toJson(),
          'campaignId': pending.campaignId,
          'bundleId': pending.bundleId,
          'customerId': owner,
          'durationDays': pending.durationDays,
        };
        await campaignCheckoutAttemptStore?.saveSession(owner, data);
        return CampaignCheckoutSessionResponseDto.fromJson(data).toEntity();
      });
  Future<CampaignCheckoutSessionResponseDto> _createCampaignSession(
    CreateCampaignCheckoutSessionRequestDto request,
  ) async {
    try {
      final response = await _remoteDataSource.createCampaignCheckoutSession(
        request,
      );
      await _validateCampaignPrice(request.customerId, response);
      return response;
    } on DioException catch (error) {
      final failure = ServerFailure.fromDioError(dioException: error);
      if (const {
        'Campaign.SelectionMismatch',
        'campaign.invalid_start_date',
        'Campaign.ScheduleUnavailable',
        'Campaign.QuoteStale',
        'Campaign.QuoteExpired',
        'Campaign.NoLongerAvailable',
        'Campaign.QuoteNotFound',
        'Campaign.CapacityUnavailable',
        'Campaign.Ineligible',
        'campaign.pricing_policy_not_approved',
      }.contains(failure.code)) {
        final pending = await campaignCheckoutAttemptStore?.readPending(
          request.customerId,
        );
        if (pending?.quoteId == request.quoteId) {
          await campaignCheckoutAttemptStore?.clearPending(request.customerId);
        }
      }
      rethrow;
    }
  }

  @override
  Future<ApiResult<void>> cancelCampaignSubscription(String subscriptionId) =>
      safeApiCall(
        () => _remoteDataSource.cancelCampaignSubscription(subscriptionId),
      );
  Future<void> _validateCampaignPrice(
    String owner,
    CampaignCheckoutSessionResponseDto response,
  ) async {
    final expected = await campaignCheckoutAttemptStore?.readExpectedPrice(
      owner,
    );
    if (expected != null && response.finalCustomerPrice != expected) {
      throw const ApiException(
        errorType: ApiErrorType.conflict,
        message: 'Campaign.SelectionMismatch',
        backendErrorCode: 'Campaign.SelectionMismatch',
      );
    }
  }
}
