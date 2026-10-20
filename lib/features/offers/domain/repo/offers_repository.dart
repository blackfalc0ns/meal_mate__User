import 'package:meal_meat_user/core/network/api_results.dart';
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

abstract interface class OffersRepository {
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
  });

  Future<ApiResult<OffersHubEntity>> getOffersHub();

  Future<ApiResult<OfferEntity>> getOfferDetails(String offerId);

  Future<ApiResult<OfferPurchaseOptionsEntity>> getOfferPurchaseOptions(
    String offerId, {String? startDate, bool? includeFriday});

  Future<ApiResult<List<OfferEligibleRestaurantEntity>>>
  getOfferEligibleRestaurants(String offerId);

  Future<ApiResult<List<OfferEntity>>> getSavedOffers();

  Future<ApiResult<void>> saveOffer(String offerId);

  Future<ApiResult<void>> unsaveOffer(String offerId);

  Future<ApiResult<List<OfferCalendarEntryEntity>>> getOfferCalendar();

  Future<ApiResult<OfferCalendarEntryEntity>> addOfferToCalendar(
    String offerId,
    String scheduledDate,
  );

  Future<ApiResult<void>> removeOfferFromCalendar(String offerId, String date);

  Future<ApiResult<ValidateDiscountResultEntity>> validateDiscount({
    required String code,
    dynamic programId,
    dynamic bundleId,
  });

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
