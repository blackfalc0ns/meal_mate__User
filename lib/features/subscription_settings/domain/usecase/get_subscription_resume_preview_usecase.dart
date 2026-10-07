import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_uncompleted_subscription_repository.dart';

@injectable
class GetSubscriptionResumePreviewUseCase {
  GetSubscriptionResumePreviewUseCase(this._repository);

  final SubscriptionUncompletedSubscriptionRepository _repository;

  Future<ApiResult<SubscriptionBillingResumePreviewEntity>> call(
    String subscriptionId,
  ) {
    return _repository.getResumePreview(subscriptionId);
  }
}
