import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_plan_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_plans_repository.dart';

@injectable
class UpdateFamilyMemberPlanUseCase {
  UpdateFamilyMemberPlanUseCase(this._repository);

  final FamilyPlansRepository _repository;

  Future<ApiResult<FamilyGroupEntity>> call({
    required String memberId,
    required FamilyMemberPlanRequestEntity request,
  }) {
    return _repository.updateMemberPlan(memberId: memberId, request: request);
  }
}
