import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';

@injectable
class DeleteFamilyMemberUseCase {
  DeleteFamilyMemberUseCase(this._repository);

  final FamilySubscriptionSetupRepository _repository;

  Future<ApiResult<FamilyFlowCurrentEntity>> call(String memberId) {
    return _repository.deleteFamilyMember(memberId);
  }
}
