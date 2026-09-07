import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';

abstract interface class ProfileUncompletedSubscriptionRepository {
  Future<ApiResult<void>> deleteUncompletedSubscription(String subscriptionId);

  Future<ApiResult<ProfileBillingResumePreviewEntity>> getResumePreview(
    String subscriptionId,
  );

  Future<ApiResult<ProfileBillingResumeEntity>> resumeSubscription({
    required String subscriptionId,
    String? startDate,
    int? paymentMethodId,
  });
}
