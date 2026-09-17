import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/offers/data/data_source/offers_remote_data_source.dart';
import 'package:meal_meat_user/features/offers/data/mapper/offer_mapper.dart';
import 'package:meal_meat_user/features/offers/data/models/request/create_campaign_checkout_session_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/evaluate_offer_discount_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/get_customer_available_offers_request_dto.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_session_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_evaluation_entity.dart';
import 'package:meal_meat_user/features/offers/domain/repo/offers_repository.dart';

@Injectable(as: OffersRepository)
class OffersRepositoryImpl implements OffersRepository {
  const OffersRepositoryImpl(this._remoteDataSource, this._tokenService);

  final OffersRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;

  @override
  Future<ApiResult<List<OfferEntity>>> getAvailableOffers({
    double cartAmount = 0.0,
    int durationDays = 26,
    String? deliveryGovernorate,
    String? programId,
    String? bundleId,
    String? restaurantId,
  }) {
    return safeApiCall(() async {
      final customerId =
          await _tokenService.getCurrentUserId() ??
          '00000000-0000-0000-0000-000000000000';
      final request = GetCustomerAvailableOffersRequestDto(
        customerId: customerId,
        cartAmount: cartAmount,
        durationDays: durationDays,
        deliveryGovernorate: deliveryGovernorate,
        programId: programId,
        bundleId: bundleId,
        restaurantId: restaurantId,
      );
      final response = await _remoteDataSource.getAvailableOffers(request);
      return response.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<OfferEntity>> getOfferDetails(String offerId) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getOfferDetails(offerId);
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
      final customerId =
          await _tokenService.getCurrentUserId() ??
          '00000000-0000-0000-0000-000000000000';
      final hasPromo = promoCode != null && promoCode.trim().isNotEmpty;
      final request = EvaluateOfferDiscountRequestDto(
        offerId: offerId,
        customerId: customerId,
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
      final customerId =
          await _tokenService.getCurrentUserId() ??
          '00000000-0000-0000-0000-000000000000';
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
}
