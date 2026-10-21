import 'package:meal_meat_user/features/offers/data/models/request/campaign_quote_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_flow_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/offers/data/data_source/offers_remote_data_source.dart';
import 'package:meal_meat_user/features/offers/data/models/request/create_campaign_checkout_session_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/evaluate_offer_discount_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/get_customer_available_offers_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/start_campaign_payment_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/validate_discount_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_checkout_session_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_payment_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/evaluate_offer_discount_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_calendar_entry_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_eligible_restaurant_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_purchase_options_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offers_hub_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/validate_discount_response_dto.dart';

@Injectable(as: OffersRemoteDataSource)
class OffersRemoteDataSourceImpl implements OffersRemoteDataSource {
  const OffersRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<OfferResponseDto>> getAvailableOffers({
    GetCustomerAvailableOffersRequestDto? legacyRequest,
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
    if (includeCampaigns != null) {
      return _apiServices.postCustomerAvailableOffers(
        GetCustomerAvailableOffersRequestDto(
          includeCampaigns: includeCampaigns,
          cartAmount: cartAmount ?? legacyRequest?.cartAmount,
          durationDays: durationDays ?? legacyRequest?.durationDays,
          deliveryGovernorate:
              deliveryGovernorate ?? legacyRequest?.deliveryGovernorate,
          programId: programId ?? legacyRequest?.programId,
          bundleId: bundleId ?? legacyRequest?.bundleId,
          restaurantId: restaurantId ?? legacyRequest?.restaurantId,
        ),
      );
    }
    return _apiServices.getCustomerAvailableOffers(
      cartAmount: cartAmount ?? legacyRequest?.cartAmount,
      durationDays: durationDays ?? legacyRequest?.durationDays,
      deliveryGovernorate:
          deliveryGovernorate ?? legacyRequest?.deliveryGovernorate,
      programId: programId ?? legacyRequest?.programId,
      bundleId: bundleId ?? legacyRequest?.bundleId,
      restaurantId: restaurantId ?? legacyRequest?.restaurantId,
      page: page,
      pageSize: pageSize,
      search: search,
      category: category,
      eligibleOnly: eligibleOnly,
      includeCampaigns: includeCampaigns,
    );
  }

  @override
  Future<OffersHubResponseDto> getOffersHub() {
    return _apiServices.getOffersHub();
  }

  @override
  Future<OfferResponseDto> getOfferDetails(String offerId) {
    return _apiServices.getCustomerOfferDetails(offerId);
  }

  @override
  Future<OfferDetailsResponseDto> getOfferPurchaseDetails(String offerId) =>
      _apiServices.getOfferPurchaseDetails(offerId);

  @override
  Future<OfferPurchaseOptionsResponseDto> getOfferPurchaseOptions(
    String offerId, {
    String? startDate,
    bool? includeFriday,
  }) => _apiServices.getOfferPurchaseOptions(
    offerId,
    startDate: startDate,
    includeFriday: includeFriday,
  );

  @override
  Future<List<OfferEligibleRestaurantDto>> getOfferEligibleRestaurants(
    String offerId,
  ) {
    return _apiServices.getOfferEligibleRestaurants(offerId);
  }

  @override
  Future<List<OfferResponseDto>> getSavedOffers() {
    return _apiServices.getSavedOffers();
  }

  @override
  Future<void> saveOffer(String offerId) {
    return _apiServices.saveOffer(offerId);
  }

  @override
  Future<void> unsaveOffer(String offerId) {
    return _apiServices.unsaveOffer(offerId);
  }

  @override
  Future<List<OfferCalendarEntryDto>> getOfferCalendar() {
    return _apiServices.getOfferCalendar();
  }

  @override
  Future<OfferCalendarEntryDto> addOfferToCalendar(
    String offerId,
    String scheduledDate,
  ) {
    return _apiServices.addOfferToCalendar(offerId, {
      'scheduledDate': scheduledDate,
    });
  }

  @override
  Future<void> removeOfferFromCalendar(String offerId, String date) {
    return _apiServices.removeOfferFromCalendar(offerId, date);
  }

  @override
  Future<ValidateDiscountResponseDto> validateDiscount(
    ValidateDiscountRequestDto request,
  ) {
    return _apiServices.validateDiscount(request);
  }

  @override
  Future<EvaluateOfferDiscountResponseDto> evaluateOffer(
    EvaluateOfferDiscountRequestDto request,
  ) {
    return _apiServices.evaluateOfferDiscount(request);
  }

  @override
  Future<CampaignCheckoutSessionResponseDto> createCampaignCheckoutSession(
    CreateCampaignCheckoutSessionRequestDto request,
  ) {
    return _apiServices.createCampaignCheckoutSession(request);
  }

  @override
  Future<CampaignPaymentResponseDto> startCampaignPayment(
    String sessionId,
    StartCampaignPaymentRequestDto request,
  ) {
    return _apiServices.startCampaignPayment(sessionId, request);
  }

  @override
  Future<CampaignPaymentResponseDto> getCampaignPaymentStatus(
    String sessionId,
  ) {
    return _apiServices.getCampaignPaymentStatus(sessionId);
  }

  @override
  Future<CampaignPageResponseDto> getCampaigns({
    int pageSize = 20,
    String? cursor,
  }) => _apiServices.getCampaigns(pageSize: pageSize, cursor: cursor);
  @override
  Future<CampaignDetailsResponseDto> getCampaignDetails(
    String campaignId, {
    String? bundleId,
    int? durationDays,
  }) => _apiServices.getCampaignDetails(
    campaignId,
    bundleId: bundleId,
    durationDays: durationDays,
  );
  @override
  Future<CampaignQuoteResponseDto> getCampaignQuote(
    CampaignQuoteRequestDto request,
  ) => _apiServices.getCampaignQuote(request);
  @override
  Future<void> cancelCampaignSubscription(String subscriptionId) =>
      _apiServices.cancelCampaignSubscription(subscriptionId);
}
