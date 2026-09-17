import 'package:meal_meat_user/features/offers/data/models/request/create_campaign_checkout_session_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/evaluate_offer_discount_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/get_customer_available_offers_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_checkout_session_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/evaluate_offer_discount_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';

abstract interface class OffersRemoteDataSource {
  Future<List<OfferResponseDto>> getAvailableOffers(
    GetCustomerAvailableOffersRequestDto request,
  );

  Future<OfferResponseDto> getOfferDetails(String offerId);

  Future<EvaluateOfferDiscountResponseDto> evaluateOffer(
    EvaluateOfferDiscountRequestDto request,
  );

  Future<CampaignCheckoutSessionResponseDto> createCampaignCheckoutSession(
    CreateCampaignCheckoutSessionRequestDto request,
  );
}
