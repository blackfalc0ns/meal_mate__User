import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/data_source/subscription_summary_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_readiness_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_restaurant_availability_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

@Injectable(as: SubscriptionSummaryRemoteDataSource)
class SubscriptionSummaryRemoteDataSourceImpl
    implements SubscriptionSummaryRemoteDataSource {
  SubscriptionSummaryRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<SubscriptionSummaryResponseDto> getSummary(
    SubscriptionSummaryRequestEntity request,
  ) {
    return _apiServices.getSubscriptionSummary(
      request.includeFriday,
      request.durationDays,
      request.tier,
      request.bundleId,
      request.programId,
      request.startDate,
      restaurantsPage: request.restaurantsPage,
      restaurantsPageSize: request.restaurantsPageSize,
      promoCode: request.promoCode,
    );
  }

  @override
  Future<SubscriptionRestaurantAvailabilityResponseDto> getRestaurantAvailability(
    SubscriptionSummaryRequestEntity request,
  ) {
    return _apiServices.getSubscriptionRestaurantAvailability(
      request.includeFriday,
      request.durationDays,
      request.tier,
      request.bundleId,
      request.programId,
      request.startDate,
      restaurantsPage: request.restaurantsPage,
      restaurantsPageSize: request.restaurantsPageSize,
    );
  }

  @override
  Future<SubscriptionReadinessResponseDto> getReadiness(
    SubscriptionSummaryRequestEntity request,
  ) {
    return _apiServices.getSubscriptionReadiness(
      request.includeFriday,
      request.durationDays,
      request.tier,
      request.bundleId,
      request.programId,
    );
  }
}
