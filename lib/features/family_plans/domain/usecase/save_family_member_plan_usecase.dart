import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_subscription_repository.dart';

@injectable
class SaveFamilyMemberPlanUseCase {
  SaveFamilyMemberPlanUseCase(this._repository);

  final FamilySubscriptionRepository _repository;

  Future<ApiResult<FamilyFlowCurrentEntity>> call({
    required String memberId,
    required String programId,
    required String bundleId,
    required int tier,
    required int durationDays,
    required bool includeFriday,
  }) {
    return _repository.saveFamilyMemberPlan(
      memberId: memberId,
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      durationDays: durationDays,
      includeFriday: includeFriday,
    );
  }
}
