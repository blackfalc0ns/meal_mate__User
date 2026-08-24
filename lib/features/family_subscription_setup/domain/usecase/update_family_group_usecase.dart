import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';

@injectable
class UpdateFamilyGroupUseCase {
  UpdateFamilyGroupUseCase(this._repository);

  final FamilySubscriptionSetupRepository _repository;

  Future<ApiResult<FamilyFlowCurrentEntity>> call({
    required String name,
    String? familyPackageId,
  }) {
    return _repository.updateFamilyGroup(
      name: name,
      familyPackageId: familyPackageId,
    );
  }
}
