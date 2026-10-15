import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/offers/data/data_source/offers_remote_data_source.dart';
import 'package:meal_meat_user/features/offers/data/models/request/create_campaign_checkout_session_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/evaluate_offer_discount_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/get_customer_available_offers_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/start_campaign_payment_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_checkout_session_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_payment_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/evaluate_offer_discount_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';

@Injectable(as: OffersRemoteDataSource)
class OffersRemoteDataSourceImpl implements OffersRemoteDataSource {
  const OffersRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<OfferResponseDto>> getAvailableOffers(
    GetCustomerAvailableOffersRequestDto request,
  ) {
    return _apiServices.getCustomerAvailableOffers(request);
  }

  @override
  Future<OfferResponseDto> getOfferDetails(String offerId) {
    return _apiServices.getCustomerOfferDetails(offerId);
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
}
