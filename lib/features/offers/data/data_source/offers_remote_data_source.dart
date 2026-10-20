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

abstract interface class OffersRemoteDataSource {
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
  });

  Future<OffersHubResponseDto> getOffersHub();

  Future<OfferResponseDto> getOfferDetails(String offerId);

  Future<OfferDetailsResponseDto> getOfferPurchaseDetails(String offerId);

  Future<OfferPurchaseOptionsResponseDto> getOfferPurchaseOptions(
    String offerId, {String? startDate, bool? includeFriday});

  Future<List<OfferEligibleRestaurantDto>> getOfferEligibleRestaurants(
    String offerId,
  );

  Future<List<OfferResponseDto>> getSavedOffers();

  Future<void> saveOffer(String offerId);

  Future<void> unsaveOffer(String offerId);

  Future<List<OfferCalendarEntryDto>> getOfferCalendar();

  Future<OfferCalendarEntryDto> addOfferToCalendar(
    String offerId,
    String scheduledDate,
  );

  Future<void> removeOfferFromCalendar(String offerId, String date);

  Future<ValidateDiscountResponseDto> validateDiscount(
    ValidateDiscountRequestDto request,
  );

  Future<EvaluateOfferDiscountResponseDto> evaluateOffer(
    EvaluateOfferDiscountRequestDto request,
  );

  Future<CampaignCheckoutSessionResponseDto> createCampaignCheckoutSession(
    CreateCampaignCheckoutSessionRequestDto request,
  );

  Future<CampaignPaymentResponseDto> startCampaignPayment(
    String sessionId,
    StartCampaignPaymentRequestDto request,
  );

  Future<CampaignPaymentResponseDto> getCampaignPaymentStatus(String sessionId);
}
