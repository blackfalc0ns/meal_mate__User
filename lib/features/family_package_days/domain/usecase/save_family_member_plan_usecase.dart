import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_package_days/domain/repo/family_package_days_repository.dart';

@injectable
class SaveFamilyMemberPlanUseCase {
  SaveFamilyMemberPlanUseCase(this._repository);

  final FamilyPackageDaysRepository _repository;

  Future<ApiResult<FamilyFlowCurrentEntity>> call({
    required String memberId,
    bool clearPlan = false,
    String? programId,
    String? bundleId,
    int? tier,
    int? durationDays,
    bool? includeFriday,
    String? startDate,
  }) {
    return _repository.saveFamilyMemberPlan(
      memberId: memberId,
      clearPlan: clearPlan,
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      durationDays: durationDays,
      includeFriday: includeFriday,
      startDate: startDate,
    );
  }
}
