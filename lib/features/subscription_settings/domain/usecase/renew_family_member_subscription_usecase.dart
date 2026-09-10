import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/family_management_repository.dart';

@injectable
class RenewFamilyMemberSubscriptionUseCase {
  const RenewFamilyMemberSubscriptionUseCase(this._repository);
  final FamilyManagementRepository _repository;
  Future<ApiResult<void>> call(String renewalPath) =>
      _repository.renewSubscription(renewalPath);
}
