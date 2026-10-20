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
  const OffersRepositoryImpl(this._remoteDataSource, this._tokenService);

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
        campaignId: campaignId,
        bundleId: bundleId,
        customerId: customerId,
        durationDays: durationDays,
        requestedServiceDates: requestedServiceDates,
        deliveryGovernorate: deliveryGovernorate,
      );
      final response = await _remoteDataSource.createCampaignCheckoutSession(
        request,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CampaignPaymentEntity>> startCampaignPayment(
    StartCampaignPaymentRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.startCampaignPayment(
        request.sessionId,
        request.toDto(),
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
      return response.toEntity();
    });
  }
}
