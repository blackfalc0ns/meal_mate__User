import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

abstract interface class SubscriptionSummaryRepository {
  Future<ApiResult<SubscriptionSummaryEntity>> getSummary(
    SubscriptionSummaryRequestEntity request,
  );
}
