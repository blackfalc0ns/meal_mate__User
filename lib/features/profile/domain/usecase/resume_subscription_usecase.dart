import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_uncompleted_subscription_repository.dart';

@injectable
class ResumeSubscriptionUseCase {
  const ResumeSubscriptionUseCase(this._repository);

  final ProfileUncompletedSubscriptionRepository _repository;

  Future<ApiResult<ProfileBillingResumeEntity>> call({
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
