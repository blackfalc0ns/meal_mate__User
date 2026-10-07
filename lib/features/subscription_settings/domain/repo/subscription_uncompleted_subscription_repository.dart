import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';

abstract interface class SubscriptionUncompletedSubscriptionRepository {
  Future<ApiResult<void>> deleteUncompletedSubscription(String subscriptionId);

  Future<ApiResult<SubscriptionBillingResumePreviewEntity>> getResumePreview(
    String subscriptionId,
  );

  Future<ApiResult<SubscriptionBillingResumeEntity>> resumeSubscription({
    required String subscriptionId,
    String? startDate,
    int? paymentMethodId,
  });
}
