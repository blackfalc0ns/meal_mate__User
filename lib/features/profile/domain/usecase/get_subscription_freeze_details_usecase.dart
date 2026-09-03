import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@injectable
class GetSubscriptionFreezeDetailsUseCase {
  GetSubscriptionFreezeDetailsUseCase(this._repository);

  final ProfileRepository _repository;

  Future<ApiResult<ProfileBillingFreezeDetailsEntity>> call({
    String? subscriptionId,
  }) {
    if (subscriptionId == null || subscriptionId.isEmpty) {
      return _repository.getCurrentCustomerSubscriptionFreezeDetails();
    }
    return _repository.getCustomerSubscriptionFreezeDetails(subscriptionId);
  }
}
