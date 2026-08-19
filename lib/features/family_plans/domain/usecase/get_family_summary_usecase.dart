import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/repo/family_plans_repository.dart';

@injectable
class GetFamilySummaryUseCase {
  GetFamilySummaryUseCase(this._repository);

  final FamilyPlansRepository _repository;

  Future<ApiResult<FamilySummaryEntity>> call({String? memberId}) {
    return _repository.getSummary(memberId: memberId);
  }
}
