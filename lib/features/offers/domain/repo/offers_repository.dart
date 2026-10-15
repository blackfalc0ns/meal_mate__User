import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_session_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_evaluation_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';

abstract interface class OffersRepository {
  Future<ApiResult<List<OfferEntity>>> getAvailableOffers({
    double cartAmount = 0.0,
    int durationDays = 26,
    String? deliveryGovernorate,
    String? programId,
    String? bundleId,
    String? restaurantId,
  });

  Future<ApiResult<OfferEntity>> getOfferDetails(String offerId);

  Future<ApiResult<OfferEvaluationEntity>> evaluateOffer({
    String? offerId,
    String? promoCode,
    double cartAmount = 0.0,
    int durationDays = 26,
    String? deliveryGovernorate,
    String? programId,
    String? bundleId,
    String? restaurantId,
  });

  Future<ApiResult<CampaignSessionEntity>> createCampaignCheckoutSession({
    required String campaignId,
    required String bundleId,
    required int durationDays,
    List<String>? requestedServiceDates,
    String? deliveryGovernorate,
  });

  Future<ApiResult<CampaignPaymentEntity>> startCampaignPayment(
    StartCampaignPaymentRequestEntity request,
  );

  Future<ApiResult<CampaignPaymentEntity>> getCampaignPaymentStatus(
    String sessionId,
  );
}
