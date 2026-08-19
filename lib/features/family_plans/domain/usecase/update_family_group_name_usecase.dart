import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_plans_repository.dart';

@injectable
class UpdateFamilyGroupNameUseCase {
  UpdateFamilyGroupNameUseCase(this._repository);

  final FamilyPlansRepository _repository;

  Future<ApiResult<FamilyGroupEntity>> call(FamilyGroupRequestEntity request) {
    return _repository.updateGroup(request);
  }
}
