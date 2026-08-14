import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

abstract interface class SubscriptionSummaryRemoteDataSource {
  Future<SubscriptionSummaryResponseDto> getSummary(
    SubscriptionSummaryRequestEntity request,
  );
}
