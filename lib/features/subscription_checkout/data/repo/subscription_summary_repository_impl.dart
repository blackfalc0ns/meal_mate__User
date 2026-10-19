import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/data_source/subscription_summary_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_availability_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_summary_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/request/subscription_pricing_preview_request_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_pricing_preview_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_restaurant_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';

@Injectable(as: SubscriptionSummaryRepository)
class SubscriptionSummaryRepositoryImpl
    implements SubscriptionSummaryRepository {
  SubscriptionSummaryRepositoryImpl(this._remoteDataSource);

  final SubscriptionSummaryRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<SubscriptionSummaryEntity>> getSummary(
    SubscriptionSummaryRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSummary(request);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionRestaurantAvailabilityEntity>>
  getRestaurantAvailability(SubscriptionSummaryRequestEntity request) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getRestaurantAvailability(
        request,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionReadinessEntity>> getReadiness(
    SubscriptionSummaryRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getReadiness(request);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionPricingPreviewResponseDto>> getPricingPreview(
    SubscriptionSummaryRequestEntity request,
  ) {
    return safeApiCall(() async {
      final dto = SubscriptionPricingPreviewRequestDto(
        programId: request.programId,
        bundleId: request.bundleId,
        tier: request.tier,
        durationDays: request.durationDays,
        offerId: request.offerId,
        promoCode: request.promoCode,
        includeFriday: request.includeFriday,
      );
      return await _remoteDataSource.getPricingPreview(dto);
    });
  }
}
