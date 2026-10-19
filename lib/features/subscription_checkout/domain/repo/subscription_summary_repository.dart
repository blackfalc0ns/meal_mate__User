import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_pricing_preview_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_restaurant_availability_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

abstract interface class SubscriptionSummaryRepository {
  Future<ApiResult<SubscriptionSummaryEntity>> getSummary(
    SubscriptionSummaryRequestEntity request,
  );

  Future<ApiResult<SubscriptionRestaurantAvailabilityEntity>>
  getRestaurantAvailability(SubscriptionSummaryRequestEntity request);

  Future<ApiResult<SubscriptionReadinessEntity>> getReadiness(
    SubscriptionSummaryRequestEntity request,
  );

  Future<ApiResult<SubscriptionPricingPreviewResponseDto>> getPricingPreview(
    SubscriptionSummaryRequestEntity request,
  );
}
