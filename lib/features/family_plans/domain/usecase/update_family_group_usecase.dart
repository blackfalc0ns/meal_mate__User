import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_subscription_repository.dart';

@injectable
class UpdateFamilyGroupUseCase {
  UpdateFamilyGroupUseCase(this._repository);

  final FamilySubscriptionRepository _repository;

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
