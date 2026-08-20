import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_subscription_repository.dart';

@injectable
class GetFamilyFlowCurrentUseCase {
  GetFamilyFlowCurrentUseCase(this._repository);

  final FamilySubscriptionRepository _repository;

  Future<ApiResult<FamilyFlowCurrentEntity>> call() {
    return _repository.getFamilySubscriptionCurrent();
  }
}
