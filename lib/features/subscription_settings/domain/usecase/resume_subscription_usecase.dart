import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_uncompleted_subscription_repository.dart';

@injectable
class ResumeSubscriptionUseCase {
  ResumeSubscriptionUseCase(this._repository);

  final SubscriptionUncompletedSubscriptionRepository _repository;

  Future<ApiResult<SubscriptionBillingResumeEntity>> call({
    required String subscriptionId,
    String? startDate,
    int? paymentMethodId,
  }) {
    return _repository.resumeSubscription(
      subscriptionId: subscriptionId,
      startDate: startDate,
      paymentMethodId: paymentMethodId,
    );
  }
}
